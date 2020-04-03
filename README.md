# NTT



NTT/
├── count.file  ===> This is the count file for Build number
├── deployAndRollback.sh  ==> this is the deployment and Rollback script
├── deployAndRollback.sh_org
├── README.md
└── src  ==> Source code directory
    ├── abc.php
    └── sample.txt

Purpose:
deployAndRollback.sh is to deploye the source code into Deployment server.

How It Works.
It will ask  -press 1 for deployment and 2 for rollback

1. Deployment
1.1.Script will take the source code from /src folder and maintain the every release in release_v$BN 
 directory, and it will save the tar.gz file into /usr/local/download
1.2.It will take the backup of application from deployment server and store that backup into /usr/local/backup
 directory in tar.gz format.
1.3.It will clean the application directory on deployment server and will deploy the application into 
deployment server (/usr/local/myApp location).

2. Rollback
2.1 Script will clean the appliction directory on deployment server (/usr/local/myApp location). 
2.2 It will deploy the previous build from backup directory /usr/local/backup.


How to execte the script.

./deployAndRollbak.sh <IP_address of Deployment server>

and follow the prompt.

Thank you !!
