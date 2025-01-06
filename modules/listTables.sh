function listTables() {
    dataBaseName=$1

    if ! isAlreadyExists -d "$dataBaseName"
    then
        echo "[Error] Database '$dataBaseName' does not exist or was not provided."
        return
    fi

    echo "Listing Tables in Database: $dataBaseName"
    echo "---------------------------------"

    # Change to the database directory
    cd "$HOME/DBMS/$dataBaseName" || { echo "[Error] Failed to access the database directory."; return; }

    # Find and list unique table names
    tableList=$(ls -1 *.data *.meta 2>/dev/null | sed -E 's/\.(data|meta)$//' | sort -u)

    if [[ -z "$tableList" ]]; then
        echo "[Info] No tables found in the database."
    else
        echo "$tableList" | nl -w2 -s'. ' # Numbered list with formatted output
    fi

    echo "---------------------------------"
    # Return to the original directory
    cd - >/dev/null
}
