#!/bin/bash

# go home
cd ~

if command -v "shinst" &>/dev/null
then
	printf "\e[32mshinst is installed.\e[0m   $1\n"
    exit 1
else
	# fetch *
	wget "https://raw.github.com/alternatex/shinst/master/src/shinst.sh?login=alternatex&token=cc51a6c29eda129bc65d0eeea267e738" -O shinst.sh && chmod a+x shinst.sh  

	# install self
	./shinst.sh "install" "alternatex/shinst" -n "shinst"

	# cleanup
	rm -rf shinst.sh
fi

