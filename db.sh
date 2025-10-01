R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP.log


# echo "Please Enter Your Mysql Password : "

# read -s PASSWORD


USER=$(id -u)
if [ $USER -eq 0 ]
then 
    echo -e $Y"user already have root access..."$N
else
    echo -e $R"Please provide the root access to the user ...."$N
    exit 3
fi


VALIDATE(){
    if [ $1 -ne 0 ]
    then    
        echo -e $R "$2 failure..."$N
        exit 3
    else
        echo -e $G "$2 success..."$N
    fi
}


dnf install mysql-server -y
VALIDATE $? "mysql installation is :: "


systemctl enable mysqld
VALIDATE $? "mysql enabling is :: "


systemctl start mysqld
VALIDATE $? "mysql starting is :: "


mysql_secure_installation --set-root-pass ExpenseApp@1
VALIDATE $? "mysql settingup password is :: "


# mysql_secure_installation --set-root-pass $PASSWORD
# VALIDATE $? "mysql settingup password is :: "

echo -e $G" ************ Mysql installation is going Good ************"$N


