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

**"bookmarklet installer"**
TODO: host..* send line » see below whole installer call in bash script w/appropriate headers?!

**"web installer"**

`bash -s $branch $ghrepo < <(wget https://raw.github.com/alternatex/shinst/master/src/tools/install.sh -O -)`

`bash -s $branch $ghrepo < <(wget https://raw.github.com/alternatex/shinst/develop/src/tools/install.sh -O -)`

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
- added basic support for common package management systems (NPM, Bower, Composer, Volo)
- added custom branch support
- added simplified installation routine "web-installer"

Agile Roadmap
-------------

**1.5.0:**
- system language detection / l18N / externalize messages / .po *
- add path support as repo reference

**1.6.0:**
- basic dependency management (getting rid of install scripts for dependencies installable via shinst)
- modules support

**1.7.0:**
- modules
  - shinst.json 
  - externalize commands 
  - configuration 
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
- local repository (artifactory *)

**1.9.0:**
- batch processing / new commands (update packages)
- track "projects" (relates to update packages)
- custom directory support (.shinstrc) for pkg installation w/ NPM approach (w/add. defaults: global/local)

**2.0.0:**
- move test repository into core
- ... *

License
-------------
Released under two licenses: new BSD, and MIT. You may pick the
license that best suits your development needs.

https://raw.github.com/alternatex/shinst/master/LICENSE