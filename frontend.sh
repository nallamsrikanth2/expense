#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $? -ne 0 ]
    then
        echo "$2 ... failure"
        exit 1
    else
        echo "$2 ... success"
    fi
}

if [ $USERID -ne 0 ]
then
    echo "please run the inside the root user"
    exit 1
else
    echo "you are root user"
fi

dnf install nginx -y  &>>$LOGFILE
VALIDATE $? "install nginx"

systemctl enable nginx  &>>$LOGFILE
VALIDATE $? "enable nginx"

systemctl start nginx   &>>$LOGFILE
VALIDATE $? "start nginx"

rm -rf /usr/share/nginx/html/*  &>>$LOGFILE
VALIDATE $? "remove in the html file"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip  &>>$LOGFILE
VALIDATE $? "download the code"


cd /usr/share/nginx/html    &>>$LOGFILE
VALIDATE $? "move to file"

unzip /tmp/frontend.zip    &>>$LOGFILE
VALIDATE $? "unzip the code"

cp /home/ec2-user/expense/expense.conf  /etc/nginx/default.d/expense.conf   &>>$LOGFILE
VALIDATE $? "copy the code"

systemctl restart nginx    &>>LOGFILE
VALIDATE $? "restart nginx"
