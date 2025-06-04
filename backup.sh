R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

User=$(id -u)
SOURCE_DIR=$1
DESTI_DIR=$2
DAYS=${3:-14}

SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGS_FOLDER="/var/log/app-logs"
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"
SCRIPT_NAME=$PWD

check_root(){

    if [ $User -eq 0 ]
    then
        echo "You are running with root access"
    else
        echo "ERROR :: Please run the script with root access"
        exit 1
    fi
}

VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e "$2 is ... $G SUCCESS $N" | tee -a $LOG_FILE
    else
        echo -e "$2 is ... $R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    fi
}

check_root
mkdir -p $LOGS_FOLDER

USAGE(){

	echo  -e " $R USAGE: : $N  sh.backup sh <Source directory> <Destination directory> <days>"
}

if [ $# -lt 2 ]
then
    USAGE
fi

if [ ! -d $SOURCE_DIR ]
then 
	echo "$R Source directory $SOURCE_DIR doesn't exist $N"
fi

if [ ! -d $DESTI_DIR]
then 
	echo "$R destination directory $DESTI_DIR doesn't exist $N"
fi

FILES_TO_DELETE=$(find $SOURCE_DIR -name "*.log" -mtime +$DAYS)

if [ ! -z $FILES_TO_DELETE ]
then 
	echo "Files to zip are : $FILES_TO_DELETE"
	Timestamp=$(date +%F-%H-%M-%S)
	Zip_file= "$DESTI_DIR/app-logs-$timestamp.zip"
	echo $FILES_TO_DELETE  | zip -@ $Zip_file
	
	if [ -f $Zip_file ]
	then
		echo -e "successfully created Zip file"
        while IFS= read -r filepath
        do
            echo "deleting file: $filepath "
            rm -rf $filepath
        done <<< $FILES_TO_DELETE  

        echo -e "log files older than $DAYS are deleted from $SOURCE_DIR "
	else
		echo -e "zip file creation…. $R Failure $N"
        exit 1
	fi
else
	echo -e "Files not found older than 14 days ....$Y SKIPPING $N"
fi


