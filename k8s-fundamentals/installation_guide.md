# Installation Guide

This installation guide describe the process of setting up a fresh installation of Ubuntu Server 20.04 that will be used in the following module.

```bash
# run the following command to fetch and run the setup script
$> curl -Lq https://raw.githubusercontent.com/alexZaicev/learning-materials/main/k8s-fundamentals/resources/scripts/setup.sh | sh -
```

**NOTE:** After the setup script is finished executing, make sure to re-login into your system.

```bash
# in order to run K3s kubectl command without password edit the following file
# and paste the following line at the bottom of the file, changing 'USER' with
# your system user name: 
# USER ALL=NOPASSWD:/usr/local/bin/kubectl
$> sudo visudo
```

**NOTE:** After updating `/etc/sudoers` file make sure to re-login or reboot your system.