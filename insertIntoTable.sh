function insertIntoTable {
    echo "Enter the table name to insert data into:"
    read tableName

    dataFile="$tableName.data"
    metaFile="$tableName.meta"

    if [[ ! -f "$dataFile" || ! -f "$metaFile" ]]
    then
        echo "[Error] Table '$tableName' does not exist."
        return
    fi

    # Get the primary key (from the 3rd line in the metadata file)
    primaryKey=$(sed -n '3p' "$metaFile" | xargs)
    echo "The primary key is: $primaryKey"

    # Get the column names (from lines starting from 4th to the last column definition)
    colNames=()
    colTypes=()
    for ((i = 4; i <= $(wc -l < "$metaFile"); i++))
    do
        line=$(sed -n "${i}p" "$metaFile")
        colName=$(echo "$line" | cut -d "(" -f 1 | sed 's/^ //;s/ $//')
        colType=$(echo "$line" | cut -d "(" -f 2 | cut -d ")" -f 1 | sed 's/^ //;s/ $//')

        colNames+=("$colName")
        colTypes+=("$colType")
    done

    # Collect and validate data
    rowData=()
    for ((i = 0; i < ${#colNames[@]}; i++))
    do
        colName="${colNames[i]}"
        colType="${colTypes[i]}"

        while true
        do
            echo "Enter value for '$colName' (${colType}):"
            read value

            # Validate data type
            case "$colType" in
                INT)
                    if [[ "$value" =~ ^-?[0-9]+$ ]]; then
                        break
                    else
                        echo "[Error] Value for '$colName' must be an integer."
                    fi;;
                FLOAT)
                    if [[ "$value" =~ ^-?[0-9]*\.?[0-9]+$ ]]; then
                        break
                    else
                        echo "[Error] Value for '$colName' must be a floating-point number."
                    fi;;
                STRING)
                    if [[ -n "$value" ]]; then
                        break
                    else
                        echo "[Error] Value for '$colName' cannot be empty."
                    fi;;
                *)
                    echo "[Error] Unknown data type '$colType'."
                    return;;
            esac
        done

        # Check for primary key uniqueness
        if [[ "$colName" == "$primaryKey" ]]
        then
            # -q to make grep work quite and if this case happened
            # this means that primary key is not unique
            if grep -q "^$value:" "$dataFile"
            then
                echo "[Error] Duplicate value for primary key '$primaryKey': $value."
                return
            fi
        fi

        rowData+=("$value")
    done

    # Write data to the file
    echo "${rowData[*]}" | tr ' ' ':' >> "$dataFile"
    if [[ $? -eq 0 ]]
    then
        echo "Data inserted successfully into table '$tableName'."
    else
        echo "[Error] Failed to insert data into table '$tableName'."
    fi
}
