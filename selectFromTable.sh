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
          echo
          echo "Displaying all data from the table:"
          # Read column headers from metadata
          # Combine headers and data, then format with `column`
          {
            echo "$headersString"
            cat "$dataFile"
          } | column -ts ":"
          echo 
          break ;;
        2) # Select specific columns
          echo
          echo "Displaying all headers:"

          echo "---------------------------------"
          echo "Available columns:"
          # Loop through headersArray and print the column names
          for i in "${!headersArray[@]}"
          do
            echo "$((i+1)). ${headersArray[i]}"
          done
          echo "---------------------------------"

          echo "Enter the column numbers to select (e.g., 1 2):"
          read columns
          
          # Validate the entered columns
          validInput=true

          for column in $columns
          do
            if ! [[ "$column" =~ ^[0-9]+$ ]]; then
              echo "[Error] '$column' is not a valid number."
              validInput=false
              break 1
            elif (( column < 1 || column > maxColumns )); then
              echo "[Error] Column number '$column' is out of range (1-$maxColumns)."
              validInput=false
              break 1
            fi
          done

          # Build the awkCommand and selectedHeaders
          awkCommand=""
          selectedHeaders=""
          for column in $columns
          do
            # Convert column (1-based index) to 0-based index for Bash array
            headerIndex=$((column - 1))

            # Access header from the array
            header=${headersArray[$headerIndex]}

            if [ -z "$awkCommand" ]; then
              awkCommand="\$$column"
              selectedHeaders="$header"
            else
              awkCommand="$awkCommand \":\" \$$column"
              selectedHeaders="$selectedHeaders:$header"
            fi
          done

          # Print the selected headers and data
          # Use single quotes for the awk command and expand variables properly
          (echo "$selectedHeaders"; awk -F ":" "{print $awkCommand}" "$dataFile") | column -t -s ":"
          break ;;
        3) # Select by primary key
            echo
            echo "Enter the value of the primary key ($primaryKey):"
            read pkValue

          if [ -z "$pkValue" ]
          then
            echo "[Error] Primary key value cannot be empty."
            break
          fi

          if [ -z "$result" ]
          then
            echo "[Error] No rows found with the primary key value: $pkValue"
          else
            {
              echo "$headersString"
              echo "$result"
            } | column -ts ":"
          fi

          break ;;

        4) # Select by condition
          echo
          echo "Displaying all available columns:"
          echo "---------------------------------"
          for i in "${!headersArray[@]}"
          do
            echo "$((i+1)). ${headersArray[i]}"
          done
          echo "---------------------------------"

          echo "Enter the column number to filter by (e.g., 1 for ${headersArray[0]}):"
          read columnNumber

          if ! [[ "$columnNumber" =~ ^[0-9]+$ ]] || (( columnNumber < 1 || columnNumber > maxColumns ))
          then
            echo "[Error] Invalid column number. Please choose a valid column number."
            break
          fi

          # Get the column name
          columnName=${headersArray[$((columnNumber - 1))]}

          echo "Enter a comparison operator (e.g., ==, !=, >, <, >=, <=):"
          read operator

          echo "Enter the value to compare (e.g., Manager, 5000):"
          read value

          # Escape the value for safety
          escapedValue=$(echo "$value" | sed 's/["]/\\"/g')

          # Construct the awk condition
          condition="\$$columnNumber $operator \"$escapedValue\""

          # Find and display rows that match the condition
          result=$(awk -F ":" "$condition" "$dataFile")

          if [ -z "$result" ]
          then
            echo "[Error] No rows found where $columnName $operator $value."
          else
            {
              echo "$headersString"
              echo "$result"
            } | column -ts ":"
          fi

          break ;;

        5) # Sort data
          echo
          echo "Enter the column number to sort by:"
          read column
          echo

          # Check if the column variable is empty
          if [[ -z "$column" ]]
          then
            echo "[Error] Column number cannot be empty."
            break
          fi

          # Check if the column is a valid number
          if ! [[ "$column" =~ ^[0-9]+$ ]]
          then
            echo "[Error] Column number must be a valid number."
            break
          fi

          # Perform the sort operation
        {
          echo "$headersString"
          sort -t":" -k"$column" "$tableName.data"
        } | column -ts ":"
          echo 
          break ;;

        6) # Exit
          echo "Exiting selection menu."
          return ;;
        *) echo "Invalid choice! Please select a valid option."; ;;
      esac
    done
done
}

