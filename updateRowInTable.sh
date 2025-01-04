function updateRowInTable {
    dataBaseName=$1
    
    echo "Enter the table name to update a row in:"
    read tableName


    if ! isAlreadyExists -t "$dataBaseName" "$tableName"
    then
        echo "[Error] Table '$tableName' does not exist."
        return
    fi
    
    metaFile="$HOME/DBMS/$dataBaseName/$tableName.meta"
    dataFile="$HOME/DBMS/$dataBaseName/$tableName.data"

    # Get the primary key
    primaryKey=$(sed -n '3p' "$metaFile" | xargs)
    echo "The primary key is: $primaryKey"

    # Prompt the user for the primary key value
    echo "Enter the value of the primary key to update:"
    read pkValue

    # Check if the row exists
    row=$(grep "^$pkValue:" "$dataFile")
    if [[ -z "$row" ]]; then
        echo "[Error] No row found with primary key '$pkValue'."
        return
    fi

    echo "Row found: $row"

    # Get column names and types
    colNames=()
    colTypes=()
    for ((i = 4; i <= $(wc -l < "$metaFile"); i++)); do
        line=$(sed -n "${i}p" "$metaFile")
        colName=$(echo "$line" | cut -d "(" -f 1 | sed 's/^ //;s/ $//')
        colType=$(echo "$line" | cut -d "(" -f 2 | cut -d ")" -f 1 | sed 's/^ //;s/ $//')

        colNames+=("$colName")
        colTypes+=("$colType")
    done

    # Prompt the user for new values
    newRow=()
    IFS=':' read -r -a oldRow <<< "$row"
    for ((i = 0; i < ${#colNames[@]}; i++)); do
        colName="${colNames[i]}"
        colType="${colTypes[i]}"
        oldValue="${oldRow[i]}"

        while true; do
            echo "Enter new value for '$colName' (${colType}) [current: $oldValue]:"
            read newValue

            # If the user presses Enter, keep the old value
            if [[ -z "$newValue" ]]; then
                newValue="$oldValue"
                break
            fi

            # Validate the input based on column type
            case "$colType" in
                INT)
                    if [[ "$newValue" =~ ^-?[0-9]+$ ]]; then
                        break
                    else
                        echo "[Error] Value for '$colName' must be an integer."
                    fi;;
                FLOAT)
                    if [[ "$newValue" =~ ^-?[0-9]*\.?[0-9]+$ ]]; then
                        break
                    else
                        echo "[Error] Value for '$colName' must be a floating-point number."
                    fi;;
                STRING)
                    if [[ -n "$newValue" ]]; then
                        break
                    else
                        echo "[Error] Value for '$colName' cannot be empty."
                    fi;;
                *)
                    echo "[Error] Unknown data type '$colType'."
                    return;;
            esac
        done
        # Check if the new primary key value already exists
        if [[ "$colName" == "$primaryKey" && "$newValue" != "$oldValue" ]]; then
            if grep -q "^$newValue:" "$dataFile"
            then
                echo "[Error] A row with the primary key '$newValue' already exists. Please enter a unique primary key."
                return
            fi
        fi
        newRow+=("$newValue")
    done

    # Replace the old row with the new row in the data file
    newRowString=$(IFS=':'; echo "${newRow[*]}")
    sed -i "s/^$row\$/$newRowString/" "$dataFile"

    if [[ $? -eq 0 ]]; then
        echo "Row updated successfully!"
    else
        echo "[Error] Failed to update the row."
    fi
}

