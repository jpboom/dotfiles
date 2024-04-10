#!/usr/bin/env bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RESET='\033[0m'

echo -e "${BLUE}Check if configs already exist for files that will be symlinked.${RESET}"

# Check if the file exists (-e) and that it is not a symlink (-L)
# Only backup files, not symlinks
if [[ -e /etc/nixos/configuration.nix && ! -L /etc/nixos/configuration.nix ]]; then
  echo /etc/nixos/configuration.nix exists and needs to be removed so a symlink can be created.
  if [[ -w /etc/nixos/configuration.nix ]]; then
    echo /etc/nixos/configuration.nix is writable, create backup
    mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak
    if [ $? -eq 0 ]; then
      echo -e "${GREEN}/etc/nixos/configuration.nix removed, /etc/nixos/configuration.nix.bak created${RESET}"
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

# Check if the file exists (-e) and that it is not a symlink (-L)
# Only backup files, not symlinks
if [[ -e /etc/nixos/nvidia-drivers.nix && ! -L /etc/nixos/configuration.nix ]]; then
  echo /etc/nixos/nvidia-drivers.nix exists and needs to be removed so a symlink can be created.
  if [[ -w /etc/nixos/nvidia-drivers.nix ]]; then
    echo /etc/nixos/nvidia-drivers.nix is writable, create backup
    mv /etc/nixos/nvidia-drivers.nix /etc/nixos/nvidia-drivers.nix.bak
    if [ $? -eq 0 ]; then
      echo -e "${GREEN}/etc/nixos/nvidia-drivers.nix removed, /etc/nixos/nvidia-drivers.nix.bak created${RESET}"
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

echo -e "${BLUE}Create symlinks for configs from git${RESET}"
CURRENT_DIR=$(pwd)

if [[ -L /etc/nixos/configuration.nix ]]; then
  echo Symlink already exists for /etc/nixos/configuration.nix
  echo Attempt to remove the existing symlink to be replaced with our symlink
  rm /etc/nixos/configuration.nix
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Existing /etc/nixos/configuration.nix symlink removed${RESET}"
  else
    echo -e "${RED}Unable to remove existing /etc/nixos/configuration.nix symlink${RESET}"
    exit 1
  fi
fi

ln -s "${CURRENT_DIR}/nixos/configuration.nix" /etc/nixos/configuration.nix
if [ $? -eq 0 ]; then
  echo -e "${GREEN}/etc/nixos/configuration.nix symlink created${RESET}"
else
  echo -e "${RED}/etc/nixos/configuration.nix symlink failed${RESET}"
  exit 1
fi

if [[ -L /etc/nixos/nvidia-drivers.nix ]]; then
  echo Symlink already exists for /etc/nixos/nvidia-drivers.nix
  echo Attempt to remove the existing symlink to be replaced with our symlink
  rm /etc/nixos/nvidia-drivers.nix
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Existing /etc/nixos/nvidia-drivers.nix symlink removed${RESET}"
  else
    echo -e "${RED}Unable to remove existing /etc/nixos/nvidia-drivers.nix symlink${RESET}"
    exit 1
  fi
fi

ln -s "${CURRENT_DIR}/nixos/nvidia-drivers.nix" /etc/nixos/nvidia-drivers.nix
if [ $? -eq 0 ]; then
  echo -e "${GREEN}/etc/nixos/nvidia-drivers.nix symlink created${RESET}"
else
  echo -e "${RED}/etc/nixos/nvidia-drivers.nix symlink failed${RESET}"
  exit 1
fi

echo Setup complete!