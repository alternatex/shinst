#!/bin/bash

# ...
current_path=`pwd`

# ...
printf '\033[0;34m%s\033[0m\n' "Upgrading Shinst"

# ...
cd $SHINST

# ...
if git pull origin master
then
  printf '\033[0;34m%s\033[0m\n' 'Shinst has been updated and/or is at the current version.'
else
  printf '\033[0;31m%s\033[0m\n' 'There was an error updating. Try again later?'
fi

# ...
cd "$current_path"