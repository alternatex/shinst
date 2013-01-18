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
        shinst <action> -r <repo> -n <name> [options]

action: install, update, remove

ghrepo: github repository <user>/<repo> e.g. alternatex/shinst

options:
  -h            show this message        
  -n <name>     local package name
  -p <prefix>   installation path prefix (defaults to ~/)
  -r <url>      GIT repository (e.g. https://github.com/alternatex/shinst.git)
  -v            verbose

examples: shinst install alternatex/shinst
          shinst install alternatex/shinst -n shinst-custom
          shinst install -r https://github.com/alternatex/shinst.git -n shinst-custom

version: 1.2.1

```

Specification
-------------
...

Changelog
-------------
**1.1.0:**<br/>
* determine package name by ghrepo

**1.2.0:**<br/>
* added self-updater

Roadmap
-------------
- externalize messages
- zsh/oh-my-zsh plugin
- /var/log/shinst/history.log
- custom *rc-file inject into bash configuration once (w/existance check & cleanup)
- manifest/custom directory prefix for packages installed w/shinst (collect binaries w/ln)
- dependency management
- modules support
- configuration (using bazinga module)
- batch processing (update packages)
- improve installer/uninstaller
- track "projects" (relates to update packages)
- ... *

License
-------------
Released under two licenses: new BSD, and MIT. You may pick the
license that best suits your development needs.

https://raw.github.com/alternatex/shinst/master/LICENSE