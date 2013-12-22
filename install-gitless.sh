#!/bin/bash

set -e

if [ ! "$NVM_SOURCE" ]; then
  NVM_SOURCE="https://raw.github.com/creationix/nvm/master/nvm.sh"
fi

if [ ! "$NVM_DIR" ]; then
  NVM_DIR="$HOME/.nvm"
fi

# Downloading to $NVM_DIR
mkdir -p "$NVM_DIR"
echo -e "\r=> Downloading... \c"
curl --silent "$NVM_SOURCE" -o "$NVM_DIR/nvm.sh" || {
  echo "Failed downloading $NVM_SOURCE" && exit 1
}
echo "Downloaded"

echo

# Detect profile file if not specified as environment variable (eg: PROFILE=~/.myprofile).
if [ ! "$PROFILE" ]; then
  if [ -f "$HOME/.bash_profile" ]; then
    PROFILE="$HOME/.bash_profile"
  elif [ -f "$HOME/.zshrc" ]; then
    PROFILE="$HOME/.zshrc"
  elif [ -f "$HOME/.profile" ]; then
    PROFILE="$HOME/.profile"
  fi
fi

SOURCE_STR="[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"  # This loads NVM"

if [ -z "$PROFILE" ] || [ ! -f "$PROFILE" ] ; then
  if [ -z $PROFILE ]; then
	echo "=> Profile not found"
  else
	echo "=> Profile $PROFILE not found"
  fi
  echo "=> Append the following line to the correct file yourself"
  echo
  echo "\t$SOURCE_STR"
  echo
  echo "=> Close and reopen your terminal to start using NVM"
  exit
fi

if ! grep -qc 'nvm.sh' $PROFILE; then
  echo "=> Appending source string to $PROFILE"
  echo "" >> "$PROFILE"
  echo $SOURCE_STR >> "$PROFILE"
else
  echo "=> Source string already in $PROFILE"
fi

echo "=> Close and reopen your terminal to start using NVM"
