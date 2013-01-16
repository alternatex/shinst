#!/bin/bash

# version
shinst_version="1.1.0"

# defaults
shinst_defaults_prefix="$HOME"

# helpers
shinst_opts="hvn:p:r:"
shinst_action_install="install"
shinst_action_update="update"
shinst_action_remove="remove"

# internals
shinst_name=
shinst_repo=
shinst_rcfile=
shinst_prefix=
shinst_verbose=

# arguments index
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
  -n <name>     local package name
  -p <prefix>   installation path prefix (defaults to ~/)
  -r <url>      GIT repository (eg. https://github.com/alternatex/shinst.git)
  -v            verbose

example: shinst install alternatex/shinst

EOF
echo "version: $shinst_version"
exit -1
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
  local repo="$shinst_repo"

  # local custom rc
  local rcfile="$shinst_rcfile"

  # local prefix
  local prefix="$shinst_prefix"

  # flag installed
  local installed=false

  # helper - install directory
  installdir=`echo "$prefix/.$name"`

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
    
    # shell configuration file
    local shellcfg="$HOME/$rcfile"
    local shellbin="/bin/bash"

    # bash
    if [ -f ~/.bashrc ]; then 
            shellcfg="$HOME/.bashrc"
            shellbin="/bin/bash"
    fi

    # zsh
    if [ -f ~/.zshrc ]; then 
            shellcfg="$HOME/.zshrc"
            shellbin="/bin/zsh"
    fi

    # ?
    if [ -f ~/.profile ]; then 
            shellcfg="$HOME/.profile"
            shellbin="/bin/bash"
    fi

    # update shell configuration
    echo "# $name" >> $shellcfg
    echo "export PATH=$prefix/.$name/bin:\$PATH" >> $shellcfg       

    # run install script
    cd "$installdir" && chmod a+x install.sh && ./install.sh && cd -

    # apply
    $shellbin && . $shellcfg 

  # handle action - update
  elif [ "$action" = "$shinst_action_update" ]; then

    # update by remote origin
    cd "$installdir" && git pull && cd -

  # handle action - remove
  elif [ "$action" = "$shinst_action_remove" ]; then      

    # check if exists first
    if [ -d "$installdir" ]; then

      # request user input
      printf "remove $shinst_name? («Y» to edit or any key to cancel) " && read -e REPLY  

      # process deletion or abort
      ([ "$REPLY" == "y" ] || [ "$REPLY" == "Y" ]) && rm -rf "$installdir" && echo "removed $installdir"
    else 
      shinst_error "$shinst_name not found"
    fi
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
  
  # no args
  if [[ -z "$shinst_action" ]]
    then
    shinst_usage
  fi

  # detect option only
  tmp_option=`echo $shinst_action | sed -n "s/[-].*//p" | wc -c`

  # switch mode
  if [[ "$tmp_option" -gt "0" ]]; then
    shinst_usage
  fi

  action=`echo $shinst_action | sed -n "s/[-].*//p" | wc -c`  

  # validate action [insert, update, remove]
  if [[ -z "$shinst_action" ]] && [[ "$shinst_action" != "$shinst_action_install" ]] && [[ "$shinst_action" != "$shinst_action_update" ]] && [[ "$shinst_action" != "$shinst_action_remove" ]]; 
    then
    
    # request user input
    printf "\e[33maction (install|update|remove): \e[0m" && read -p "" && shinst_action="$REPLY"

    # validate action again
    if [[ "$action" -lt "1" ]] && [[ "$shinst_action" != "$shinst_action_install" ]] && [[ "$shinst_action" != "$shinst_action_update" ]] && [[ "$shinst_action" != "$shinst_action_remove" ]]; then
      
      # ...
      shinst_error "unknown action '$shinst_action'"
      shinst_usage
    fi     
  fi

  # switch mode
  if [[ "$separator" -gt "0" ]] 
    then

    # build github url
    shinst_repo="https://github.com/${shinst_ghrepo}.git"; 

    # check name
    if [[ -z "$shinst_name" ]] 
      then 
  
      # extract name from ghrepo 
      tmp_len=`echo ${#shinst_ghrepo}`
      tmp_len=$((tmp_len-separator))

      # if name not set only » verbose *
      shinst_name=${shinst_ghrepo:($separator):($tmp_len)}
      
      # verbose
      shinst_verbose "extract name from repository: ${shinst_ghrepo} » ${shinst_name}"      
    fi
  else 

    # unset 
    shinst_ghrepo="-"

    # require name    
    if [[ -z "$shinst_name" ]] 
      then

      # request user input      
      printf "\e[33mname: \e[0m" && read -p "" && shinst_name="$REPLY"
      
      # check user input
      if [[ -z "$shinst_name" ]]; then 

        # ...
        shinst_error "required option 'name' not set"
        shinst_usage
      fi        
    fi    

    # require repo
    if [[ -z "$shinst_repo" ]] 
      then

      # request user input
      printf "\e[33mrepository: \e[0m" && read -p "" && shinst_repo="$REPLY"

      # check user input
      if [[ -z "$shinst_repo" ]]; then 

        # ...
        shinst_error "required option 'repo' not set"
        shinst_usage
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

# debug utility
shinst_verbose(){ if [[ $shinst_verbose ]]; then printf "\e[1;34mdebug\e[0m $1\n"; fi }

# info utility
shinst_info(){ printf "\e[1;34minfo\e[0m  $1\n"; }

# error utility
shinst_error(){ printf "\e[1;31merror\e[0m $1\n\n"; }

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

    # unknown option
    ?)
      shinst_usage
      ;;
  esac
done

# say hi
if [[ $shinst_verbose ]]; then
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