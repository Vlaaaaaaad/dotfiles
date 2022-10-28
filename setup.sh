#!/bin/bash

if [[ $(uname) = 'Linux' ]]; then
  if [[ -n $CODESPACES ]]; then
    echo "Running in GitHub Codespaces, which is still todo..."
    exit 1
  fi

  if [[ -n $GITPOD_WORKSPACE_ID ]]; then
    echo "Running in Gitpod, which is still todo..."
    exit 1
  fi

elif [[ $(uname) = 'Darwin' ]]; then
  echo "Running on macOS..."

  read -rp "Install base macOS apps? <y/N> " prompt
  if [[ $prompt == "y" || $prompt == "Y" ]]; then
    bash ./scripts/macos-apps.sh
  fi

  read -rp "Is this machine a personal one? <y/N> " prompt
  if [[ $prompt == "y" || $prompt == "Y" ]]; then
    bash ./scripts/macos-personal.sh
  fi

  read -rp "Forcibly set Settings? <y/N> " prompt
  if [[ $prompt == "y" || $prompt == "Y" ]]; then
    bash ./scripts/macos-settings.sh
  fi

  read -rp "Will this machine be used for developement? <y/N> " prompt
  if [[ $prompt == "y" || $prompt == "Y" ]]; then
    bash ./scripts/dev.sh
  fi

fi
