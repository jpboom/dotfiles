This repository is intended to be cloned directly into the home directory. The install script will fail if put anywhere else. The following assumes you are in the `~/jpboom-config` directory that would be created by default when cloning the repo into the home directory.

To run the install script it needs to be made executable.

```
chmod 755 ./install.sh
```

The install script will need to be run with sudo, otherwise it won't have permissions to change anything in the `/etc/nixos` directory. You can read the script before running it to make sure it won't do anything unexpected.

```
sudo ./install.sh
```