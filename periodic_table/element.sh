#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c "

# ./element.sh
# ./element.sh 1
# ./element.sh H
# ./element.sh Hydrogen
# ./element.sh 100

INPUT=$1
SEARCH_INPUT() {
  if [[ $INPUT =~ ^[0-9]+$ ]]; then
    HAVE_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $INPUT")
    ATOMIC_NUMBER=$(echo $HAVE_ATOMIC_NUMBER | tr -d ' ') #Trims Variable
  elif [[ $INPUT =~ ^[A-Z]$ || $INPUT =~ ^[A-Z][a-z]$ ]]; then
    HAVE_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$INPUT'")
    TEMP_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$INPUT'")
    ATOMIC_NUMBER=$(echo $TEMP_ATOMIC_NUMBER | tr -d ' ') #Trims Variable
  else
    HAVE_NAME=$($PSQL "SELECT name FROM elements WHERE name = '$INPUT'")
    TEMP_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$INPUT'")
    ATOMIC_NUMBER=$(echo $TEMP_ATOMIC_NUMBER | tr -d ' ') #Trims Variable
  fi

  if [[ -z $INPUT ]]; then
    echo "Please provide an element as an argument."
  elif [[ $HAVE_ATOMIC_NUMBER || $HAVE_SYMBOL || $HAVE_NAME ]]; then
    TEMP_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
    NAME=$(echo $TEMP_NAME | tr -d ' ') #Trims Variable
    TEMP_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
    SYMBOL=$(echo $TEMP_SYMBOL | tr -d ' ') #Trims Variable

    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $ATOMIC_NUMBER") 
    TEMP_TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID") 
    TYPE=$(echo $TEMP_TYPE | tr -d ' ') #Trims Variable

    TEMP_ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    ATOMIC_MASS=$(echo $TEMP_ATOMIC_MASS | tr -d ' ') #Trims Variable
    TEMP_MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    MELTING_POINT=$(echo $TEMP_MELTING_POINT | tr -d ' ') #Trims Variable
    TEMP_BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    BOILING_POINT=$(echo $TEMP_BOILING_POINT | tr -d ' ') #Trims Variable
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  else
    echo "I could not find that element in the database."
  fi

  #echo "The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius."
}

SEARCH_INPUT
