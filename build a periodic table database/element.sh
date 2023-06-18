#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
elif [[ $1 =~ ^[0-9]+$ ]]
then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1;")
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    MAIN_SELECT=$($PSQL "SELECT name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER;")
    echo "$MAIN_SELECT" | while IFS="|" read NAME SYMBOL TYPE ATOMIC_MASS MPC BPC 
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
    done
  fi
elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
then
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$1';")
  if [[ -z $SYMBOL ]]
  then
    echo "I could not find that element in the database."
  else
    MAIN_SELECT=$($PSQL "SELECT atomic_number, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$SYMBOL';")
    echo "$MAIN_SELECT" | while IFS="|" read ATOMIC_NUMBER NAME TYPE ATOMIC_MASS MPC BPC 
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
    done
  fi
elif [[ $1 =~ ^[A-Z][a-z]+$ ]]
then
  NAME=$($PSQL "SELECT name FROM elements WHERE name = '$1';")
  if [[ -z $NAME ]]
  then
    echo "I could not find that element in the database."
  else
    MAIN_SELECT=$($PSQL "SELECT atomic_number, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name = '$NAME';")
    echo "$MAIN_SELECT" | while IFS="|" read ATOMIC_NUMBER SYMBOL TYPE ATOMIC_MASS MPC BPC 
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
    done
  fi
else
  echo "I could not find that element in the database."
fi
