#!/bin/bash

# go home
cd ~

# check installation
if [[ -a "$(which shinst)" ]]
  then 
  
  # do nothing *
  printf "\e[32mshinst is installed.\e[0m   $1\n"
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
exit 1