#!/bin/bash

source ./common.sh
CHECK_ROOT

# echo -e " $G Enter the username $N" &>>$LOGFILE
# read -s SQLROOTPASSWORD

dnf module disable nodejs -y  &>>$LOGFILE
VALIDATE $? "disable nodejs"

dnf module enable nodejs:20 -y  &>>$LOGFILE
VALIDATE $? "enable nodejs"

dnf install nodejs -y   &>>$LOGFILE
VALIDATE $? "install nodejs"

id expense
if [ $? -ne 0 ]
then
    useradd expense
    VALIDATE $? "create user"
else
    echo -e "user already created .... $Y Skipping $N"
fi

mkdir -p /app  &>>$LOGFILE
VALIDATE $? "create the app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip   &>>$LOGFILE
VALIDATE $? "download the backend code"

cd /app  &>>$LOGFILE
VALIDATE $? "move to app directory"

rm -rf /app/*  &>>$LOGFILE
VALIDATE $? "remove the files in app directory"

unzip /tmp/backend.zip  &>>$LOGFILE
VALIDATE $? "unzip the backend code"

cd /app  &>>$LOGFILE

npm install  &>>$LOGFILE
VALIDATE $? "install the libries and dependies"

cp /home/ec2-user/expense/backend.service   /etc/systemd/system/backend.service  &>>$LOGFILE

systemctl daemon-reload   &>>$LOGFILE
VALIDATE $? "realod the code"

systemctl start backend   &>>$LOGFILE
VALIDATE $? "start the backend"

systemctl enable backend   &>>$LOGFILE
VALIDATE $? "enable the code"

dnf install mysql -y  &>>$LOGFILE
VALIDATE $? "install mysql"

mysql -h db.nsrikanth.online -uroot -pExpenseApp@1 < /app/schema/backend.sql  &>>$LOGFILE
VALIDATE $? "load the mysql schema"

systemctl restart backend   &>>$LOGFILE
VALIDATE $? "restart backend server"




