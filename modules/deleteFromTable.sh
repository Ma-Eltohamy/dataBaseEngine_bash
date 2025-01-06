function deleteFromTable {
    dataBaseName=$1

    echo "Enter the table name to delete from:"
    read tableName

    dataFile="$tableName.data"
    metaFile="$tableName.meta"

    dataFile="$HOME/DBMS/$dataBaseName/$tableName.data"
    metaFile="$HOME/DBMS/$dataBaseName/$tableName.meta"

    if ! isAlreadyExists -t "$dataBaseName" "$tableName"
    then
        echo "[Error] Table '$tableName' does not exist."
        return
    fi

    # Extract column names and types from metadata
    colNames=()
    colTypes=()
    # we can simply do this insted
    # colNum=$(wc -l < "$metaFile")
    for ((i = 4; i <= $(wc -l < "$metaFile"); i++)); do
        line=$(sed -n "${i}p" "$metaFile")
        colName=$(echo "$line" | cut -d "(" -f 1 | sed 's/^ //;s/ $//')
        colType=$(echo "$line" | cut -d "(" -f 2 | cut -d ")" -f 1 | sed 's/^ //;s/ $//')

        colNames+=("$colName")
        colTypes+=("$colType")
    done

    # Display columns for user reference
    echo "Table Columns:"
    for i in "${!colNames[@]}"; do
        echo "$((i + 1)). ${colNames[i]}"
    done
    echo

    echo "Enter the column name to filter rows for deletion:"
    read colName

    # Find the index of the column (0-based)
    colIndex=-1
    for i in "${!colNames[@]}"; do
        if [[ "${colNames[i]}" == "$colName" ]]; then
            colIndex=$i
            break
        fi
    done

    # Validate column existence
    if [[ $colIndex -eq -1 ]]; then
        echo "[Error] Column '$colName' does not exist in table '$tableName'."
        return
    fi

    echo "Enter the value to match in column '$colName':"
    read matchValue

    # Preview matching rows before deletion
    matchingRows=$(awk -F ":" -v col="$colIndex" -v val="$matchValue" '$(col + 1) == val' "$dataFile")
    if [[ -z "$matchingRows" ]]; then
        echo "No matching rows found for '$colName = $matchValue'."
        return
    fi

    # Preview matching rows before deletion
    echo "Matching rows to be deleted:"
    awk -F ":" -v col="$colIndex" -v val="$matchValue" '$(col + 1) == val' "$dataFile"

    echo "Do you want to proceed with deletion? (yes/no):"
    read confirmation

    if [[ "$confirmation" == "yes" ]]; then
        # Delete rows matching the condition
        awk -F ":" -v col="$colIndex" -v val="$matchValue" '$(col + 1) != val' "$dataFile" > "tmp.data" && mv "tmp.data" "$dataFile"

        if [[ $? -eq 0 ]]; then
            echo "Rows matching '$colName = $matchValue' have been successfully deleted from table '$tableName'."
        else
            echo "[Error] An error occurred while deleting rows."
        fi
    else
        echo "Deletion canceled."
    fi
}
