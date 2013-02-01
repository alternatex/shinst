#!/bin/bash

# general date/time formatting
datetime=$(date +%Y%m%d%H%M%S)

# inspired by / borrowed from http://stackoverflow.com/questions/394230/detect-the-os-from-a-bash-script
function inspect_env(){
  OS=`lcase $(uname)`
  KERNEL=`uname -r`
  MACH=`uname -m`    
  VERSION="-"
  DIST="-"
  DistroBasedOn="-"
  PSUEDONAME="-"
  REV="-" 
  if [ "${OS}" = "windowsnt" ]; then
    OS=windows
  elif [ "${OS}" = "darwin" ]; then
    OS=mac
    VERSION=`sw_vers -productVersion`
  else
    OS=`uname`
    if [ "${OS}" = "SunOS" ] ; then
      OS=Solaris
      ARCH=`uname -p`
      OSSTR="${OS} ${REV}(${ARCH} `uname -v`)"
    elif [ "${OS}" = "AIX" ] ; then
      OSSTR="${OS} `oslevel` (`oslevel -r`)"
    elif [ "${OS}" = "Linux" ] ; then
      if [ -f /etc/redhat-release ] ; then
        DistroBasedOn='RedHat'
        DIST=`cat /etc/redhat-release |sed s/\ release.*//`
        PSUEDONAME=`cat /etc/redhat-release | sed s/.*\(// | sed s/\)//`
        REV=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//`
      elif [ -f /etc/SuSE-release ] ; then
        DistroBasedOn='SuSe'
        PSUEDONAME=`cat /etc/SuSE-release | tr "\n" ' '| sed s/VERSION.*//`
        REV=`cat /etc/SuSE-release | tr "\n" ' ' | sed s/.*=\ //`
      elif [ -f /etc/mandrake-release ] ; then
        DistroBasedOn='Mandrake'
        PSUEDONAME=`cat /etc/mandrake-release | sed s/.*\(// | sed s/\)//`
        REV=`cat /etc/mandrake-release | sed s/.*release\ // | sed s/\ .*//`
      elif [ -f /etc/debian_version ] ; then
        DistroBasedOn='Debian'
        DIST=`cat /etc/lsb-release | grep '^DISTRIB_ID' | awk -F=  '{ print $2 }'`
        PSUEDONAME=`cat /etc/lsb-release | grep '^DISTRIB_CODENAME' | awk -F=  '{ print $2 }'`
        REV=`cat /etc/lsb-release | grep '^DISTRIB_RELEASE' | awk -F=  '{ print $2 }'`
        VERSION=`cat /etc/debian_version`
      fi
      if [ -f /etc/UnitedLinux-release ] ; then
        DIST="${DIST}[`cat /etc/UnitedLinux-release | tr "\n" ' ' | sed s/VERSION.*//`]"
      fi
      OS=`lcase $OS`
      DistroBasedOn=`lcase $DistroBasedOn`     
      readonly OS
      readonly VERSION
      readonly DIST
      readonly DistroBasedOn
      readonly PSUEDONAME
      readonly REV
      readonly KERNEL
      readonly MACH      
    fi

  fi
}

# ...
function check_shinst_pkg(){

  # check shinst pkg
  if [[ -a "$(which $1)" ]]; then 

    # ... 
    printf "\e[$1 found.\e[0m \n"
  else 
    
    # install dependency
    printf "\e[32minstalling $1...\e[0m \n"

    # install shinst pkg
    shinst install $2
  fi
}

# ...
function check_webinst(){

  # check webinst
  if [[ -a "$(which $1)" ]]; then 

    # ... 
    printf "\e[32m$1 found.\e[0m \n"
  else 
    
    # install dependency
    printf "\e[1;31m$1 not found.\e[0m \n"

    # fetch/process shinst installer
    bash -s stable < <(wget $2 -O -)
  fi
}