function selectByCondition(){
  headersArray=$1

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

}
