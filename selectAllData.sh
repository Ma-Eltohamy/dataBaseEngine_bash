function selectAllData(){
  dataFile=$1
  headersString=$2

  echo
  echo "Displaying all data from the table:"
  # Read column headers from metadata
  # Combine headers and data, then format with `column`
  {
    echo "$headersString"
    cat "$dataFile"
  } | column -ts ":"
  echo 
}
