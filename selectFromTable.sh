function selectFromTable() {
  menuItems=("Select all data" "Select specific columns" "Sort data" "Exit")

  echo "Enter the table name to select data from:"
  read tableName

  dataFile="$tableName.data"
  metaFile="$tableName.meta"

  if [[ ! -f "$dataFile" || ! -f "$metaFile" ]]
  then
      echo "[Error] Table '$tableName' does not exist."
      return
  fi

  # Get the primary key (from the 3rd line in the metadata file)
  primaryKey=$(sed -n '3p' "$metaFile" | xargs)
  echo "The primary key is: $primaryKey"

  headers=$(sed -n '4,$p' "$metaFile" | cut -d '(' -f1 | paste -sd ':')

  while true
  do
    
    PS3="Please select an option to retrieve data from the table '$tableName'": 
    select choice in "${menuItems[@]}"
    do
      case $REPLY in

        1) # Select all data
          echo
          echo "Displaying all data from the table:"
          # Read column headers from metadata
          # Combine headers and data, then format with `column`
          {
            echo "$headers"
            cat "$dataFile"
          } | column -ts ":"
          echo 
          break ;;
        2) # Select specific columns
          echo
          echo "Enter the column numbers to select (e.g., 1 2):"
          read columns
          awkCommand=""
          for col in "${columns[@]}"
          do
            awkCommand="$awkCommand \$$col"
          done
          awk "{print $awkCommand}" "$tableName.data"
          break ;;
        3) # Sort data
          echo
          echo "Enter the column number to sort by:"
          read column
          echo

          # Check if the column variable is empty
          if [[ -z "$column" ]]; then
            echo "[Error] Column number cannot be empty."
            break
          fi

          # Check if the column is a valid number
          if ! [[ "$column" =~ ^[0-9]+$ ]]; then
            echo "[Error] Column number must be a valid number."
            break
          fi

          # Perform the sort operation
        {
          echo "$headers"
          sort -t":" -k"$column" "$tableName.data"
        } | column -ts ":"
          echo 
          break ;;
        4) # Exit
          echo "Exiting selection menu."
          return ;;
        *) echo "Invalid choice! Please select a valid option."; ;;
      esac
    done
done
}

