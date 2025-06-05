#!/bin/bash

USERID=$(id -u)
SOURCE_DIR=$1
DESTI_DIR=$2
DAYS=${3:-14}

R="\e[31m"
G=="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-script-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/backup.log"


check_root(){
    if [ $USERID -ne 0 ]
    then 
        echo -e "$R ERROR :: $N Please run the script under root access"|tee -a $LOG_FILE
        exit 1
    else
        echo -e "You are running under root acccess" | tee -a $LOG_FILE
    fi
}

VALIDATE(){
    if [ $1 -eq 0 ]
    then 
        echo -e "$2 is..... $G success $N" | tee -a $LOG_FILE
    else
        echo -e "$2 is..... $R failure $N" | tee -a $LOG_FILE
        exit 1
    fi
}

check_root
mkdir -p $LOGS_FOLDER

USAGE(){
    echo -e "$R USAGE:: $N backup.sh <source-dir> <desti-dir> <days(optionnal)>"
    exit 1
}

echo -e "Script started executing at $(date)" | tee -a $LOG_FILE


if [ $# -lt 2 ]
then
    USAGE
fi

if [ ! -d $SOURCE_DIR ]
then
    echo -e "$R Source directory $SOURCE_DIR doesnot exist . Please check $N"
    exit 1
fi

if [ ! -d $DESTI_DIR ]
then
    echo -e "$R destination directory $DESTI_DIR doesnot exist . Please check $N"
    exit 1
fi

FILES=$(find $SOURCE_DIR -name "*.log" -mtime +$DAYS)

if [ ! -z "$FILES" ]
then
    echo -e "Files to zip are: $FILES"

    TIME_STAMP=$( date +%F-%H-%M-%S )
    ZIP_FILE="$DESTI_DIR/app-logs-$TIME_STAMP.zip"
    find $SOURCE_DIR -name "*.log" -mtime +$DAYS | zip -@ "$ZIP_FILE"

    if [ -f $ZIP_FILE ]
    then
        echo -e "Successfully created zip file"

        while IFS= read -r filepath
        do
            echo -e "deleting file: $filepath" | tee -a $LOG_FILE
            rm -rf $filepath
        done <<< $FILES
        echo -e "Log files older than $DAYS are removed from source directory $SOURCE_DIR....$G SUCCESS $N"
    else
        echo -e "Zip_file Creation.....$R Failure$N"
        exit 1
    fi
else
    echo -e "files older than 14 days are not found $Y SKIPPING $N"
fi
