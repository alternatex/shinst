#!/bin/sh
# inspired by & borrowed from https://github.com/robbyrussell/oh-my-zsh/blob/master/tools/check_for_upgrade.sh

_current_epoch() {

  # get timestamp
  echo $(($(date +%s) / 60 / 60 / 24))
}

_update_shinst_update() {

  # set last update
  echo "LAST_EPOCH=$(_current_epoch)" > ~/.shinst-update
}

_upgrade_shinst() {
  
  # run upgrade
  /usr/bin/env SHINST=$SHINST /bin/sh $SHINST/src/tools/upgrade.sh

  # update the shinst file
  _update_shinst_update
}

epoch_target=$UPDATE_SHINST_DAYS

if [[ -z "$epoch_target" ]]; then
  # Default to old behavior
  epoch_target=13
fi

if [ -f ~/.shinst-update ]
then
  . ~/.shinst-update

  if [[ -z "$LAST_EPOCH" ]]; then
    _update_shinst_update && return 0;
  fi

  epoch_diff=$(($(_current_epoch) - $LAST_EPOCH))
  if [ $epoch_diff -gt $epoch_target ]
  then
    if [ "$DISABLE_UPDATE_PROMPT" = "true" ]
    then
      _upgrade_shinst
    else
      echo "[Shinst] Would you like to check for updates?"
      echo "Type Y to update Shinst: \c"
      read line
      if [ "$line" = Y ] || [ "$line" = y ]; then
        _upgrade_shinst
      else
        _update_shinst_update
      fi
    fi
  fi
else
  # create the shinst file
  _update_shinst_update
fi