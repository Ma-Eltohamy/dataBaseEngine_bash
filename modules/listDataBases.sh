function listDataBases(){
  local dataBaseDir="$HOME/DBMS"

  # Check if the directory exists
  if isAlreadyExists -m
  then
      echo "Listing databases in $dataBaseDir:"
      echo "---------------------------------"
      
      # Check if the directory is empty
      if [ -z "$(ls -1 "$dataBaseDir")" ]; then
          echo "No databases found."
      else
          ls -1 "$dataBaseDir" | sort
      fi
      
      echo "---------------------------------"
  else
      echo "Error: Directory '$dataBaseDir' does not exist."
  fi
}
