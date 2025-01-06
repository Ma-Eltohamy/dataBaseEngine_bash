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

  columnName=${headersArray[$((columnNumber - 1))]}

  avaliableConditions=("==" "!=" ">" "<" ">=" "<=")
  echo "Enter a comparison operator (e.g., ==, !=, >, <, >=, <=):"
  read operator

  isValid=false
  for validOperator in "${avaliableConditions[@]}"; do
      if [[ "$operator" == "$validOperator" ]]; then
          isValid=true
          break
      fi
  done

  if ! $isValid; then
      echo "[Error] Invalid operator. Please enter one of: ${avaliableConditions[*]}"
      return
  fi

  echo "Enter the value to compare (e.g., Manager, 5000):"
  read value

  condition="\$$columnNumber $operator \"$value\""

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
