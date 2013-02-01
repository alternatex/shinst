#!/bin/sh

# inspired by & borrowed from https://github.com/robbyrussell/oh-my-zsh/blob/master/tools/check_for_upgrade.sh

# ...
current_epoch() {

  # get timestamp
  echo $(($(date +%s) / 60 / 60 / 24))
}

# ...
update_cfg() {

  # set last update
  echo "LAST_EPOCH=$(current_epoch)" > ~/.shinst-update
}

# ...
upgrade() {
  
  # run upgrade
  /usr/bin/env SHINST=$SHINST /bin/sh $SHINST/src/tools/upgrade.sh

  # update the shinst file
  update_cfg
}

# ...
check_for_upgrade(){

  # ...
  epoch_target=$UPDATE_SHINST_DAYS

  # ...
  if [[ -z "$epoch_target" ]]; then
    
    # Default to old behavior
    epoch_target=13
  fi

  # ...
  if [ -f ~/.shinst-update ]
  then
    
    # ...
    . ~/.shinst-update

    # ...
    if [[ -z "$LAST_EPOCH" ]]; then

      # ...
      update_cfg && return 0;
    fi

    # ...
    epoch_diff=$(($(current_epoch) - $LAST_EPOCH))

    # ...
    if [ $epoch_diff -gt $epoch_target ]
    then

      # ...
      if [ "$DISABLE_UPDATE_PROMPT" = "true" ]
      then

        # ...
        upgrade
      # ...
      else

        # ...
        echo "[Shinst] Would you like to check for updates?"
        echo "Type Y to update Shinst: \c"
        read line

        # ...
        if [ "$line" = Y ] || [ "$line" = y ]; then

          # ...
          upgrade
        else

          # ...
          update_cfg
        fi
      fi
    fi
  else

    # create the shinst file
    update_cfg
  fi
}