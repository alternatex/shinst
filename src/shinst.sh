#!/bin/bash

# home
export SHINST=~/.shinst 

# version
export SHINST_VERSION="1.4.0"

# automatically check for updates
auto_update="true"

# configuration/initialization
rcfile=.shinstrc

# installation
installer="install.sh"

# localization
locale="en_US"

# directories » TODO: contextualize *
dir_modules="${HOME}/.shinst-modules"
dir_messages="${HOME}/.shinst/src/messages"

# scope 
scope="global" # global | local

# scripts
initialization="${SHINST}/src/defaults/${rc}"
localization="${SHINST}/src/messages/${locale}.sh"

# helpers
opts="hvn:p:r:s:b:"
action_install="install"
action_update="update"
action_remove="remove"

# internals » TODO: contextualize *
name=
branch=
prefix=
repo=
verbose=
script=

# pre-fetch / sanitize » TODO: contextualize *
action="$1" 
ghrepo="$2" 

# repository references
repo_github="https://github.com"
repo_branch="master" # yes, not 'stable'. maybe checking avail branches and then choosing stable or master would be nice ;-)

# sanitization / validation
check=${check:-"false"}

# formatting helpers 
color_off='\e[0m'; black='\e[0;30m'; red='\e[0;31m'; green='\e[0;32m'; yellow='\e[0;33m'; blue='\e[0;34m'; purple='\e[0;35m'; cyan='\e[0;36m'; white='\e[0;37m'; bblack='\e[1;30m'; bred='\e[1;31m'; bgreen='\e[1;32m'; byellow='\e[1;33m'; bblue='\e[1;34m'; bpurple='\e[1;35m'; bcyan='\e[1;36m'; bwhite='\e[1;37m';       

# arguments index
shiftby=1

# exit codes » TODO: implement * 
e_noargs=10
e_notfound=20

# run sanitization / validation checks?
if [[ "true" == "$check" ]]; then

  # (basic) environment variables check
  : ${HOSTNAME?} ${USER?} ${HOME?}
  printf "\n" 
  printf "\e[32mPOST successful..\e[0m\n\n"
  printf "\e[33mName of the machine is\e[0m $HOSTNAME\n"
  printf "\e[33mYou are\e[0m $USER\n"
  printf "\e[33mYour home directory is\e[0m $HOME\n\n"
fi

# describe usage
usage(){
cat << EOF
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
  -b <branch>   branch to checkout (defaults to master)
  -s <script>   run this script after clone (defaults to install.sh | use "-" to skip)
  -v            verbose

example: shinst install alternatex/shinst -b develop -s -
         shinst install alternatex/shinst -n shinst-custom -s -
         shinst install -r https://github.com/alternatex/shinst.git -n shinst-custom -s -

EOF
echo "version: $SHINST_VERSION"
exit -1
}

# helper - setup installation 
init(){

  # go home
  cd ~

  # info
  info "initializing"

  # helper - install directory
  local installdir=`echo "$prefix/.$name"`

  # handle action - install
  if [ "$action" = "$action_install" ]; then      
  
    # check if exists / remove?
    if [ -d "$installdir" ]; then

      # info
      info "directory exists: $installdir"

      # gather user input
      printf "remove? («Y» to edit or any key to skip) " && read -e -t 5 REPLY
      
      # automatically set
      if [[ -z $REPLY ]];   then REPLY='n'; fi
      
      # remove and continue
      if ([ "$REPLY" == "y" ] || [ "$REPLY" == "Y" ]); then

        # remove directory
        rm -rf "$installdir"

      # abort
      else

        # say bye
        echo "" && error "${message_dir_exists}: $installdir"
        exit -1
      fi
    fi

    # clone repo
    git clone "$repo" "$installdir" && cd "$installdir" && git checkout "$branch" && cd -
    
    # shell configuration file
    local shellcfg="$HOME/.bashrc"

    # zsh
    if [[ ! -a "~/.zshrc" ]]; then # if [[ "$SHELL" == "/bin/zsh" ]]; then     
      shellcfg="$HOME/.zshrc"
    fi

    # update shell configuration
    echo "# module ${name}" >> "$HOME/$rcfile"         
    echo "export PATH=\$HOME/.$name/bin:\$PATH; # module ${name}" >> "$HOME/$rcfile"
  
    # inject growl group identifier
    echo "# module ${name} growl messaging" >> "$HOME/$rcfile"         
    echo "export GROWL_ID_$(echo $name | tr '[a-z]' '[A-Z]')=$name; # module ${name}" >> "$HOME/$rcfile"

    # store cwd
    local current_path=`pwd` 

    # ...
    cd "$installdir" 

    # skip installer?
    if [[ "$script" == "-" ]]; then

      # talk
      verbose "skipping installer"

    # script exists?
    elif [[ -a "$script" ]]; then

      # run installer
      chmod a+x $script && ./$script
    fi

    # restore cwd
    cd "$current_path"
    
    # apply - TODO: handle appropriately
    #$SHELL && . $shellcfg 

    # ...
    cd "$installdir" 

    # npm
    if [[ -a "$(which npm)" ]] && [[ -a "package.json" ]]
      then 
      printf "\e[32mrunning NPM install\e[0m\n"
      npm install
    fi
    
    # bower
    if [[ -a "$(which bower)" ]] && [[ -a "component.json" ]]
      then 
      printf "\e[32mrunning bower install\e[0m\n"
      bower install
    fi

    # composer
    if [[ -a "$(which composer)" ]] && [[ -a "composer.json" ]]
      then 
      printf "\e[32mrunning composer install\e[0m\n"
      composer install
    fi

    # volo
    if [[ -a "$(which volo)" ]] # package.json vs. inline vs. xxx. think.
      then 
      printf "\e[32mrunning volo install\e[0m\n"
      volo install      
    fi

    # restore cwd
    cd "$current_path"

  # handle action - update
  elif [ "$action" = "$action_update" ]; then

    # update by remote origin
    cd "$installdir" && git pull && cd -

  # handle action - remove
  elif [ "$action" = "$action_remove" ]; then      

    # check if exists first
    if [ -d "$installdir" ]; then

      # request user input
      printf "remove $name? («Y» to edit or any key to cancel) " && read -e REPLY  
      
      # cleanup / remove entries from configuration file    
      cat "$HOME/$rcfile" | grep -Ev "# module ${name}|$(echo "# module ${name}" | tr '[a-z]' '[A-Z]')" | tee "$HOME/$rcfile" > /dev/null

      # process deletion or abort
      ([ "$REPLY" == "y" ] || [ "$REPLY" == "Y" ]) && rm -rf "$installdir" && echo "removed $installdir"
    else 
      error "$name not found"
    fi

  # unknown action
  else
    error "unknown action '$action'"
  fi
}

