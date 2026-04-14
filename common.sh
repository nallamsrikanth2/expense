#!/bin/bash

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
        echo -e "$2  ... $R failure $N"
        exit 1
    else
        echo -e "$2   ... $G Sucess $N"
    fi

}

CHECK_ROOT(){
if [ $USERID -ne 0 ]
then
    echo -e " $R please run the inside the root user $N"
    exit 1
else
    echo -e " $G you are root user $N"
fi
}
