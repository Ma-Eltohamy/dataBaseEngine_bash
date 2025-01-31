function dropDataBase() {
    local dataBaseDir="$HOME/DBMS"

    # Check if there are any databases in the directory
    if [ -z "$(ls -1 "$dataBaseDir")" ]; then
        echo "No databases found. Cannot drop a database."
        return
    fi

    echo "Enter the name of the database you want to drop:"
    read dataBaseName

    if isEmpty "$dataBaseName"
    then
        echo "[Error] Database name cannot be empty."
        echo "Tip: A valid database name should contain at least one character."
        return
    fi

    if isStartWithChars "$dataBaseName"
    then
        echo "[Error] Database name cannot start with a number or special character."
        echo "Tip: Use alphabetic characters or underscores (_) at the beginning."
        return
    fi

    if ! isAlreadyExists -d "$dataBaseName"
    then
        echo "Error: Database '$dataBaseName' does not exist."
        return
    fi

    echo "Dropping database '$dataBaseName'..."
    # Confirm the action before proceeding
    echo "Are you sure you want to permanently delete the database '$dataBaseName'? (y/n): "
    read confirmation
    if [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]
    then
        rm -rf "$dataBaseDir/$dataBaseName"  # Remove the entire database directory and its contents
        echo "Database '$dataBaseName' has been successfully deleted."
    else
        echo "Action canceled. Database '$dataBaseName' was not deleted."
    fi
}
