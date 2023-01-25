#!/bin/bash
#
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# + This script must run on root or sudo permission                    						+
# + Supported CentOS 7 with architecture x86_64, ppc64le and aarch64   						+
# + Based on https://www.postgresql.org/download/linux/redhat/         						+
# + Tested in Linux Centos 7 x86_64                                    						+
# + Usage : curl -s https://raw.githubusercontent.com/reko-srowako/Postgresql-on-Centos-7/main/run.sh | bash	+
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
#

# Variable
PGVERSION=11  				# Postgresql version e.g. 11, 12, 13 14 15
LOGFILE=install.log 			# Log file name
DATE=`date`                             # Variable to capture date now using command date 
PGAPP=postgresql$PGVERSION-server	# Postgresql package name
PGREPO=pgdg-redhat-repo 		# Postgresql repository package name


# Verify script must run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root."
   exit 1
fi


# Log everything bellow and add "| tee /dev/fd/3" for sends its output to both the console and the log file  
exec 3>&1 1>>${LOGFILE} 2>&1   


# Log file creation
echo ""
echo "$DATE Creating log file $LOGFILE ... " | tee /dev/fd/3
if [ ! -f $LOGFILE ]; 
     then
        touch $LOGFILE
        echo "Log file created in the same directory of this script with name $LOGFILE." | tee /dev/fd/3
     else 
        echo "File already exist in the same directory of this script with name $LOGFILE." | tee /dev/fd/3
fi
echo ""


# Verify OS centos 7
echo "$DATE Checking OS ... " | tee /dev/fd/3

OS=$(cat /etc/redhat-release | awk '{print $1}')                        # Check OS name 
VERSION=$( cat /etc/redhat-release | grep -oP "[0-9]+" | head -1 )      # Check OS version

if [[ $OS == CentOS && $VERSION == 7 ]]; then
  echo "$OS $VERSION" | tee /dev/fd/3
else
  echo "Looks like your operating system is not CentOS 7" | tee /dev/fd/3
  exit 1
fi
echo ""


# Checking and Install Repository 
echo "$DATE Checking repository postgresql ... " | tee /dev/fd/3

# Check OS Architecture
OSARCH=`uname -m` 

if [[ $OSARCH == x86_64 ]]; then
	DOWNARCH=x86_64
elif [[ $OSARCH == ppc64le ]]; then
	DOWNARCH=ppc64le
elif [[ $OSARCH == aarch64 ]]; then
	DOWNARCH=aarch64
else
    echo "Looks like your Centos 7 with Architecture $OSARCH is not supported using this script" | tee /dev/fd/3
    echo "This script use reference in https://www.postgresql.org/download/linux/redhat/" | tee /dev/fd/3
    echo "For CentOS 7 Supported Architecture is x86_64, ppc64le and aarch64" | tee /dev/fd/3
    exit 1;
fi

echo "$DOWNARCH" | tee /dev/fd/3

for i in ${PGREPO[*]}
 do
  isinstalled=$(rpm -q $i)
  if [ ! "$isinstalled" == "package $i is not installed" ];
   then
    echo "Repository postgresql already installed." | tee /dev/fd/3
   else
    echo "Installing repository ... " | tee /dev/fd/3
    yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-$DOWNARCH/pgdg-redhat-repo-latest.noarch.rpm | tee /dev/fd/3
  fi
done
echo ""


# Checking and Install Postgresql Package
echo "$DATE Checking postgreSQL in system... " | tee /dev/fd/3

for a in ${PGAPP[*]}
 do
  isinstalled1=$(rpm -q $a)
  if [ ! "$isinstalled1" == "package $a is not installed" ];
   then
    echo "Package $a already installed." | tee /dev/fd/3
    exit 1
   else
    echo "Package $a is not installed." | tee /dev/fd/3
    echo "Installing $a ... "
    yum install -y postgresql$PGVERSION-server | tee /dev/fd/3
  fi
done
echo ""


# Initialize database 
echo "$DATE Initialize database ... " | tee /dev/fd/3
/usr/pgsql-$PGVERSION/bin/postgresql-$PGVERSION-setup initdb | tee /dev/fd/3
echo ""


# Setup postgresql service can run on boot
echo "$DATE Enable postgresql service  on boot ... "  | tee /dev/fd/3
systemctl enable postgresql-$PGVERSION | tee /dev/fd/3
echo ""


# Starting postgresql service 
echo "$DATE Starting Postgresql-$PGVERSION service ... " | tee /dev/fd/3
systemctl start postgresql-$PGVERSION | tee /dev/fd/3
echo ""


# Print postgresql data directory and config file location
PGVERSIONCHK=$(su - postgres -c "psql -t -P format=unaligned -c 'SELECT version()';")
PGDATA=$(su - postgres -c "psql -t -P format=unaligned -c 'SHOW data_directory';")
PGCONFIG=$(su - postgres -c "psql -t -P format=unaligned -c 'SHOW config_file';")
HBACONFIG=$(su - postgres -c "psql -t -P format=unaligned -c 'SHOW hba_file';")

echo "=============================================================================" | tee /dev/fd/3
echo "" | tee /dev/fd/3
echo "Postgresql version installed :"  | tee /dev/fd/3
echo $PGVERSIONCHK | tee /dev/fd/3
echo "" | tee /dev/fd/3
echo "Postgresql directory to use for data storage :" | tee /dev/fd/3
echo $PGDATA | tee /dev/fd/3
echo "" | tee /dev/fd/3
echo "Postgresql main server configuration file (customarily called postgresql.conf) :" | tee /dev/fd/3
echo $PGCONFIG | tee /dev/fd/3
echo "" | tee /dev/fd/3
echo "Postgresql configuration file for host-based authentication (customarily called pg_hba.conf) :" | tee /dev/fd/3
echo $HBACONFIG | tee /dev/fd/3
echo "" | tee /dev/fd/3
echo "Postgresql service command :" | tee /dev/fd/3
echo "systemctl status postgresql-$PGVERSION 	# For showing status service " | tee /dev/fd/3
echo "systemctl start postgresql-$PGVERSION 	# For start service" | tee /dev/fd/3
echo "systemctl stop postgresql-$PGVERSION 	# For stop service" | tee /dev/fd/3
echo "systemctl restart postgresql-$PGVERSION 	# For restart service" | tee /dev/fd/3
echo "" | tee /dev/fd/3
echo "=============================================================================" | tee /dev/fd/3

# End of Process
echo ""
echo "$DATE Script Done ..." | tee /dev/fd/3
echo "Log file name : install.log" | tee /dev/fd/3
echo ""
