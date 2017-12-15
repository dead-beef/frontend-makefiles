# frontend-makefiles

[![license](https://img.shields.io/github/license/dead-beef/frontend-makefiles.svg)](
    https://github.com/dead-beef/frontend-makefiles/blob/master/LICENSE
)

## Overview



## Requirements

- [`Node.js`](https://nodejs.org/)
- [`NPM`](https://nodejs.org/)
- [`GNU Make`](https://www.gnu.org/software/make/)

## Installation



## Usage

### Building

```bash
# single run
make
# continuous
make watch
# single run, minify
make min
# continuous, minify
make min-watch
# rebuild
make rebuild
# rebuild, minify
make rebuild-min
```

### Code Linting

```
make lint
```

### Server

```bash
# start/restart
make start
# set ip and port
make SERVER_IP=127.0.0.1 SERVER_PORT=1080 start
# stop
make stop
```

## Licenses

* [`frontend-makefiles`](https://github.com/dead-beef/frontend-makefiles/blob/master/LICENSE)
