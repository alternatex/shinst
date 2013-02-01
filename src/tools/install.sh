#!/bin/bash

# go home
cd ~

# check installation
if [[ -a "$(which shinst)" ]]
  then 
  
  # do nothing *
  printf "\e[32mshinst is installed.\e[0m\n"
else

  # fetch installer
  wget "https://raw.github.com/alternatex/shinst/develop/src/shinst.sh" -O shinst.sh && chmod a+x shinst.sh  

  # default configuration
  wget "https://raw.github.com/alternatex/shinst/develop/src/defaults/.shinstrc" -O ~/.shinstrc

  # shell configuration file
  local shellcfg="$HOME/.bashrc"

  # bash
  if [[ "$SHELL" == "/bin/bash" ]]; then 
    shellcfg="$HOME/.bashrc"
  fi

  # zsh
  if [[ "$SHELL" == "/bin/zsh" ]]; then 
    shellcfg="$HOME/.zshrc"
  fi

  # update shell configuration
  printf "\e[32mupdating shell configuration $shellcfg..\e[0m\n"

  # ...
  echo "# shinst" >> $shellcfg
  echo "export SHINST=~/.shinst" >> $shellcfg         
  
  # environment inspection
  source $SHINST/src/tools/environment.sh && inspect_env

  export SHINST_OS=$OS
  export SHINST_OS_VERSION=$VERSION
  
  echo "export SHINST_OS=$SHINST_OS" >> $shellcfg         
  echo "export SHINST_OS_VERSION=$SHINST_OS_VERSION" >> $shellcfg         
  echo "export PATH=~/.shinst/bin:$PATH" >> $shellcfg       
  echo "source $HOME/.shinstrc" >> $shellcfg       

  # install self
  ./shinst.sh "install" "alternatex/shinst" -b "stable" -s -

  # verbose
  ./shinst.sh

  # ...
  printf "\e[32mshinst successfully installed.\e[0m\n"

  # cleanup
  rm -rf shinst.sh
fi

# check for updates first whilst we're at it?
if [[ "$2" != "" ]]; then 
  shinst install ${2} -b ${1:-"master"}
fi

function terminal_notifier(){
  
  # check terminal notifier
  if [[ -a "$(which terminal-notifier)" ]]
    then 
    echo "export SHINST_NOTIFY=true" >> $shellcfg
    printf "\e[32mterminal-notifier found.\e[0m \n"
  else

    # install dependency
    printf "\e[32minstalling terminal-notifier through gem...\e[0m \n"
  
    # check if this is really needed - catch ex - request only if ???    
    sudo gem install terminal-notifier

    # check installation
    if [[ -a "$(which terminal-notifier)" ]]
      then 
        echo "export SHINST_NOTIFY=true" >> $shellcfg
        printf "\e[32malloy/terminal-notifier installed.\e[0m \n"
    else
      echo "export SHINST_NOTIFY=" >> $shellcfg
      printf "\e[1;31malloy/terminal-notifier installation failed.\e[0m \n"        
    fi  
    printf "\e[32mdone.\e[0m   $1\n"
  fi
}

# optional extension * (TODO: VERSION check!)
if [[ $SHINST_OS == "darwin" ]]; then
  if [[ ! -a "$(which terminal-notifier)" ]]
    then 

    # request user input
    printf "install terminal-notifier? («Y» to install or any key to skip) " && read -e REPLY  

    # process deletion or abort / cleanup / remove entries from configuration file    
    ([ "$REPLY" == "y" ] || [ "$REPLY" == "Y" ]) && terminal_notifier
  fi
fi

# really?
exit 1  