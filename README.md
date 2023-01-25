# Postgresql-on-Centos-7
This scripts are reliable, powerful and can handle any possible issues that can occur during the script execution. This script logs what it’s doing. This script runs on any centos 7 machine.
- This script must run on root or sudo permission
- Supported CentOS 7 with architecture x86_64, ppc64le and aarch64
- Based on https://www.postgresql.org/download/linux/redhat/
- Tested in Linux Centos 7 x86_64
- Log execution [install.log](https://raw.githubusercontent.com/reko-srowako/Postgresql-on-Centos-7/main/install.log)

## Quick Start

```shell
curl -s https://raw.githubusercontent.com/reko-srowako/Postgresql-on-Centos-7/main/run.sh | bash
```

<img src="https://raw.githubusercontent.com/reko-srowako/Postgresql-on-Centos-7/main/screenshots/pg-centos7.png?v1" width=700/>

### Handle any possible issues
- Variable script Postgresql version e.g. 11, 12, 13 14 15
- Verify script must run as root
- Verify OS centos 7
- Checking and Install Repository
- Checking and Install Postgresql Package
- Initialize database
- Setup postgresql service can run on boot
- Starting postgresql service
- Print postgresql data directory and config file location
```shell
================================================================================
 Package                  Arch        Version                 Repository   Size
================================================================================
Installing:
 postgresql11-server      x86_64      11.18-1PGDG.rhel7       pgdg11      4.7 M
Installing for dependencies:
 libicu                   x86_64      50.2-4.el7_7            base        6.9 M
 postgresql11             x86_64      11.18-1PGDG.rhel7       pgdg11      1.7 M
 postgresql11-libs        x86_64      11.18-1PGDG.rhel7       pgdg11      369 k
```
### Connect with
- BUFISA GLOBAL DATATECH (Documentation recruitment by Reko Srowako)
