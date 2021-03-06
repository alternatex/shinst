Shinst
=============

Superficial management utility

Installation
------------

### Prerequisites

Unix OS

### Setup

You can install this via the command line with either `curl` or `wget`.

via `curl`

`curl https://raw.github.com/alternatex/shinst/develop/src/tools/install.sh -o install.sh && bash install.sh stable alternatex/shinst`

via `wget`

`wget https://raw.github.com/alternatex/shinst/develop/src/tools/install.sh -O install.sh && bash install.sh stable alternatex/shinst`

Usage
-------------

```shell
$ shinst -h

usage:  shinst <action> <ghrepo> [options]
        shinst <action> <ghrepo>  -n <name> [options]
        shinst <action> -r <repo> -n <name> [options]

action: install, update, remove, list

ghrepo: github repository <user>/<repo> e.g. alternatex/bazinga

options:
  -h            show this message        
  -n <name>     local package name
  -p <prefix>   installation path prefix (defaults to ~/)
  -r <url>      GIT repository (e.g. https://github.com/alternatex/bazinga.git)
  -b <branch>   branch to checkout (defaults to master)
  -s <script>   run this script after clone (defaults to install.sh | use "-" to skip)
  -v            verbose

example: shinst install alternatex/bazinga -b develop -s -
         shinst install alternatex/bazinga -n shinst-custom -s -
         shinst install -r https://github.com/alternatex/bazinga.git -n bazinga-custom -s -
         shinst list

version: 1.5.1
```

Specification
-------------

**.shinstrc**

```shell
# ...
```

**web installer**

`wget https://raw.github.com/alternatex/shinst/develop/src/tools/install.sh -O install.sh && bash install.sh $branch $ghrepo`

eg.

`wget https://raw.github.com/alternatex/shinst/develop/src/tools/install.sh -O install.sh && bash install.sh stable alternatex/bazinga`

Integration
-----------
...

Changelog
-------------
**1.1.0:**
- added -

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
- added web installation helper

**1.4.1:**
- fixed self-updater

**1.5.0:**
- added list command
- added basic environment detection/switches
- added terminal notifier

**1.5.1:**
- improved volo invocation (substring check)
- fixed package list initialization
- fixed skipped input when executing installer via stdin
- fixed .shinstrc corruption upon package removal

Agile Roadmap
-------------
**1.6.0:**
- basic package self-updater (implies wrap?!)
- clear ambiguous declarations when tracking packages » install user/repo > .repo
- add configure command  
- local repository development helper (fs watch/sync)
- rescan system / update configuration 
- basic dependency management (getting rid of «some» install scripts for dependencies installable via shinst)
- modules support
- modules
  - bash.json
  - shinst.json (copy/path/xxx)
  - externalize commands 
  - configuration 

**1.7.0:**
- distinct notification queues/groups » log (informal/no-action) && interaction request 
- system language detection / l18N / externalize messages / .po \*
- contextualize notification w/shinst-notifier » TODO: get cert to sign code ... * 
- modules
  - basic logger
  - grunt 
  - extend specs for w/ post-installation dependencies:
      - configuration mappings
      - language (integrate existing l18n stuff)
  - module spec extension/rework » zsh/oh-my-zsh  
  - vramsteg  

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

**1.9.0:**
- local repository (artifactory \*)
- batch processing / new commands (update packages)
- track "projects" (relates to update packages)
- custom directory support (.shinstrc) for pkg installation w/ NPM approach (w/add. defaults: global/local)
- repository manager / custom web+shinst protocol / content type handlers
- move test repository into core
- ... *

License
-------------
Released under two licenses: new BSD, and MIT. You may pick the
license that best suits your development needs.

https://raw.github.com/alternatex/shinst/master/LICENSE
