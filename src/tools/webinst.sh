#!/bin/bash 
exec 3>&0
read -u 3 tester

curl https://raw.github.com/alternatex/shinst/develop/src/tools/install.sh -o shinst-install.sh
chmod a+x shinst-install.sh
./shinst-install.sh stable alternatex/bazinga 
rm -rf shinst-install.sh