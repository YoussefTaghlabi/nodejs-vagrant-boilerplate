#!/usr/bin/env bash

############################
# SETUP SCRIPT #
############################

# Variables
RED="\e[1;31m%-6s\e[m\n"
GREEN="\e[1;32m%-6s\e[m\n"
YELLOW="\e[1;33m%-6s\e[m\n"
BLUE="\e[1;34m%-6s\e[m\n"
MAGENDA="\e[1;35m%-6s\e[m\n"
CYAN="\e[1;36m%-6s\e[m\n"

# Functions
function msg {
    printf "$BLUE" "$1"
}

function checkIfProcessIsRunning {
    if ps -ef | grep -v grep | grep -i "$1" > /dev/null
    then
        printf "$GREEN" "       $1 is running...[YES]"
    else
        printf "$RED" "       $1 is running...[NO]"
    fi
}

function checkIfFileExists {
    if [ -f $1 ];
    then
        printf "$GREEN" "           $1 exists...[YES]"
    else
        printf "$RED" "           $1 exists...[NO]"
    fi
}

function checkIfDirectoryExists {
    if [ -d $1 ];
    then
        printf "$GREEN" "           $1 exists...[YES]"
    else
        printf "$RED" "           $1 exists...[NO]"
    fi
}

function checkIfPackageIsInstalled {
    printf "$GREEN" command -v $1 >/dev/null && echo "yes" || echo "no"
}



msg "--------------------------------------------------"

# Time
    msg  "Set Time to EDT"
        echo "America/New_York" | sudo tee /etc/timezone > /dev/null 2>&1
        sudo dpkg-reconfigure --frontend noninteractive tzdata > /dev/null 2>&1

# Language
    msg  "Set language to en_US.UTF-8"
        sudo locale-gen en_US.UTF-8 > /dev/null 2>&1

# Environment
    msg  "Set APPLICATION_ENV to development"
        sudo sed -i -e '1iAPPLICATION_ENV='development'\' /etc/environment > /dev/null 2>&1

# Editor
    msg  "SET EDITOR to vi"
        sudo sed -i -e '1iEDITOR='vi'\' /etc/environment > /dev/null 2>&1

# Bashrc
    msg  "Set profile AND .bashrc FILES"
        sudo cp /vagrant/provision/files/profile/profile /etc/.
        sudo cp /vagrant/provision/files/profile/bash.bashrc /home/vagrant/.bashrc

# To speed things up, anything that requires an apt-get update is done here
    msg  "Preping Packages that require an apt-get update"
        msg  "    Import they key for the official MongoDB repository"
        # MongoDB is already included in Ubuntu package repositories,
        # but the official MongoDB repository provides most up-to-date version and is the recommended way of installing the software.
        # Ubuntu ensures the authenticity of software packages by verifying that they are signed with GPG keys,
        # so we first have to import they key for the official MongoDB repository.
        sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 > /dev/null 2>&1

        msg  "    Create an APT list file for MongoDB"
        # We have to add the MongoDB repository details so APT will know where to download the packages from
        echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list > /dev/null 2>&1

        msg  "    Create an APT list file for postgresql"
        sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list' > /dev/null 2>&1
        sudo wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add - > /dev/null 2>&1

# Updating all the packages
        msg  "    Updating packages"
        sudo apt-get update -y > /dev/null 2>&1

# Utilities
    msg  "Installing Utilities"
        msg  "    Installing tree"
        sudo apt-get install tree -y > /dev/null 2>&1

        msg  "    Installing curl"
        sudo apt-get install curl -y > /dev/null 2>&1

        msg  "    Installing git"
        sudo apt-get install git -y > /dev/null 2>&1

        msg  "    Installing htop"
        sudo apt-get install htop -y > /dev/null 2>&1

        # Used by composer
        msg  "    Installing unzip"
        sudo apt-get install unzip -y > /dev/null 2>&1

        msg  "    Installing python-software-properties"
        sudo apt-get install python-software-properties -y > /dev/null 2>&1

        msg  "    Installing python"
        sudo apt-get install python -y > /dev/null 2>&1

        msg  "    Installing g++"
        sudo apt-get install g++ -y > /dev/null 2>&1

        msg  "    Installing make"
        sudo apt-get install make -y > /dev/null 2>&1

        msg  "    Installing build-essential"
        sudo apt-get install build-essential -y > /dev/null 2>&1

# NodeJs
    msg  "Installing NodeJs"
        curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - > /dev/null 2>&1
        sudo apt-get install nodejs -y > /dev/null 2>&1

# MongoDb
    msg  "Installing MongoDb"
        sudo apt-get install mongodb-org -y > /dev/null 2>&1

        #  comment out the bind_ip line from /etc/mongod.conf to listen to all interfaces
        sudo cp /vagrant/provision/files/mongodb/mongod.conf /etc/mongod.conf

        # Restart Service to reflect the new config file
        sudo service mongod restart > /dev/null 2>&1

# postgresql
    msg  "    Installing postgresql"
        sudo apt-get install -y postgresql-client-9.5 postgresql-common postgresql-9.5 postgresql-server-dev-9.5 postgresql-contrib > /dev/null 2>&1

            msg  "        Set custom postgresql.conf file"
            # Make require enhancements to listen to all ports
            # Changed listen_addresses to "*"
            sudo cp /vagrant/provision/files/postgresql/postgresql.conf /etc/postgresql/9.5/main/postgresql.conf

            msg  "        Set custom pg_hba.conf file"
            # Make require enhancements to connect to postgresql from the host machine
            # Create a new row with the following 5 columns: host all all all password
            sudo cp /vagrant/provision/files/postgresql/pg_hba.conf /etc/postgresql/9.5/main/pg_hba.conf

            msg  "        Set up pgdbhost"
            echo "10.0.0.3 pgdbhost" | sudo tee -a /etc/hosts > /dev/null 2>&1

            msg  "        Set password for user postgres"
            sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres';"

            msg  "        Restarting postgresql"
            sudo service postgresql restart > /dev/null

            msg  "        Create db mydb"
            createdb -h pgdbhost -U postgres -O postgres mydb

            msg  "        Grant all privileges to admin user on mydb"
            sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE mydb to postgres;"

# Npm
    msg  "Installing npm modules"
        cd /vagrant/
        npm install > /dev/null 2>&1

# Azure Cli
    msg  "Installing azure-cli globally"
    sudo npm install -g azure-cli


# Check if Services are running, and proper files exist
    msg  "Sanity Check"
        msg  "  Check Services"
        checkIfProcessIsRunning "mongod"
        checkIfProcessIsRunning "postgresql"

        msg  "  Check Directories"
        msg  "      node_modules"
        checkIfDirectoryExists "/vagrant/node_modules"

        msg  "      NodeJs Version"
        nodejs -v

        msg  "      Npm version"
        npm -v


msg "--------------------------------------------------"
msg "Your vagrant instance is running at: 10.0.0.3"





