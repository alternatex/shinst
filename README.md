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

`bash -s stable < <(curl -s https://raw.github.com/alternatex/shinst/master/install.sh)`

via `wget`

`bash -s stable < <(wget https://raw.github.com/alternatex/shinst/master/install.sh -O -)`

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

version: 1.3.0

```

Specification
-------------

**.shinstrc**

```shell
export SHINST=~/.shinst
```

**package.json**

```javascript
  "shinst": {
    "dependencies": {
      "alias": "<github:username/repository>"
    }
  } 
```

Changelog
-------------
**1.1.0:**<br/>
* determine package name by ghrepo

**1.2.0:**<br/>
* added self-updater

**1.3.0:**<br/>
* added custom configuration .shinstrc
* modified feature detection
* improved installation routine

Roadmap
-------------
- custom *rc-file existance check and cleanup
- introduce package.json namespace
- dependency management
- externalize messages
- grunt support
- /var/log/shinst/history.log
- manifest/custom directory prefix for packages installed w/shinst (collect binaries w/ln)
- custom branch support
- modules support
- zsh/oh-my-zsh plugin
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