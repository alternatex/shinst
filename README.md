Shinst
=============

Superficial - yet GIT-ortiented - package management utility

The real cuties npm, bower, volo, composer on the back, soon, maybe, not. 

Installation
------------

### Prerequisites

Unix OS

### Setup

You can install this via the command line with either `curl` or `wget`.

via `curl`

`bash -s stable < <(curl -s https://raw.github.com/alternatex/shinst/master/src/tools/install.sh)`

via `wget`

`bash -s stable < <(wget https://raw.github.com/alternatex/shinst/master/src/tools/install.sh -O -)`

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
  -h            shows this message        
  -n <name>     local package name
  -p <prefix>   installation path prefix (defaults to ~/)
  -r <url>      GIT repository (e.g. https://github.com/alternatex/shinst.git)
  -b <branch>   branch to checkout (defaults to master)
  -s <script>   script to run after clone (defaults to install.sh | use "-" to skip)
  -v            verbose

example: shinst install alternatex/shinst -b develop -s -
         shinst install alternatex/shinst -b develop -n shinst-custom -s -
         shinst install -r https://github.com/alternatex/shinst.git -b develop -n shinst-custom -s -

version: 1.4.0

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
    "<github:username/repository>": ">=$<version-tag>"
  }
} 
```

**grunt.js**

```javascript
grunt.initConfig({
  cp: {
    identifier: {
      src:  '/s/r/c',
      dest: '/d/e/s/t'
    }
  }
});
```

Integration
-----------
...

Changelog
-------------
**1.1.0:**<br/>
* added miscellaneous \*

**1.2.0:**<br/>
* added self-updater

**1.2.1:**<br/>
* improved feature detection
* improved installation routine

**1.3.0:**<br/>
* added custom configuration .shinstrc

**1.4.0:**<br/>
* added custom branch support
* added basic dependency management
* added localization 
* added web installer

Roadmap
-------------
- general web based installer (install.sh?user/repo » shinst.json)
- basic dependency management
- branch / .shinstrc integration
- system language detection / l18N / externalize messages / .po *
- modules support
  - externalize commands 
  - configuration 
  - basic logger
  - include major management systems 
      - npm
      - bower
      - volo
      - composer      
  - additional wrappers
      - protocol: http/s, ssh/scp, ..
      - vcs: hg, svn, ..
  - grunt 
  - extend specs for w/ post-installation dependencies:
      - configuration mappings
      - language (integrate existing l18n stuff)
  - module spec extension/rework » zsh/oh-my-zsh  
  - vramsteg  
  - growl messages 
- longopts     
- batch processing / new commands (update packages)
- improve installer/uninstaller
- track "projects" (relates to update packages)
- custom directory support (.shinstrc) for pkg installation w/ NPM approach (w/add. defaults: global/local)
- move test repository into core
- ... *

License
-------------
Released under two licenses: new BSD, and MIT. You may pick the
license that best suits your development needs.

https://raw.github.com/alternatex/shinst/master/LICENSE