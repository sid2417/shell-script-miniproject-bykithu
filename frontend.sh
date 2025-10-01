#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

USER=$(id -u)
if [ $USER -eq 0 ]
then 
    echo -e $Y"user already have root access..."$N
else
    echo -e $R"Please provide the root access to the user ...."$N
    exit 3
fi

TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP.log


# echo "Please Enter Your Mysql Password : "
# read -s PASSWORD

echo "Please enter DB password:"
read -s mysql_root_password


VALIDATE(){
    if [ $1 -ne 0 ]
    then    
        echo -e $R "$2 failure..."$N
        exit 3
    else
        echo -e $G "$2 success..."$N
    fi
}




dnf install nginx -y &>>$LOGFILE
VALIDATE $? "Installing nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "Enabling nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE $? "Removing existing content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloading frontend code"

cd /usr/share/nginx/html &>>$LOGFILE
unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATE $? "Extracting frontend code"


# /home/ec2-user/shell-script-miniproject-bykithu/backend.service
#check your repo and path
cp /home/ec2-user/shell-script-miniproject-bykithu/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE
VALIDATE $? "Copied expense conf"

systemctl restart nginx &>>$LOGFILE
VALIDATE $? "Restarting nginx"