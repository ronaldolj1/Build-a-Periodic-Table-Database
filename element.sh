#!/bin/bash

# FUNCTIONS

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# Get properties values for an element
GET_PROPERTIES(){
  local value_str="$1"
  if [[ $value_str =~ ^[0-9]+$ ]]
  then
    value_int="$1"
  else
    value_int="NULL"
  fi
  local query="SELECT atomic_number, symbol, name, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius
               FROM elements
               LEFT JOIN properties USING(atomic_number)
               LEFT JOIN types USING(type_id)
               WHERE symbol='$value_str' OR atomic_number=$value_int OR name='$value_str'
               "
  $PSQL "$query"
}


# MAIN


# Getting the argument value
ELEMENT_VALUE="$1"


# If argument is empty
if [[ -z $ELEMENT_VALUE ]]
then
  echo "Please provide an element as an argument."
  exit 0  # exit program
fi


# If argument is not empty, get properties of element
PROPERTIES="$(GET_PROPERTIES "$ELEMENT_VALUE")"


# If there is no entry in the database
if [[ -z $PROPERTIES ]]
then
  echo "I could not find that element in the database."
  exit 0  # exit program
fi


# If there is entry in the database
echo $PROPERTIES | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT 
do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done

