Shinst
=============

Superficial - yet GIT-ortiented - package management utility

Package management, really?

Installation
------------

### Prerequisites

Unix OS

### Setup

You can install this via the command line with either `curl` or `wget`.

via `curl`

`bash -s stable < <(curl -s https://raw.github.com/alternatex/shinst/master/src/tools/install.sh)`
`bash -s stable < <(curl -s https://raw.github.com/alternatex/shinst/develop/src/tools/install.sh)`

via `wget`

`bash -s stable < <(wget https://raw.github.com/alternatex/shinst/master/src/tools/install.sh -O -)`
`bash -s stable < <(wget https://raw.github.com/alternatex/shinst/develop/src/tools/install.sh -O -)`

Usage
-------------

```shell
$ shinst -h

usage:  shinst <action> <ghrepo> [options]
        shinst <action> <ghrepo>  -n <name> [options]
        shinst <action> -r <repo> -n <name> [options]

action: install, update, remove

ghrepo: github repository <user>/<repo> e.g. alternatex/bazinga

options:
  -h            shows this message        
  -n <name>     local package name
  -p <prefix>   installation path prefix (defaults to ~/)
  -r <url>      GIT repository (e.g. https://github.com/alternatex/bazinga.git)
  -b <branch>   branch to checkout (defaults to master)
  -s <script>   script to run after clone (defaults to install.sh | use "-" to skip)
  -v            verbose

example: shinst install alternatex/bazinga
         shinst install alternatex/bazinga -b develop -s -
         shinst install alternatex/bazinga -b develop -n bazinga-custom -s -
         shinst install -r https://github.com/alternatex/bazinga.git -b develop -n bazinga-custom -s -

<<<<<<< HEAD
version: 1.5.0
=======
version: 1.4.1
>>>>>>> feature/1.4.1

```

Specification
-------------

**webinst**

`bash -s $branch $ghrepo < <(wget https://raw.github.com/alternatex/shinst/master/src/tools/install.sh -O -)`

`bash -s $branch $ghrepo < <(wget https://raw.github.com/alternatex/shinst/develop/src/tools/install.sh -O -)`

**.shinstrc**

```shell
# ...
```

Integration
-----------
...

Changelog
-------------
**1.1.0:**
- added \*\*\*

**1.2.0:**
- added self-updater

**1.2.1:**
- improved feature detection
- improved installation routine

**1.3.0:**
- added custom configuration (.shinstrc)

**1.4.0:**
- added basic support for common package management systems (npm, bower, composer, volo)
- added custom branch switch
- added `webinst` routine 

**1.4.1:**
- fixed self-updater

**1.4.1:**
- fixed self-updater

**1.5.0:**
- added list command
- added basic environment detection/switches
- added terminal notifier

TODO:
- added terminal-notifier (MacOSX only)

include messages!!!!
include messages!!!!

add switch global variable in shinst.sh when SHINST_NOTIFY="true" !!!!!!!

Agile Roadmap
-------------
**1.6.0:**
- local repository development helper (fs watch/sync)
- system language detection / l18N / externalize messages / .po \*
- basic dependency management (getting rid of «some» install scripts for dependencies installable via shinst)
- modules support
- modules
  - bash.json
  - shinst.json (copy/path/xxx)
  - externalize commands 
  - configuration 

**1.7.0:**
- contextualize notification w/shinst-notifier » TODO: get cert to sign code ... * 
- modules
  - basic logger
  - grunt 
  - extend specs for w/ post-installation dependencies:
      - configuration mappings
      - language (integrate existing l18n stuff)
  - module spec extension/rework » zsh/oh-my-zsh  
  - vramsteg  
  - growl messages 

**1.8.0:**
- modules
  - include major management systems 
      - npm
      - bower
      - volo
      - composer
  - additional wrappers
      - protocol: http/s, ssh/scp, ..
      - vcs: hg, svn, ..      
- add longtops support
- improve installer/uninstaller
- local repository (artifactory \*)

**1.9.0:**
- batch processing / new commands (update packages)
- track "projects" (relates to update packages)
- custom directory support (.shinstrc) for pkg installation w/ NPM approach (w/add. defaults: global/local)

**2.0.0:**
- repository manager / custom web+shinst protocol / content type handlers
- move test repository into core
- ... *

License
-------------
Released under two licenses: new BSD, and MIT. You may pick the
license that best suits your development needs.

https://raw.github.com/alternatex/shinst/master/LICENSE