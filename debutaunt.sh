#!/bin/bash

# DebUtAUnT
# Debian Update & APT Unified Terminal
# https://github.com/ehbush/debutaunt
# Created by Anthony C. Bush in 2021 for Personal / Home Use

# Defining Text Colours - setaf: Set ANSI Foreground....
fblack=$( tput setaf 0);
fred=$( tput setaf 1 );
fgreen=$( tput setaf 2 );
fyellow=$( tput setaf 3 );
fblue=$( tput sgr 4 );
fmagenta=$( tput sgr 5 );
fcyan=$( tput sgr 6 );
fwhite=$( tput sgr 7 );

# Foreground/Background Agnostic
reset=$( tput sgr0 );

# Defining Background Colours - setab: Set ANSI Background....
bblack=$( tput setab 0);
bred=$( tput setab 1 );
bgreen=$( tput setab 2 );
byellow=$( tput setab 3 );
bblue=$( tput setab 4 );
bmagenta=$( tput setab 5 );
bcyan=$( tput setab 6 );
bwhite=$( tput setab 7 );

# Script Intro
INTRO="
Welcome to DebUtAUnT! The Debian Update & APT Unified Terminal 

https://github.com/ehbush/debutaunt/"

# Defining USAGE Variable to print usage for -h or undefined args

USAGE="
Usage: sudo bash ubuntu-update.sh [-ugdrh]
       No option - Run all options (recommended)
       -u Don't run apt-get update
       -g Don't run apt-get upgrade -y
       -d Don't run apt-get dist-upgrade -y
       -r Don't run apt-get auto-remove
       -h Display Usage and exit
"

# Evaluating Command Line args and setting case variables for later use

while getopts ":ugdrh" OPT; do
  case ${OPT} in
    u ) uOff=1
      ;;
    g ) gOff=1
      ;;
    d ) dOff=1
      ;;
    r ) rOff=1
      ;;
    h ) hOn=1
      ;;
    \?) noOpt=1
  esac
done

# Do you have the proper permissions to execute these commands?

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

echo "\e[40;38;5;82m Hello \e[30;48;5;82m World \e[0m"$INTRO${reset}"

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
