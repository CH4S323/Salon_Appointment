#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ My Salon ~~~~~\n"

echo -e "\nWelcome to My Salon, How can we help you?"
#get service
SERVICE(){
if [[ $1 ]]
then
  echo -e "\n"$1
fi

Service=$($PSQL "select * from services")
if [[ ! -z $Service ]]
then
  echo "$Service" | while read Id Bar Name
  do
    echo "$Id) $Name"
  done
fi

#get Service Id
read SERVICE_ID_SELECTED
if [[ $SERVICE_ID_SELECTED =~ [1-3] ]]
then
  #get Servive name
  Service_name=$($PSQL "select name from services where service_id = $SERVICE_ID_SELECTED")
  VALID 
else
  #unvalid option select
    SERVICE "Please choose valid option:"
fi
}


VALID(){
  #valid option select
  #get phone number
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
  #get customer name
    CUSTOMER_NAME=$($PSQL "select name from customers where phone = '$CUSTOMER_PHONE'")
    echo $CUSTOMER_NAME
  #if no record
    if [[ -z $CUSTOMER_NAME ]]
    then
    #get name
      echo -e "\nI don't have a record for that phone number, What's your name?"
      read CUSTOMER_NAME
    #insert the new customer
      echo $($PSQL "insert into customers values(default, '$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
      Time_Appointment
    #if have record
    else
      Time_Appointment
    fi

}

Time_Appointment(){
#get time
  echo -e "\nWhat time would you like your$Service_name, $CUSTOMER_NAME?"
  read SERVICE_TIME
#make and insert appointment
  #get customer id
  CUSTOMER_ID=$($PSQL "select customer_id from customers where name = '$CUSTOMER_NAME'")
  echo $($PSQL "insert into appointments values(default, $SERVICE_ID_SELECTED, '$SERVICE_TIME', $CUSTOMER_ID)") >> stderr.txt
  echo -e "\nI have put you down for a$Service_name at $SERVICE_TIME, $CUSTOMER_NAME."
}

SERVICE
  

#show service