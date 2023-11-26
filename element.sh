#! /bin/bash

if [[ $1 ]]
then
  PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"
  if [[ $1 == ?(-)+([0-9]) ]]
  then 
    ELEMENT=$($PSQL "select * from elements where atomic_number=$1")
  else
    ELEMENT=$($PSQL "select * from elements where symbol='$1' or name='$1'")
  fi
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$ELEMENT" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME
    do
      PROPERTIES=$($PSQL "select atomic_mass, melting_point_celsius, boiling_point_celsius, type from properties inner join types on properties.type_id=types.type_id where properties.atomic_number=$ATOMIC_NUMBER")
      echo "$PROPERTIES" | while read MASS BAR MELTING BAR BOILING BAR TYPE
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
    done
  fi
else
  echo "Please provide an element as an argument."
fi