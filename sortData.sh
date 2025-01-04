function sortData(){
  headersString=$1
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
}
