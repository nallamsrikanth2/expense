#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="/e[31m"
G="/e[32m"
Y="/e[33m"
N="e[om"

VALIDATE(){
    if [ $? -ne 0 ]
    then
        echo -e "$2 .... $R Failue $N"
        exit 1
    else
        echo -e "$2 ..... $G Sucuess $N"
    fi
}

if [ $USERID -ne 0 ]
then
    echo -e "$R please run the inside root user $N"
    exit 1
else
    echo -e "$G you are root user $N"
fi

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "installing mysql"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "enable mysqld" 

systemctl start mysqld    &>>$LOGFILE
VALIDATE $? "start mysqld"

mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pExpenseApp@1 -e 'show databases;' &>>LOGFILE
if [ $? eq 0 ]
then
    echo -e "root password already setup.....$Y Skipping $N"
else
    mysql_secure_installation --set-root-pass ExpenseApp@1  &>>$LOGFILE
    VALIDATE $? "setup the root password"
fi

echo -e  " $G MY sql server setup Sucessfully $N"


