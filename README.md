Shinst
=============

Superficial package management utility

Installation
------------

### Prerequisites

Unix-OS

### Setup

You can install this via the command line with either `curl` or `wget`.

via `curl`

`curl -L https://github.com/alternatex/shinst/raw/master/install.sh | sh`

via `wget`

`wget --no-check-certificate https://github.com/alternatex/shinst/raw/master/install.sh -O - | sh`

Usage
-------------

```shell
$ shinst -h

usage:  shinst <action> <ghrepo> [options]
        shinst <action> <ghrepo>  -n <name> [options]
        shinst <action> -n <name> -r <repo> [options]

action: install, update, remove

ghrepo: github repository <user>/<repo> eg.: alternatex/shinst

options:
  -h            show this message        
  -n <name>     local package name
  -p <prefix>   installation path prefix (defaults to ~/)
  -r <url>      GIT repository (eg. https://github.com/alternatex/shinst.git)
  -v            verbose

example: shinst install alternatex/shinst

version: 1.2.0

```

Specification
-------------
...

Changelog
-------------
**1.1.0:**<br/>
* determine package name based on repository if not set

**1.2.0:**<br/>
* added self-updater

Roadmap
-------------
- externalize messages
- custom *rc-file inject into bash configuration once (w/existance check & cleanup)
- custom packages
- custom directory prefix for packages installed w/shinst (collect binaries w/ln)
- modules support
- configuration (using bazinga module)
- batch processing (update packages)
- ... *

License
-------------
Released under two licenses: new BSD, and MIT. You may pick the
license that best suits your development needs.

https://raw.github.com/alternatex/shinst/master/LICENSE