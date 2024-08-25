#!/bin/bash

# Declare PSQL variable for querying the database
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --tuples-only -c"

# Check if no argument is given
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# Check if integer (atomic_number) was given as argument 
if [[ $1 =~ ^[0-9]+$ ]]
then
  elements=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where atomic_number = '$1'")
# String was given
else
  elements=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE name='$1' or symbol='$1'")
fi

# If argument is not valid
if [[ -z $elements ]]
then
  echo "I could not find that element in the database."
  exit
fi

# Outputing to console fetched data
echo $elements | while IFS=" |" read an name symbol type mass mp bp 
do
  echo "The element with atomic number $an is $name ($symbol). It's a $type, with a mass of $mass amu. $name has a melting point of $mp celsius and a boiling point of $bp celsius."
done