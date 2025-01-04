function selectSpecificColumns(){
  headersArray=$1
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
}
