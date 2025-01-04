
function connectToDataBase() {
    echo "Enter the name of the database you want to connect to:"
    read -r dataBaseName

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

    # Check if the directory exists
    if ! isAlreadyExists -d "$dataBaseName"
    then
        echo "Error: Database '$dataBaseName' does not exist."
        return
    fi

    echo "Connecting to database '$dataBaseName'..."
    cd "$HOME/DBMS/$dataBaseName"
    echo "Successfully connected to '$dataBaseName'."

    manageDataBase "$dataBaseName"
}
