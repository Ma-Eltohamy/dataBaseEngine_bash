function dropTable() {
    dataBaseName=$1

    echo "Enter the table name to drop:"
    read tableName

    if isEmpty "$tableName"
    then
        echo "[Error] Database name cannot be empty."
        echo "Tip: A valid table name should contain at least one character."
        return
    fi

    if isStartWithChars "$tableName"
    then
        echo "[Error] table name cannot start with a number or specail character."
        echo "Tip: Use alphabetic characters or underscores (_) at the beginning."
        return
    fi

    if ! isAlreadyExists -t "$dataBaseName" "$tableName"
    then
        echo "[Error] Table '$tableName' does not exist."
        return
    fi

    dataFile="$HOME/DBMS/$dataBaseName/$tableName.data"
    metaFile="$HOME/DBMS/$dataBaseName/$tableName.meta"


    echo "Dropping table '$tableName'..."
    # Confirm the action before proceeding
    echo "Are you sure you want to permanently delete the database '$tableName'? (y/n): "
    read confirmation
    if [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]
    then
        rm "$HOME/DBMS/$dataBaseName/$tableName.data"
        rm "$HOME/DBMS/$dataBaseName/$tableName.meta"
        echo "table '$tableName' has been successfully deleted."
    else
        echo "Action canceled. table '$tableName' was not deleted."
    fi
}
