#!/bin/ksh
if [ "$#" -eq 1 ]; then
 #Initialize the variables
		export deploy_srv=$1
                export deploy_server=root@$deploy_srv
                export BRel_dir=/usr/local/project/release_v$BNumner
                export BDow_dir=/usr/local/download
                export Dapp_Dir=/usr/local/myApp
                export Bkp_dir=/usr/local/backup

echo "Press 1 for deployment"
echo "Press 2 for Rollback.."
read num
case $num in
	1)
		echo "deployment"
		#Create a count file for Build Number

		echo $(date) >> count.file
		export BNumner=$(wc -l count.file | awk '{print $1}')
		export BRel_dir=/usr/local/project/release_v$BNumner
		export Bak_number=`expr $BNumner - 1`

		#Create the Release directory on build Server
	        mkdir -p $BRel_dir

		#Create the download directory on build server
	   	mkdir -p $BDow_dir
	        echo ${PWD}

		#Copy the files into release directory
	        cp ${PWD}/src/* $BRel_dir
	        cd $BRel_dir
		#Create the tar.gz file and copy in into deownload directory
		tar czf $BDow_dir/sample_v$BNumner.tar.gz *.txt

		#Create a backup directory

		mkdir -p $Bkp_dir
		cd $Bkp_dir

		#Take the backup of application from build server
		ssh $deploy_server "tar -cf - $Dapp_Dir" |gzip >> sample_v$Bak_number.tar.gz

		#Connect to Deployment server and clean the application directory
		sftp ${deploy_server} <<EOF
		rm ${Dapp_Dir}/*
EOF
		cd $BDow_dir

		#transfer and extract the application into myApp directory

		cat sample_v$BNumner.tar.gz | ssh $deploy_server "tar xzf - -C ${Dapp_Dir}/"
		echo "Deployment is completed, please check the application console"
		echo "Thank you !!"
	;;
	2)
		export BNumner=`expr $(wc -l count.file | awk '{print $1}') - 1`
		echo "$BNumner"
		echo "rolling back to previous build.."

		cd $Bkp_dir
		#Connect to Deployment server and clean the application directory
		echo "cleaning the application directory"
		sftp ${deploy_server} <<EOF
		rm ${Dapp_Dir}/*
EOF
		#Restore the backup
		echo "Restoring the backup from sample_v$BNumner.tar.gz file.."
		cat sample_v$BNumner.tar.gz | ssh $deploy_server "tar xzf - -C /"
                echo "Rollback is completed, please check the application console"
                echo "Thank you !!"
	;;
	*)
		echo "Please enter the correct number !!"
	;;
esac
else
  echo "Number of entered arguments are not equal to 1"
fi
