function listDataBases(){
  local db_dir="$HOME/DBMS"

  # Check if the directory exists
  if isAlreadyExists -m
  then
      echo "Listing databases in $db_dir:"
      echo "---------------------------------"
      ls -1 "$db_dir" | sort
      echo "---------------------------------"
  else
      echo "Error: Directory '$db_dir' does not exist."
  fi
}
