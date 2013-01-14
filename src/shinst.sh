#!/bin/bash

# defaults
shinst_defaults_prefix="~/.shinst"

# helpers
shinst_opts="hvyn:p:r:"
shinst_action_install="install"
shinst_action_update="update"
shinst_action_remove="remove"

# internals
shinst_name=
shinst_repo=
shinst_rcfile=
shinst_instdir=
shinst_prefix=
shinst_verbose=
shinst_confirmed=

# arguments index (as action is mandatory start at 1)
shinst_shift=1

# pre-fetch params (processing to come)
shinst_action="$1"
shinst_ghrepo="$2"

# formatting helpers 
color_off='\e[0m'; black='\e[0;30m'; red='\e[0;31m'; green='\e[0;32m'; yellow='\e[0;33m'; blue='\e[0;34m'; purple='\e[0;35m'; cyan='\e[0;36m'; white='\e[0;37m'; bblack='\e[1;30m'; bred='\e[1;31m'; bgreen='\e[1;32m'; byellow='\e[1;33m'; bblue='\e[1;34m'; bpurple='\e[1;35m'; bcyan='\e[1;36m'; bwhite='\e[1;37m';       

# describe usage
shinst_usage(){
cat << EOF
usage:  shinst <action> <ghrepo> [options]
        shinst <action> <ghrepo>  -n <name> [options]
        shinst <action> -n <name> -r <repo> [options]

action: install, update, remove

ghrepo: github repository <user>/<repo> eg.: alternatex/shinst

options:
  -h            show this message        
  -n <name>     package name
  -p <prefix>   installation path prefix (defaults to ~/)
  -r <url>      GIT repository (eg. https://github.com/alternatex/shinst.git)
  -v            verbose
  -y            skip confirmation

EOF
}

# helper - setup installation 
shinst_init(){

  # info
  shinst_info "initializing"
  
  # go home
  cd ~

  # local action 
  local action="$shinst_action"

  # local configuration 
  local name="$shinst_name"

  # local repository
  local repo="$shinst_repo" # based on name

  # local custom rc
  local rcfile="$shinst_rcfile" # based on name

  # local prefix
  local prefix="$shinst_prefix"

  # flag installed
  local installed=false

  # helper - install directory
  installdir=`echo "$prefix/.$name"`

  # check command
  #if command -v "$name" &>/dev/null
  #then
  #    shinst_verbose "$name found."
  #    installed=true
  #fi

  # handle action - install
  if [ "$action" = "$shinst_action_install" ]; then      
  
    # check if exists / remove?
    if [ -d "$installdir" ]; then

      # info
      shinst_info "directory exists: $installdir"

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
        echo "" && shinst_error "directory exists: $installdir"
        exit -1
      fi

    fi

    # clone repo
    git clone "$repo" "$installdir"
    
    # shell configuration file (TODO: combine with $SHELL environment variable?)
    local shellcfg="$HOME/$rcfile"

    # bash
    if [ -f ~/.bashrc ]; then 
            shellcfg="$HOME/.bashrc"
    fi

    # zsh
    if [ -f ~/.zshrc ]; then 
            shellcfg="$HOME/.zshrc"
    fi

    # ?
    if [ -f ~/.profile ]; then 
            shellcfg="$HOME/.profile"
    fi

    # update shell configuration
    echo "# $name" >> $shellcfg
    echo "export PATH=$prefix/.$name/bin:\$PATH" >> $shellcfg
    
    # apply - TODO: make this work for real within parent session!
    . $shellcfg        

    # run install script
    cd "$prefix/.$name" && chmod a+x install.sh && ./install.sh && cd -
  
  # handle action - update
  elif [ "$action" = "$shinst_action_update" ]; then
    cd "$installdir"
    git pull

  # handle action - remove
  elif [ "$action" = "$shinst_action_remove" ]; then      
    printf "remove $shinst_name? («Y» to edit or any key to cancel) " && read -e REPLY  
    ([ "$REPLY" == "y" ] || [ "$REPLY" == "Y" ]) && rm -rf "$installdir" && echo "removed $installdir"

  # handle action - unknown
  else
      echo "unknown command"
      exit -1
  fi
}

# default settings 
shinst_defaults(){

  # debug
  shinst_verbose "applying defaults"

  # apply defaults
  if [[ -z $shinst_name ]];   then shinst_name=; fi
  if [[ -z $shinst_repo ]];   then shinst_repo=; fi
  if [[ -z $shinst_prefix ]]; then shinst_prefix="$HOME"; fi
  
  # bogus
  action=`echo $shinst_action | sed -n "s/[\-].*//p" | wc -c`

  # validate action [insert, update, remove]
  if [[ -z "$shinst_action" ]] && [[ "$shinst_action" != "$shinst_action_install" ]] && [[ "$shinst_action" != "$shinst_action_update" ]] && [[ "$shinst_action" != "$shinst_action_remove" ]]; 
    then
    
    # request user input
    printf "\e[33maction (install|update|remove): \e[0m" && read -p "" && shinst_action="$REPLY"

    # validate action 
    if [[ "$action" -lt "1" ]] && [[ "$shinst_action" != "$shinst_action_install" ]] && [[ "$shinst_action" != "$shinst_action_update" ]] && [[ "$shinst_action" != "$shinst_action_remove" ]]; then
      
      # ...
      shinst_error "unknown action '$shinst_action'"
      shinst_usage
      exit -1
    fi     
  fi

  # switch mode
  if [[ "$separator" -gt "0" ]] 
    then

    # build github url
    shinst_ghrepo "$shinst_ghrepo"
   
    # check name
    if [[ -z "$shinst_name" ]] 
      then 

      # fetch name from shortcut
      
      # ...
      shinst_name="$(echo name)"
    fi
  else 

    # unset 
    shinst_ghrepo="-"

    # require name    
    if [[ -z "$shinst_name" ]] 
      then

      # request user input      
      printf "\e[33mname: \e[0m" && read -p "" && shinst_name="$REPLY"
      if [[ -z "$shinst_name" ]] 
        then 
        # ...
        shinst_error "required option 'name' not set"
        shinst_usage
        exit -1
      fi        
    fi    

    # require repo
    if [[ -z "$shinst_repo" ]] 
      then

      # request user input
      printf "\e[33mrepository: \e[0m" && read -p "" && shinst_repo="$REPLY"

      if [[ -z "$shinst_repo" ]] 
        then 
        # ...
        shinst_error "required option 'repo' not set"
        shinst_usage
        exit -1
      fi      
    fi        
  fi

  # default config
  shinst_rcfile=".${shinst_name}c"

  # info
  shinst_info "action:      ${shinst_action}"
  shinst_info "ghrepo:      ${shinst_ghrepo}"
  shinst_info "name:        ${shinst_name}"
  shinst_info "rcfile:      ${shinst_rcfile}"
  shinst_info "repo:        ${shinst_repo}"
  shinst_info "prefix:      ${shinst_prefix}"
  shinst_info "directory:   ${shinst_prefix}/.${shinst_name}"  
}

# installation mode opts
shinst_options(){

  # debug
  shinst_verbose "applying options"
}

# debug utility
shinst_verbose(){

  # ...
  if [[ $shinst_verbose ]]; then
    printf "\e[1;34mdebug\e[0m  $1\n"
  fi    
}

# info utility
shinst_info(){

  # ...
  printf "\e[1;34minfo\e[0m   $1\n"
}

# error utility
shinst_error(){

  # ...
  printf "\e[1;31merror\e[0m   $1\n\n"
}

# build github repo url
shinst_ghrepo(){

  # set global (TODO: fix)
  shinst_repo="https://github.com/${1}.git"
}

# check installation requirements
shinst_check(){

  # check required args - apply defaults
  return 1
}

# ...
shinst_list(){
  echo "shinst_list"
}

# ...
shinst_install(){
  echo "shinst_install"
}

# ...
shinst_remove(){
  echo "shinst_remove"
}

# ...
shinst_update(){
  echo "shinst_update"
}

# determine separator pos/existance
separator=`echo $shinst_ghrepo | sed -n "s/[/].*//p" | wc -c`

# switch mode
if [[ "$separator" -gt "0" ]]; then

  # shift arguments
  let shinst_shift++
fi

# shift prepended positional arguments
shift $shinst_shift

# process commandline options
while getopts "$shinst_opts" OPTION 
do  
  # handle option     
  case $OPTION in

    # show help
    h) 
      shinst_usage
      exit 1
      ;; 

    # package name
    n) 
      shinst_name=$OPTARG
      ;;     

    # prefix
    p) 
      shinst_prefix=$OPTARG
      ;;     

    # repository
    r) 
      shinst_repo=$OPTARG
      ;; 
    
    # show infos       
    v)
      shinst_verbose=1
      ;;

    # supress confirmation
    y)
      shinst_confirmed=1
      ;;

    # unknown option
    ?)
      shinst_usage
      exit
      ;;
  esac
done

# say hi
if [[ $shinst_verbose ]]
  then
  printf "\e[1;31m"
  echo "----------------------------------------------------"
  echo "- Shinst // Superficial Package Management Utility -"
  echo "----------------------------------------------------"
  printf "\e[0m"
fi

# set defaults
shinst_defaults

# run shinst
shinst_init

# bye
exit 1