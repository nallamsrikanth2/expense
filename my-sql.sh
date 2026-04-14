#!/bin/bash

source ./common.sh
CHECK_ROOT

echo -e "ENTER THE USERNAME"
read -s SQLROOTPASSWORD


dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "installing mysql"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "enable mysqld" 

systemctl start mysqld    &>>$LOGFILE
VALIDATE $? "start mysqld"

mysql -h db.nsrikanth.online -uroot -p"${SQLROOTPASSWORD}" -e 'show databases;' &>>LOGFILE
if [ $? -eq 0 ]
then
    echo -e "root password already setup.....$Y Skipping $N"
else
    mysql_secure_installation --set-root-pass "${SQLROOTPASSWORD}"  &>>$LOGFILE
    VALIDATE $? "setup the root password"
fi

echo -e  " $G MY sql server setup Sucessfully $N"


