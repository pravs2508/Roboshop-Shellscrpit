#!/bin/bash
ID=(id -u)
TIMESTAMP=$(date +%F-%H-%M-%s)
R="\e[31m"
G="\e[32m"
N="\e[0m"
LOGFILE="/tmp/$0-$TIMESTAMP.log"
VALIDATE(){
    if [ $? -ne 0 ]
then 
   echo  - e "ERROR:: $2 ... $R failed $N"
   exit 1
else 
  echo -e "$2 ... $G success $N"
fi
} 

if [ $ID -ne 0 ]
then
  echo -e "$R ERROR:: please run this script with root access $N"
  exit 1
else  
  echo "you are root user"
fi 

cp /home/ec2-user/Roboshop-Shellscript/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "Copied MongoDB Repo"

yum install mongodb-org -y &>> $LOGFILE

VALIDATE $? "Installing MongoDB"

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "Enabling MongoDB"

systemctl start mongod &>> $LOGFILE

VALIDATE $? "Starting MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "Remote access to MongoDB"

systemctl restart mongod &>> $LOGFILE

VALIDATE $? "Restarting MongoDB"
