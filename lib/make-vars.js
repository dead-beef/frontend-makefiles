const fs = require('fs');
const path = require('path');

/** Makefile variable generator class. */
module.exports = class MakeVars {
	/**
	 * Makefile variable generator constructor.
	 * @param {string} root      Root path.
	 * @param {Object} override  Dependency package.json override configuration.
	 */
	constructor(root, override) {
		/**
		 * Root path.
		 * @member {string}
		 */
		this.root = root || path.resolve('./');
		/**
		 * Module read paths.
		 * @member {Array.<string>}
		 */
		this.modulePaths = module.paths
			.filter((path) => fs.existsSync(path))
			.map((path) => fs.realpathSync(path));
		/**
		 * Dependency package.json override configuration.
		 * @member {Object}
		 */
		this.overridePackageJson = override || {};
		/**
		 * Dependency root directories.
		 * @member {Object}
		 */
		this.packDir = {};
		/**
		 * Dependency main files.
		 * @member {Object}
		 */
		this.packMain = {};
		/**
		 * Dependency package.json.
		 * @member {Object}
		 */
		this.packJson = {};
		return this;
	}

	/**
	 * Convert module name to makefile variable.
	 * @param   {string} name  Module name.
	 * @returns {string}       Makefile variable name.
	 */
	toMakeVar(name) {
		return name.toUpperCase()
			.replace(/[^a-zA-Z_0-9]/g, '_');
	}

	/**
	 * Get make targets for npm scripts.
	 * @param   {Object}         packJson  package.json.
	 * @returns {Array.<string>}           Make targets.
	 */
	getNpmScripts(packJson) {
		let scripts = [];
		for(let script in packJson.scripts) {
			if(!/^(pre|post)/.test(script)) {
				scripts.push(script.replace(/:/g, '-'));
			}
		}
		return scripts;
	}

	/**
	 * Get module package.json.
	 * @param   {string} pack  Module name.
	 * @returns {Object}       Module package.json.
	 */
	getPackageJson(pack) {
		let json = this.packJson[pack];
		if(json) {
			return json;
		}
		let override = this.overridePackageJson[pack];
		pack = require(path.join(pack, 'package.json'));
		if(override === undefined) {
			return pack;
		}
		return this.packJson[pack] = Object.assign({}, pack, override);
	}

	/**
	 * Get module directory.
	 * @param   {string} pack  Module name.
	 * @returns {string}       Module directory relative to this.root.
	 */
	resolveDir(pack) {
		let dir = this.packDir[pack];
		if(dir) {
			return dir;
		}
		let main = require.resolve(pack);
		let packDirIndex = null;
		for(let dir of this.modulePaths) {
			if(main.startsWith(dir)) {
				packDirIndex = dir.length + 1;
				break;
			}
		}
		packDirIndex = packDirIndex || main.lastIndexOf(pack);
		let packRoot = main.substr(0, packDirIndex + pack.length);
		return this.packDir[pack] = path.relative(this.root, packRoot);
	}

	/**
	 * Get module main file.
	 * @param   {string} pack    Module name.
	 * @returns {Array<string>}  Module main file paths relative to this.root.
	 */
	resolve(pack) {
		let main = this.packMain[pack];
		if(main) {
			return main;
		}
		let packRoot = this.resolveDir(pack);
		let packJson = this.getPackageJson(pack);
		main = packJson.main;
		if(typeof main === 'string') {
			main = [main];
		}
		main = main.map((fname) => path.relative(
			this.root,
			path.join(packRoot, fname)
		));
		return this.packMain[pack] = main;
	}

	/**
	 * Get dependency main files.
	 * @private
	 * @param   {Object}         pack  package.json.
	 * @param   {Array.<string>} res   Array of main files.
	 * @param   {Object}         used  Used modules.
	 * @returns {Array.<string>}       Main file paths relative to this.root.
	 */
	_getDeps(pack, res, used) {
		for(let dep in pack.dependencies) {
			if(!used[dep]) {
				used[dep] = true;
				this._getDeps(this.getPackageJson(dep), res, used);
				res.push.apply(res, this.resolve(dep));
			}
		}
		return res;
	}

	/**
	 * Get dependency main files.
	 * @param   {...(string|Object)} packs  Module names or package.json.
	 * @returns {Array.<string>}            Main file paths relative to this.root.
	 */
	getDeps(...packs) {
		let files = [];
		let used = {};
		let packMain = null;
		for(let pack of packs) {
			if(typeof pack === 'string') {
				packMain = this.resolve(pack);
				pack = this.getPackageJson(pack);
			}
			this._getDeps(pack, files, used);
			if(packMain) {
				files.push.apply(files, packMain);
				packMain = null;
			}
		}
		return files;
	}

	/**
	 * Get .js dependency main files.
	 * @param   {...(string|Object)} packs  Module names or package.json.
	 * @returns {Array.<string>}            Main .js file paths relative to this.root.
	 */
	getJsDeps(...packs) {
		return this.getDeps(...packs)
			.filter((dep) => dep.endsWith('.js'));
	}

	/**
	 * Get makefile variables for dependency root paths relative to this.root.
	 * @returns {string}  Makefile variables.
	 */
	resolveVars() {
		let vars = '';
		for(let pack in this.packDir) {
			vars += 'RESOLVE_'.concat(
				this.toMakeVar(pack),
				' := ',
				this.packDir[pack],
				'\n'
			);
		}
		return vars;
	}
};
