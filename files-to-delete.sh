#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G=="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-script-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SOURCE_DIR=/home/ec2-user/app-logs

mkdir -p $LOGS_FOLDER

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

echo -e "Script started executing at $(date)" | tee -a $LOG_FILE

FILES_TO_DELETE=$(find $SOURCE_DIR -name "*.log" -mtime +14)

while IFS= read -r filepath
do
    echo -e "Deleting file : $filepath" | tee -a $LOG_FILE
    rm -rf $filepath

done <<< $FILES_TO_DELETE


echo  "Script executed successfully"




