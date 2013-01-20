#!/bin/bash

# general
SHINST=~/.shinst 

# version
shinst_version="1.3.0"

# auto-update
shinst_auto_update="true"

# defaults
shinst_defaults_conf=~/.shinst/.shinstrc
shinst_defaults_global="true"
shinst_defaults_home="$HOME"
shinst_defaults_script="install.sh"
shinst_defaults_modules="${shinst_defaults_home}/.shinst_modules"

# helpers
shinst_opts="hvn:p:r:s:"
shinst_action_install="install"
shinst_action_update="update"
shinst_action_remove="remove"

# internals
shinst_name=
shinst_repo=
shinst_rcfile=
shinst_prefix=
shinst_verbose=
shinst_script=

# arguments index
shinst_shift=1

# pre-fetch params (processing to come)
shinst_action="$1"
shinst_ghrepo="$2"

# formatting helpers 
color_off='\e[0m'; black='\e[0;30m'; red='\e[0;31m'; green='\e[0;32m'; yellow='\e[0;33m'; blue='\e[0;34m'; purple='\e[0;35m'; cyan='\e[0;36m'; white='\e[0;37m'; bblack='\e[1;30m'; bred='\e[1;31m'; bgreen='\e[1;32m'; byellow='\e[1;33m'; bblue='\e[1;34m'; bpurple='\e[1;35m'; bcyan='\e[1;36m'; bwhite='\e[1;37m';       

# exit codes
E_NOARGS=10
E_NOTFOUND=20

# describe usage
shinst_usage(){
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
  -s <script>   run this script after clone (defaults to install.sh | use "-" to skip)
  -v            verbose

example: shinst install alternatex/shinst -s -
         shinst install alternatex/shinst -n shinst-custom -s -
         shinst install -r https://github.com/alternatex/shinst.git -n shinst-custom -s -

EOF
echo "version: $shinst_version"
exit -1
}

# helper - setup installation 
shinst_init(){

  # go home
  cd ~

  # info
  shinst_info "initializing"

  # helper - install directory
  installdir=`echo "$shinst_prefix/.$shinst_name"`

  # handle action - install
  if [ "$shinst_action" = "$shinst_action_install" ]; then      
  
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
    git clone "$shinst_repo" "$installdir"
    
    # shell configuration file
    local shellcfg="$HOME/$shinst_rcfile"

    # bash
    if [[ "$SHELL" == "/bin/bash" ]]; then 
      shellcfg="$HOME/.bashrc"
    fi

    # zsh
    if [[ "$SHELL" == "/bin/zsh" ]]; then 
      shellcfg="$HOME/.zshrc"
    fi

    # update shell configuration
    echo "# $shinst_name" >> "$HOME/.shinstrc" 
    echo "export PATH=$shinst_prefix/.$shinst_name/bin:\$PATH" >> "$HOME/.shinstrc"

    # store cwd
    current_path=`pwd` 

    # ...
    cd "$installdir" 

    # skip installer?
    if [[ "$shinst_script" == "-" ]]; then

      # talk
      shinst_verbose "skipping installer"

    # script exists?
    elif [[ -a "$shinst_script" ]]; then

      # run installer
      chmod a+x $shinst_script && ./$shinst_script
    fi

    # restore cwd
    cd "$current_path"
    

    # apply
    $SHELL && . $shellcfg 

  # handle action - update
  elif [ "$shinst_action" = "$shinst_action_update" ]; then

    # update by remote origin
    cd "$installdir" && git pull && cd -

  # handle action - remove
  elif [ "$shinst_action" = "$shinst_action_remove" ]; then      

    # check if exists first
    if [ -d "$installdir" ]; then

      # request user input
      printf "remove $shinst_name? («Y» to edit or any key to cancel) " && read -e REPLY  

      # process deletion or abort
      ([ "$REPLY" == "y" ] || [ "$REPLY" == "Y" ]) && rm -rf "$installdir" && echo "removed $installdir"
    else 
      shinst_error "$shinst_name not found"
    fi

  # unknown action
  else
    shinst_error "unknown action '$shinst_action'"
  fi
}

# default settings 
shinst_defaults(){

  # debug
  shinst_verbose "applying defaults"

  # apply defaults
  if [[ -z $shinst_name ]];   then shinst_name=; fi
  if [[ -z $shinst_repo ]];   then shinst_repo=; fi
  if [[ -z $shinst_prefix ]]; then shinst_prefix="$shinst_defaults_home"; fi
  if [[ -z $shinst_script ]]; then shinst_script="$shinst_defaults_script"; fi
  
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

  # validate action (install|update|remove)
  if [[ "$shinst_action" != "$shinst_action_install" ]] && [[ "$shinst_action" != "$shinst_action_update" ]] && [[ "$shinst_action" != "$shinst_action_remove" ]]; 
    then

      # ...
      shinst_error "unknown action: ${shinst_action}"
      shinst_usage      
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
  shinst_info "script:      ${shinst_script}"
}

# validation helpers
shinst_sanitize_input(){
 
  # ...
  string=string_value

  # ...
  string="${string//[^a-zA-Z0-9 ]/}"
}

# ... params: exit (defaults to false)
shinst_validate_action(){

  # ...
  if [[ "$shinst_action" != "$shinst_action_install" ]] && [[ "$shinst_action" != "$shinst_action_update" ]] && [[ "$shinst_action" != "$shinst_action_remove" ]]; 
    then

    # exit if requested
    if [[ "$1" = "true" ]]; then

      # ...
      shinst_error "unknown action: ${shinst_action}"
      shinst_usage
    fi
  else 

    # ...
    return true
  fi  
}

# debug utility
shinst_verbose(){ if [[ $shinst_verbose ]]; then printf "\e[1;34mdebug\e[0m $1\n"; fi }

# info utility
shinst_info(){ printf "\e[1;34minfo\e[0m  $1\n"; }

# error utility
shinst_error(){ printf "\e[1;31merror\e[0m $1\n\n"; }

# check for updates
if [ "$shinst_auto_update" = "true" ]
then
  
  if [[ -a "$SHINST/src/tools/check_for_upgrade.sh"   ]]; then

    # run upgrade check
    /usr/bin/env SHINST=$SHINST /bin/sh $SHINST/src/tools/check_for_upgrade.sh
  fi
fi

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
    
    # script
    s) 
      shinst_script=$OPTARG
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