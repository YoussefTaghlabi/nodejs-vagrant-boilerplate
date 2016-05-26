NodeJs & Vagrant Boilerplate
============================

What you get
-------------

* NodeJs    6.0.2
* Npm       3.8.9
* MongoDb   3.0.12
* PostGresql   9.5

Please note that both MongoDb and postGresql are installed. It's up to the engineer to choose what to run.

Requirements
------------

* [Vagrant](https://www.vagrantup.com/downloads.html)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [RoboMongo](https://robomongo.org/download)
* [PGAdmin](https://www.pgadmin.org/download/macosx.php)

Installation
-------------

* ```vagrant up```

Post-Installation
-----------------

* ```vagrant ssh```
* ```node server.js```

Your node instance should be running onr port 3000: http://10.0.0.3:3000

RoboMongo
-----------------

Once RoboMongo is downloaded, you can connect to your mongodb instance via host 10.0.0.3, port 27017

![alt tag](https://raw.githubusercontent.com/YoussefTaghlabi/nodejs-vagrant-boilerplate/master/screenShots/mongod.png)

PGAdmin
-----------------

Once PGAdmin is downloaded, you can connect to your PostGresql instance via:
* host 10.0.0.3
* port 5432
* username postgres
* pwd postgres

![alt tag](https://raw.githubusercontent.com/YoussefTaghlabi/nodejs-vagrant-boilerplate/master/screenShots/postgresql.png)





