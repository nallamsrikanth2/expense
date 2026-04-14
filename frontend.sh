#!/bin/bash

source ./common.sh
CHECK_ROOT

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
