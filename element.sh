#/bin/bash 
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
echo Please provide an element as an argument.

else

 #check if it is a number
 if [[ $1 =~ ^[0-9]+$ ]]

 #if it is a number
 then
 #check if it is an atomic number existing in the db
 #if not
  if [[ -z $($PSQL "SELECT name FROM elements WHERE atomic_number = $1") ]]
  then
  echo I could not find that element in the database.
 #if it exists
  else 
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $1")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $1")
  TYPE=$($PSQL "SELECT type FROM types JOIN properties USING(type_id) WHERE atomic_number = $1")
  MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $1")
  MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $1")
  BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $1")
  echo The element with atomic number $1 is $NAME "("$SYMBOL")". It"'"s a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius.
  fi

#if it isn't a number
 else

 #check if is a symbol
 ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
  if [[ -z $ATOMIC_NUMBER ]]
  then 
  #check if it is a name
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")
   if [[ -z $ATOMIC_NUMBER ]]
   then
   echo I could not find that element in the database.
   else
   SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name = '$1'")
   TYPE=$($PSQL "SELECT type FROM types JOIN properties USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER")
   MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
   MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
   BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
   echo The element with atomic number $ATOMIC_NUMBER is $1 "("$SYMBOL")". It"'"s a $TYPE, with a mass of $MASS amu. $1 has a melting point of $MELTING celsius and a boiling point of $BOILING celsius.
   fi

  #if it is a symbol
  else
  NAME=$($PSQL "SELECT name FROM elements WHERE symbol = '$1'")
  TYPE=$($PSQL "SELECT type FROM types JOIN properties USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER")
  MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  echo The element with atomic number $ATOMIC_NUMBER is $NAME "("$1")". It"'"s a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius.

  fi
fi
fi