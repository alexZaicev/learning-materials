# Container fundamentals

## Virtualization fundamentals

* Control groups (cgroups) - feature of the Linux kernel allowing the limitation, accounting, and isolation of resources used by groups of processes and the subgroup. Containers benefit from cgroups primarily because they allow system resources to be limited for processes grouped by a container. In addition, the processes of a container are treated and managed as a whole unit, and a container may be prioritized for preferential resource allocation.

```bash
#!/bin/bash

# run the following to install cgroup tooling
$ sudo apt-get update && sudo apt-get install -y cgroup-tools
# list all cgroups
$ sudo lscgroup
# list cgroup associated with a specific process
$ sudo cat  /proc/{PID}/cgroup
```

* Namespaces - are a feature of the Linux kernel allowing groups of processes have limited visibility of the host system resources. Namespaces may limit the visibility of cgroups, hostname, process IDs, IPC mechanisms, network interfaces and routes, users, and mounted file systems. To an isolated process running inside a namespace, a namespaced resource, such as the network, will appear as the process' own dedicated resource. In the context of containers, namespaces isolate processes from one container to prevent them from modifying the hostname, network interfaces, or mounts for processes running in other containers.

```bash
#!/bin/bash
# list namespaces  for a particular process
$ sudo ls -l /proc/{PID}/ns
```

* Unification File System (UnionFS) - is a feature found in Linux, FreeBSD etc., allowing the overlay of separate transparent file systems to produce an apparent single unified system.n a container, unionfs allows for changes to be made to the container image at runtime. The container image and other writable file systems are all stacked into a unionfs when the container is created and is running. The unified file system gives the impression that the actual container image is being modified. In reality, however, these changes are saved onto a real writable file system, part of the unionfs, while leaving the base container image file intact. In some environments, there is a possibility to export the new stacked files of the container into a new container image allowing users to create new and improved container images out of existing ones. All this while keeping image file sizes to a minimum as the new image file only stores the new changes with a link to the base image file.

```bash
#!/bin/bash
# run the following to install unionfs tooling
$ sudo apt-get update && sudo apt-get install -y unionfs-fuse
# create a union of a set of directory branches
$ unionfs foo/:bar/:baz/ union
# this would create a union name 'union' of the provided 3 branches
```

## Virtualization mechanisms

Virtual Machine (VM) is created on top of Hypervisor (HyperV) software that emulates hardware components (CPU, RAM etc). Typical application running in a VM requires extensive overhead to reach the physical hardware or outside worlds due to the level of abstraction. 

Container is a light-weight environment that virtualizes and isolates resources from a running application (e.g. microservice). Image, serving as a template for the container, allows application to be boxed and shipped with all its dependencies. Once deployed, container runs on the host-OS making that emulation overhead disappear.

Operating system-level virtualization - is a kernel's capability to allow the creation and existence of multiple isolated virtual environments on the same host (AKA containers, zones, partitions etc.). While this approach requires less overhead than full virtualization (because everything is managed at the kernel level), it limits the OS of the virtual environment to host OS. Also, the OS-level virtualization introduces a stacked storage management model, implemented by the file-level Copy-on-Write (CoW) mechanism. This CoW mechanism ensures minimal storage space usage when saving files that are being modified. Changes and new data are stored on disk, but data duplication is prevented by making heavy usage of links for referencing original data that remains unchanged.

* Chroot - is a mechanism implementing OS-level virtualization operating on Unix-like systems by changing the apparent root directory of a process and its children. The apparent root directory is no longer the real root directory of the OS, it’s a virtual root directory - chrooted directory. While only a root user may perform a chroot, it is not a defence mechanism against root attacks. A second chroot may be performed by a program with elevated privileges to break out of the chroot jail. In order to avoid such escapes, FreeBSD jails should be used instead, because FreeBSD can prevent a second chroot type of attack. While chroot provides partial filesystem isolation and nested virtualization, it shares some system resources such as users, I/O, network bandwidth, hostname, IP address, disk space and CPU time.

```bash
#!/bin/bash

# install Debian based guest
$ sudo apt-get install -y debianstrap
# create subdirectory for guest
$ sudo mkdir /mnt/chroot-ubuntu-xenial
# install Ubuntu Xenial suite
$ sudo debootstrap xenial /mnt/chroot-ubuntu-xenial/ http://archive.ubuntu.com/ubuntu
# open shell into installed guest OS
$ sudo chroot /mnt/chroot-ubuntu-xenial/ /bin/bash
```

