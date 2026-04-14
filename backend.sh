#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$( echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


VALIDATE(){
    if [ $? -ne 0 ]
    then
        echo -e "$?  ... $R failure $N"
        exit 1
    else
        echo -e "$?   ... $G Sucess $N"
    fi

}
if [ $USERID -ne 0 ]
then
    echo -e " $R please run the inside the root user $N"
    exit 1
else
    echo -e " $G you are root user $N"
fi

echo -e " $G Enter the username $N"
read -s SQLROOTPASSWORD

dnf module disable nodejs -y
VALIDATE $? "disable nodejs"

dnf module enable nodejs:20 -y
VALIDATE $? "enable nodejs"

dnf install nodejs -y
VALIDATE $? "install nodejs"

id expense
if [ $? -ne 0 ]
then
    useradd expense
    VALIDATE $? "create user"
else
    echo -e "user already created .... $Y Skipping $N"
fi

mkdir -p /app
VALIDATE $? "create the app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
VALIDATE $? "download the backend code"

cd /app
VALIDATE $? "move to app directory"

rm -rf /app/*
VALIDATE $? "remove the files in app directory"

unzip /tmp/backend.zip
VALIDATE $? "unzip the backend code"

cd /app

npm install
VALIDATE $? "install the libries and dependies"

cp /home/ec2-user/expense/backend.service   /etc/systemd/system/backend.service

systemctl daemon-reload
VALIDATE $? "realod the code"

systemctl start backend
VALIDATE $? "start the backend"

systemctl enable backend
VALIDATE $? "enable the code"

dnf install mysql -y
VALIDATE $? "install mysql"

mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -p{$SQLROOTPASSWORD} < /app/schema/backend.sql
VALIDATE $? "load the mysql schema"

systemctl restart backend
VALIDATE $? "restart backend server"




