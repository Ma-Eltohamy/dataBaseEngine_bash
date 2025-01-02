function createDataBase(){
  echo "Enter the database name: "
  read dataBaseName

  if isEmpty "$dataBaseName"
  then
    echo "[Error] Database name cannot be empty."
    echo "Tip: A valid database name should contain at least one character."
    return
  fi

  if isStartWithChars "$dataBaseName"
  then
    echo "[Error] Database name cannot start with a number or specail character."
    echo "Tip: Use alphabetic characters or underscores (_) at the beginning."
    return
  fi

  if isAlreadyExists -d "$dataBaseName"
  then
    echo "[Warning] The database '$dataBaseName' already exists."
    echo "Tip: Use a different name or proceed to modify the existing database."
    return
  fi

  # Create the database
  mkdir -p "$HOME/DBMS/$dataBaseName"
  echo "[Success] Database '$dataBaseName' has been created successfully!"
  return
}
