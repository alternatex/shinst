#!/bin/bash

# go home
cd ~

# check installation
if command -v "shinst" &>/dev/null
then
  
  # do nothing *
  printf "\e[32mshinst is installed.\e[0m   $1\n"
  exit 1
else

  # fetch installer
  wget "https://raw.github.com/alternatex/shinst/master/src/shinst.sh" -O shinst.sh && chmod a+x shinst.sh  

  # default configuration
  wget "https://raw.github.com/alternatex/shinst/master/.shinstrc" -O ~/.shinstrc

  # install self
  ./shinst.sh "install" "alternatex/shinst"

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
  echo "# shinst" >> $shellcfg
  echo "source ~/.shinstrc" >> $shellcfg       

  # verbose
  ./shinst.sh

  # ...
  printf "\e[32mshinst successfully installed.\e[0m   $1\n"

  # cleanup
  rm -rf shinst.sh
fi