#!/bin/bash

# go home
cd ~

# fresh install?
if command -v "shinst" &>/dev/null
then
  
  # do nothing *
  printf "\e[32mshinst is installed.\e[0m   $1\n"
    exit 1
else

  # fetch *
  wget "https://raw.github.com/alternatex/shinst/master/src/shinst.sh" -O shinst.sh && chmod a+x shinst.sh  

  # install self
  ./shinst.sh "install" "alternatex/shinst"

  # verbose
  ./shinst.sh

  # cleanup
  rm -rf shinst.sh
fi