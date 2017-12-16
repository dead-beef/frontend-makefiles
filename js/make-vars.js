const path = require('path');

const root = path.resolve('./');
const packageJson = require(path.join(root, 'package.json'));

let overridePackageJson = {};

if(process.argv.length > 2) {
	overridePackageJson = require(path.join(root, process.argv[2]));
}

let packDir = {};

const toMakeVar = (name) => name
	  .toUpperCase()
	  .replace(/[^a-zA-Z_0-9]/g, '_');

const getPackageJson = (pack) => {
	let override = overridePackageJson[pack];
	pack = require(path.join(pack, 'package.json'));
	if(override === undefined) {
		return pack;
	}
	return Object.assign({}, pack, override);
};

const resolveDir = (pack) => {
	if(packDir[pack]) {
		return packDir[pack];
	}
	let main = require.resolve(pack);
	let packDirIndex = main.lastIndexOf(pack);
	let packRoot = main.substr(0, packDirIndex + pack.length);
	return packDir[pack] = path.relative(root, packRoot);
};

const resolve = (pack) => {
	let main = require.resolve(pack);
	let packRoot = resolveDir(pack);
	let override = overridePackageJson[pack];
	override = override && override.main;

	if(override !== undefined) {
		main = path.join(packRoot, override);
	}

	return path.relative(root, main);
};

const _getDeps = (pack, res, used) => {
	for(let dep in pack.dependencies) {
		if(!used[dep]) {
			_getDeps(getPackageJson(dep), res, used);
			res.push(resolve(dep));
			used[dep] = true;
		}
	}
	return res;
};

const getDeps = (pack) => _getDeps(pack, [], {});

let scripts = [];

for(let script in packageJson.scripts) {
	if(!/^(pre|post)/.test(script)) {
		scripts.push(script.replace(/:/g, '-'));
	}
}

let jsDeps = getDeps(packageJson)
	.filter((dep) => dep.endsWith('.js'));

console.log('NPM_SCRIPTS :=', scripts.join(' '));
console.log('LIB_JS_FILES :=', jsDeps.join(' '));

for(let pack in packDir) {
	console.log('RESOLVE_' + toMakeVar(pack), ':=', packDir[pack]);
}
