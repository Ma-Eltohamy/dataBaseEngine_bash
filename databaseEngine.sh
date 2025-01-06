#!/usr/bin/bash 
shopt -s extglob

function printMenu(){

  local -a menu=("$@") # Here we retrive the entire number of passed arguments
  # and here "$@" is different from $@ 
  # because "" double qoutes here are meant to preserve the entity seperations
  # not as a specail char blocking char
  local -i menuLen=${#menu[@]}


  PS3="Please choose an option: "
  select choice in "${menu[@]}"
  do
    case $REPLY in 
      1) createDataBase
        break ;;
      2) listDataBases
        break ;;
      3) connectToDataBase
        break ;;
      4) dropDataBase
        break ;;
      5) echo "Exiting..."
        exit 0 ;;
      *) echo "Invalid option. Please try again."
        break ;;
    esac
  done
}

function run(){
  source ./modules/createDataBase.sh
  source ./modules/connectToDataBase.sh
  source ./modules/listDataBases.sh
  source ./modules/dropDataBase.sh
  source ./modules/createTable.sh
  source ./modules/listTables.sh
  source ./modules/selectFromTable.sh
  source ./modules/manageDataBase.sh
  source ./modules/insertIntoTable.sh
  source ./modules/updateRowInTable.sh
  source ./modules/deleteFromTable.sh
  source ./modules/dropTable.sh
  source ./modules/validation.sh

  source ./modules/sortData.sh
  source ./modules/selectAllData.sh
  source ./modules/selectByPrimaryKey.sh
  source ./modules/selectSpecificColumns.sh
  source ./modules/selectByCondition.sh

  # first make sure that there's a "$HOME/DBMD" dir
  if ! isAlreadyExists -m 
  then
    mkdir -p "$HOME/DBMS"
  fi

  # local -a just a way of declaration for the array 
  local -a menuElements=(
    "Create Database"
    "List Database"
    "Connect To Database"
    "Drop Database"
    "Exit"
  )
   
  while true
  do
    printMenu "${menuElements[@]}"
  done
}

# Help message (Writen by chatGPT)
function showHelp(){
  echo "Usage: $0 [OPTIONS]"
  echo
  echo "This script provides a menu-driven interface for database operations."
  echo
  echo "Options:"
  echo "  --help          Show this help message."
  echo "  start           Starts and display the menu, and allow user to select an option."
  echo
  echo "Database Operations:"
  echo "  1) Create Database"
  echo "  2) List Database"
  echo "  3) Connect To Database"
  echo "  4) Drop Database"
  echo "  5) Exit"
  echo
  echo "After selecting an option, the appropriate action will be performed."
}

# Handle command-line options
if [ "$1" == "--help" ]
then
  showHelp
  exit 0
elif [ "$1" == "start" ]
then
  figlet "DataBase Engine"
  run
else
  echo "Error: No arguments provided."
  echo "Usage: ./databaseEngine.sh [start|--help]"
  exit 1
fi



