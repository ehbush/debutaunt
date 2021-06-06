#!/bin/bash

# DebUtAUnT
# Debian Update Tool & APT Unified Terminal
# https://github.com/ehbush/debutaunt
# Created by Anthony C. Bush in 2021 for Personal / Home Use

# Defining Colours

bold="\e[1m"
inv="\e[7"
red="\e[31m"
green="\e[32m"
yellow="\e[33m"
reset="\e[0m"

# Script Intro
INTRO="
Welcome to DebUtAUnT! The Debian Update Tool & APT Unified Terminal 

https://github.com/ehbush/debutaunt/"

# Defining how to use Debutaunt's variables

USAGE="
Usage: sudo bash debutaunt.sh [-flags]
       Flags are optional. If no flags are specified upon execution, Debutaunt runs with its default configuraton. The default configuration includes: Update, Upgrade, Dist-Upgrade, Full-Upgrade, and Auto-Remove
       -u Don't run apt-get update
       -g Don't run apt-get upgrade -y
       -d Don't run apt-get dist-upgrade -y
       -r Don't run apt-get auto-remove
       -h Display Usage and exit
       -p DietPi Specific Flag 
       -n PiHole Specific Flag
"

# Evaluating Command Line args and setting case variables for later use

while getopts ":ugdrhpn" OPT; do
  case ${OPT} in
    u ) uOn=1
      ;;
    g ) gOn=1
      ;;
    d ) dOn=1
      ;;
    r ) rOn=1
      ;;
    h ) hOn=1
      ;;
    p ) pOn=1
      ;;
    n ) nOn=1
      ;;
    \?) noOpt=1
  esac
done

# Verifying script is being executed as root, or with sudo permission as this is required

if [[ ${UID} != 0 ]]; then
    echo "${bred} ${fwhite}
    Uh-Oh! Looks like someone doesn't have sudo permissions...
    Better luck next time!${reset}
    "
    exit 1
fi

# Executing based on option selection

if [[ -n $hOn || $noOpt ]]; then
    echo "${fgreen}$USAGE${reset}"
    exit 2
fi

# Display Script Intro

echo "${bold} ${green}$INTRO${reset}"

if [[ ! -n $uOff ]]; then
    echo -e "
\e[32m#############################
#     Executing APT Update   #
#############################\e[0m
"
apt-get update | tee /tmp/update-output.txt
fi

if [[ ! -n $gOff ]]; then
    echo -e "
\e[32m##############################
# Execute APT Upgrade #
##############################\e[0m
"
apt-get upgrade -y | tee -a /tmp/update-output.txt
fi

if [[ ! -n $dOff ]]; then
    echo -e "
\e[32m#############################
#   Executing Dist-Upgrade  #
#############################\e[0m
"
apt-get dist-upgrade -y | tee -a /tmp/update-output.txt
echo -e "
\e[32m#############################
#   Dist Upgrade Complete   #
#############################\e[0m
"
fi

if [[ ! -n $rOff ]]; then
    echo -e "
\e[32m#############################
#    Executing APT Autoremove    #
#############################\e[0m
"
apt-get autoremove -y | tee -a /tmp/update-output.txt
echo -e "
\e[32m#############################
#     Great Success! APT Autoremove has completed!     #
#############################\e[0m
"
fi

# Check for existence of update-output.txt and exit if not there.

if [ -f "/tmp/update-output.txt"  ]

then

# Search for issues user may want to see and display them at end of run.

  echo -e "
\e[32m#####################################################
#   Alert, Alert! Reading output of the updates & upgrades, to identify any potential issues...   #
#####################################################\e[0m
"
  egrep -wi --color 'warning|error|critical|reboot|restart|autoclean|autoremove' /tmp/update-output.txt | uniq
  echo -e "
\e[32m#############################
#    Cheerio Mate! It's now time to clean up the temp files we created...uno momento, por favor!    #
#############################\e[0m
"

  rm /tmp/update-output.txt
  echo -e "
\e[32m#############################
#     Everything looks good from my side. Best of luck in your travels!    #
#############################\e[0m
"

exit 0

else

# Exit with message if update-output.txt file is not there.

  echo -e "
\e[32m#########################################################
# Why you ain't choose any options tho? You tryna start beef? Nvm, you ain't even worth it...Exiting. #
#########################################################\e[0m
"

fi

exit 0