* FreeBSD Jails -  is a mechanism implementing OS-level virtualization with very little overhead, allowing for the partitioning of a FreeBSD system into many independent systems - jails. They share the same kernel, but virtualize the system's files an resources for improved security and administration through clean isolation between services. Jailed processes are restricted form communicating with processes from other jails or the host, loading additional kernel modules, modifying network configurations, and performing filesystem operations to mount/unmount volumes. 

* Solaris Zones - represent securely isolated VMs on a single host system, hosting single or multiple applications/services/children. Each zone on a host system virtualizes its hostname, network, IP address, and it has assigned storage. Zones may have allocated physical resources (CPU, RAM etc.), but they required minimal storage for the configuration data. Processes running inside a zone are isolated from other zones and the rest of the host system. Direct communication is possible among processes within the same zone, however, communication with processes from other zones is only allowed through APIs. Zones may be used to run multiple applications on a single host while reducing operating costs and management complexity.
	
* OpenVZ  - allows host to run multiple isolated virtual instances (containers/virtual environments) running on the same kernel, but restricted only to Linux OS. OpenVZ containers, although virtualized systems, behave just like real physical hosts. Each container has its own virtual filesystem, users, processes, and network. By default, containers are hardware-independent because they do not have access to the real hardware of the host. However, access can be enabled by administrators to some physical devices such as disks and network cards.
	
* Linux Containers (LXC) - allows multiple isolated systems to run on a single Linux host, using chroot and cgroups, together with namespace isolation features of the Linux kernel to limit resources, set priorities, and isolate processes, the filesystem, network and users from the host operating system. LXC does not support cgroup multiple Linux hosts in namespaces for isolation.

```bash
#!/bin/bash

# intall LXC
$ sudo apt-get install -y lxc
# add current user 'dev' (non-root)  to a configuration file that allows the user to create network devices on the host
$ sudo bash -c 'echo dev veth lxcbr0 10 >> /etc/lxc/lxc-usernet'
# setup configuration file for LXC (make sure that file is not already setup by running -> 'ls -a ~/ | grep config')
$ mkdir -p ~/.config/lxc
$ cp /etc/lxc/default.conf ~/.config/lxc/default.conf
$ chmod 644 ~/.config/lxc/default.conf
# modify default.conf with UID and GID maps of the 'dev' user
$ echo lxc.idmap = u 0 $(cat /etc/subuid | cut -f 2 -d :) $(cat /etc/subuid | cut -f 3 -d :) >> ~/.config/lxc/default.conf
$ echo lxc.idmap = g 0 $(cat /etc/subgid | cut -f 2 -d :) $(cat /etc/subgid | cut -f 3 -d :) >> ~/.config/lxc/default.conf
# set access control list on ~/.local directory with the same UID value to prevent possible permission error
$ setfacl -R -m u:$(cat /etc/subuid | cut -f 2 -d :):x ~/.local
# setup unpriviledged container from the download template
$ lxc-create --template download --name unpriv-cont-user # list available templates
$ lxc-create --template download --name unpriv-cont-user --
--dist ubuntu --release xenial --arch amd64 # installs Ubuntu Xenial amd64
# start the installed container
$ lxc-start -n unpriv-cont-user -d
# list containers
$ lxc-ls -f
# show information for our container
$ lxc-info -n unpriv-cont-user
# login into out container
$ lxc-attach -n unpriv-cont-user
# stop and remove out container
$ lxc-stop -n unpriv-cont-user
$ lxc-destroy -n unpriv-cont-user
```

* Systemd-nspawn - may be used to run a simple script or boot an entire Linux-like operating system in a container. Systemd-nspawn fully isolates containers from each other and from the host system, therefore processes running in a container are not able to communicate with processes from other containers. It fully virtualizes the process tree, filesystem, users, host and domain name. Containers created by systemd-nspawn can be managed with systemd.

```bash
#!/bin/bash
# install the tool
$ sudo apt-get install -y systemd-container
# bootstrap Deian based system on the host
$ sudo debootstrap --arch=amd64 stable ~/DebianContainer 
# create container from ~/DebianContainer 
$ sudo systemd-nspawn -D ~/DebianContainer
# list container details
$ sudo machinectl list
# list container details
$ sudo machinectl show DebianContainer
# terminate container
$ sudo machinectl terminate DebianContainer
```

## Container standard and runtimes

The Open Container Initiative (OCI) - introduced in 2015 by Docker and others. `runC` is one of container runtimes implementing the OCI specification. Specifications:

* The Runtime Specification defines how to run a "filesystem bundle" that is unpacked on disk. An OCI implementation would download and unpack an OCI image into an OCI Runtime filesystem bundle. Then, an OCI Runtime would run the OCI Runtime Bundle. 
* The Image Specification helps with the development of compatible tools to ensure consistent container image conversion into containers.
