#!/usr/bin/env bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
RESET='\033[0m'

echo Check if configs already exist for files that will be symlinked.

if [[ -e /etc/nixos/configuration.nix ]]; then
  echo /etc/nixos/configuration.nix exists and needs to be removed so a symlink can be created.
  if [[ -w /etc/nixos/configuration.nix ]]; then
    echo /etc/nixos/configuration.nix is writable, create backup
    mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak
    if [ $? -eq 0 ]; then
      echo -e "${GREEN}/etc/nixos/configuration.nix backup created${RESET}"
    else
      echo -e "${RED}/etc/nixos/configuration.nix backup failed${RESET}"
      exit 1
    fi
  else
    echo -e "${RED}/etc/nixos/configuration.nix is not writable${RESET}"
    exit 1
  fi
else
  echo -e "${GREEN}/etc/nixos/configuration.nix does not exist${RESET}"
fi

if [[ -e /etc/nixos/nvidia-drivers.nix ]]; then
  echo /etc/nixos/nvidia-drivers.nix exists and needs to be removed so a symlink can be created.
  if [[ -w /etc/nixos/nvidia-drivers.nix ]]; then
    echo /etc/nixos/nvidia-drivers.nix is writable, create backup
    mv /etc/nixos/nvidia-drivers.nix /etc/nixos/nvidia-drivers.nix.bak
    if [ $? -eq 0 ]; then
      echo -e "${GREEN}/etc/nixos/nvidia-drivers.nix backup created${RESET}"
    else
      echo -e "${RED}/etc/nixos/nvidia-drivers.nix backup failed${RESET}"
      exit 1
    fi
  else
    echo -e "${RED}/etc/nixos/nvidia-drivers.nix is not writable${RESET}"
    exit 1
  fi
else
  echo -e "${GREEN}/etc/nixos/nvidia-drivers.nix does not exist${RESET}"
fi

echo Create symlinks for configs from git

ln -s configuration.nix /etc/nixos/configuration.nix
if [ $? -eq 0 ]; then
  echo -e "${GREEN}/etc/nixos/configuration.nix symlink created${RESET}"
else
  echo -e "${RED}/etc/nixos/configuration.nix symlink failed${RESET}"
  exit 1
fi

ln -s nvidia-drivers.nix /etc/nixos/nvidia-drivers.nix
if [ $? -eq 0 ]; then
  echo -e "${GREEN}/etc/nixos/nvidia-drivers.nix symlink created${RESET}"
else
  echo -e "${RED}/etc/nixos/nvidia-drivers.nix symlink failed${RESET}"
  exit 1
fi

echo Setup complete!