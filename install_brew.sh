#!/bin/bash

install=$1

xcode-select -p &> /dev/null

if [ $? -ne 0 ]; then
  echo "xcode cli tools not found. Installing ..."
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
  PROD=$(softwareupdate -l |
    grep "\*.*Command Line" |
    head -n 1 | awk -F"*" '{print $2}' |
    sed -e 's/^ *//' |
    tr -d '\n')
  softwareupdate -i "$PROD" -v;
else
  echo "Xcode CLI tools OK"
fi

/bin/bash -c $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)

brew update

brew bundle --file "Brewfile.$install"

# clean up self updating casks
apps="discord duckduckgo firefox iterm2 lulu oversight plex spotify steam visual-studio-code"

for app in $apps
do
  rm -rf "/opt/homebrew/Casks/$app"
done
