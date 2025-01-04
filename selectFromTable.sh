function selectFromTable() {
  dataBaseName=$1

  menuItems=("Select all data" "Select specific columns" "Select by primary key" "Select by condition" "Sort data" "Exit")

  echo "Enter the table name to select data from:"
  read tableName


  if ! isAlreadyExists -t "$dataBaseName" "$tableName"
  then
      echo "[Error] Table '$tableName' does not exist."
      return
  fi

  dataFile="$HOME/DBMS/$dataBaseName/$tableName.data"
  metaFile="$HOME/DBMS/$dataBaseName/$tableName.meta"

  # Get the primary key (from the 3rd line in the metadata file)
  primaryKey=$(sed -n '3p' "$metaFile" | xargs)
  echo "The primary key is: $primaryKey"

  headers=$(sed -n '4,$p' "$metaFile" | cut -d '(' -f1)
  readarray -t headersArray <<< "$headers"
  maxColumns=${#headersArray[@]} # Count the number of headers
  headersString=$(IFS=":"; echo "${headersArray[*]}")

  while true
  do
    
    PS3="Please select an option to retrieve data from the table '$tableName'": 
    select choice in "${menuItems[@]}"
    do
      case $REPLY in

        1) # Select all data
          selectAllData "$dataFile" "$headersString"
          break ;;
        2) # Select specific columns
          selectSpecificColumns "$headersArray"
          break ;;
        3) # Select by primary key
          selectByPrimaryKey "$headersString"
          break ;;

        4) # Select by condition
          selectByCondition "$headersArray"
          break ;;

        5) # Sort data
          sortData "$headersString"
          break ;;

        6) # Exit
          echo "Exiting selection menu."
          return ;;
        *) echo "Invalid choice! Please select a valid option."; ;;
      esac
    done
done
}