# default settings 
defaults(){

  # debug
  verbose "applying defaults"

  # apply defaults
  branch=${branch:-$repo_branch}
  prefix=${prefix:-$HOME}
  script=${script:-$installer}
  
  # no args
  if [[ -z "$action" ]]
    then
    usage
  fi

  # detect option only
  local tmp_option=`echo $action | sed -n "s/[-].*//p" | wc -c`

  # switch mode
  if [[ "$tmp_option" -gt "0" ]]; then
    usage
  fi

  # validate action (install|update|remove)
  if [[ "$action" != "$action_install" ]] && [[ "$action" != "$action_update" ]] && [[ "$action" != "$action_remove" ]]; 
    then

      # ...
      error "unknown action: ${action}"
      usage      
  fi

  # switch mode
  if [[ "$separator" -gt "0" ]] 
    then

    # build github url
    repo="${repo_github}/${ghrepo}.git"; 

    # check name
    if [[ -z "$name" ]] 
      then 
  
      # name » determine string length 
      local tmp_len=`echo ${#ghrepo}`
      tmp_len=$((tmp_len-separator))
      
      # name » extract to global from ghrepo 
      name=${ghrepo:($separator):($tmp_len)}
      
      # verbose
      verbose "extract name from repository: ${ghrepo} » ${name}"      
    fi
  else 

    # unset global
    ghrepo="-"

    # require name    
    if [[ -z "$name" ]] 
      then

      # request user input      
      printf "\e[33mname: \e[0m" && read -p "" && name="$REPLY"
      
      # check user input
      if [[ -z "$name" ]]; then 

        # ...
        error "required option 'name' not set"
        usage
      fi        
    fi    

    # require repo
    if [[ -z "$repo" ]] 
      then

      # request user input
      printf "\e[33mrepository: \e[0m" && read -p "" && repo="$REPLY"

      # check user input
      if [[ -z "$repo" ]]; then 

        # ...
        error "required option 'repo' not set"
        usage
      fi      
    fi        
  fi

  # info
  info "action:      ${action}"
  info "ghrepo:      ${ghrepo}"
  info "name:        ${name}"
  info "repo:        ${repo}"
  info "prefix:      ${prefix}"
  info "directory:   ${prefix}/.${name}"  
  info "script:      ${script}"
}

# validation helpers
sanitize_input(){
 
  # ...
  local string=string_value

  # ...
  string="${string//[^a-zA-Z0-9 ]/}"
}

# ... params: exit (defaults to false)
validate_action(){

  # ...
  if [[ "$action" != "$action_install" ]] && [[ "$action" != "$action_update" ]] && [[ "$action" != "$action_remove" ]]; 
    then

    # exit if requested
    if [[ "$1" = "true" ]]; then

      # ...
      error "unknown action: ${action}"
      usage
    fi
  else 

    # ...
    return true
  fi  
}

# debug utility
verbose(){ if [[ $verbose ]]; then printf "\e[1;34mdebug\e[0m $1\n"; fi }

# info utility
info(){ printf "\e[1;34minfo\e[0m  $1\n"; }

# error utility
error(){ printf "\e[1;31merror\e[0m $1\n\n"; }

# check for updates
if [ "$auto_update" = "true" ]
then
  
  if [[ -a "$SHINST/src/tools/upgrade-check.sh"   ]]; then

    # run upgrade check
    /usr/bin/env SHINST=$SHINST /bin/sh $SHINST/src/tools/upgrade-check.sh
  fi
fi

# determine separator
separator=`echo $ghrepo | sed -n "s/[/].*//p" | wc -c`

# switch mode
if [[ "$separator" -gt "0" ]]; then

  # shift arguments
  let shiftby++
fi

# shift prepended positional arguments
shift $shiftby

# process commandline options
while getopts "$opts" OPTION 
do  
  # handle option     
  case $OPTION in

    # show help
    h) 
      usage
      ;; 

    # package name
    n) 
      name=$OPTARG
      ;;     

    # prefix
    p) 
      prefix=$OPTARG
      ;;     

    # repository
    r) 
      repo=$OPTARG
      ;; 

    # branch
    b) 
      branch=$OPTARG
      ;;       
    
    # script
    s) 
      script=$OPTARG
      ;; 
    
    # show infos       
    v)
      verbose=1
      ;;

    # unknown option
    ?)
      usage
      ;;
  esac
done

# say hi
if [[ $verbose ]]; then
  printf "\e[1;31m"
  echo "----------------------------------------------------"
  echo "- Shinst // Superficial Package Management Utility -"
  echo "----------------------------------------------------"
  printf "\e[0m"
fi

# set defaults
defaults

# run shinst
init

# ...
#exit