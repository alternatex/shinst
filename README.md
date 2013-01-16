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

version: 1.1.0

```

Specification
-------------
...

Roadmap
-------------
- self-update
- custom *rc-file inject into bash configuration once (w/existance check)
- custom *rc-file cleanup
- custom packages
- custom directory prefix for packages installed w/shinst (collect binaries w/ln)
- ... *

License
-------------
Released under two licenses: new BSD, and MIT. You may pick the
license that best suits your development needs.

https://raw.github.com/alternatex/shinst/master/LICENSE