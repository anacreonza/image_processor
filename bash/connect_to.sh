# Mount specified volume.
# ./mount_volume.sh 'smb://02-sa-magadmin:Tyd$krifte@02auc-lab01/Utils'

if [ "$1" == '' ] ; then
	echo "Server Mount Utility"
	echo "Usage: Specify the URL of the server you wish to mount. IE smb://myserver/myfolder"
	exit 0
fi

servername="$1"

echo "Mounting server $1"
printf "Enter username: "
read username
printf "Enter password: "
read -s password

printf "\n\n"
protocol="smb://"
serverurl=${username}":"${password}"@"${servername}
serverurl=${serverurl/$protocol/}
url=$protocol$serverurl

./mount_volume.sh "$url"