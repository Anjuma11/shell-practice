#!/bin/bash

USERID=$(id -u)
SOURCE_DIR=$1
DESTI_DIR=$2
DAYS=$(3:-14)

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

USAGE(){
    echo -e "$R USAGE:: $N backup.sh <source-dir> <desti-dir> <days(optionnal)>"
}

echo -e "Script started executing at $(date)" | tee -a $LOG_FILE

FILES_TO_DELETE=$(find $1 -name "*.log" -mtime +$3)

if [ $# -lt 2 ]
then
    USAGE
fi

# if [ ! -d $2 ]
# then
#     echo -e ""
# else

# if [ ! -d $1 ]
# then
#     echo -e ""
# else
# fi