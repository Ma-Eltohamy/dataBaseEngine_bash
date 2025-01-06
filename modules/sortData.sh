function sortData(){
  headersString=$1
  echo
  echo "Enter the column number to filter by (from 1 to ${#headersArray[@]}):"
  read columnNumber

  if [[ -z "$columnNumber" ]]
  then
    echo "[Error] Column number cannot be empty."
    return
  fi

  if ! [[ "$columnNumber" =~ ^[0-9]+$ ]] || (( columnNumber < 1 || columnNumber > maxColumns ))
  then
    echo "[Error] Invalid column number. Please choose a valid column number."
    return
  fi

  lineNumber=$((3 + $columnNumber))
  colDataType=$(sed -n "${lineNumber}p" "$metaFile" | cut -d "(" -f2 | cut -d ")" -f 1)

  if [[ "$colDataType" == "INT" || "$colDataType" == "FLOAT" ]]
  then 
    {
      echo "$headersString"
      sort -t":" -n -k"$columnNumber" "$tableName.data"
    } | column -ts ":"
    echo 
    return
  fi
  {
    echo "$headersString"
    sort -t":" -k"$columnNumber" "$tableName.data"
  } | column -ts ":"
  echo 
}
