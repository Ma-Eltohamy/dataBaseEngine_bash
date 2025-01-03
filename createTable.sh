function createTable {
    echo "Enter table name: "
    read tableName

    if isEmpty "$tableName"
    then
        echo "[Error] Table name cannot be empty."
        echo "Tip: A valid table name should contain at least one character."
        return
    fi

    if isStartWithChars "$tableName"
    then
        echo "[Error] Table name cannot start with a number or special character."
        echo "Tip: Use alphabetic characters or underscores (_) at the beginning."
        return
    fi

    if isAlreadyExists -t "$tableName"
    then
        echo "[Warning] The table name '$tableName' already exists."
        echo "Tip: Use a different name or proceed to modify the existing table name."
        return
    fi

    dataFile="$tableName.data"
    metaFile="$tableName.meta"

    touch "$dataFile" "$metaFile"

    if [[ $? -ne 0 ]]
    then
        echo "[Error] Failed to create table files."
        return
    fi

    echo "Table $tableName created successfully in the database."

    # Ask for number of columns
    echo "Enter the number of columns: "
    read colsNum

    if ! [[ "$colsNum" =~ ^[0-9]+$ ]]
    then
        echo "[Error] Invalid number of columns. Must be a positive integer."
        return
    fi

    declare -a colNames
    declare -a colTypes

    echo "Available data types: (1) INT, (2) STRING, (3) FLOAT"

    # Collect column names and types
    for ((i = 1; i <= colsNum; i++))
    do
        echo "Enter the name of column $i:"
        read colName

        if isEmpty "$colName"
        then
            echo "[Error] Column name cannot be empty."
            i=$((i - 1)) # Retry this column & (()) double for calc
            continue
        fi

        if isStartWithChars "$colName"
        then
            echo "[Error] Column name cannot start with a number or special character."
            i=$((i - 1)) # Retry this column
            continue
        fi

        echo "Select data type for column '$colName':"
        select colType in INT STRING FLOAT
        do
            if [[ -n "$colType" ]]
            then
                colNames+=("$colName")
                colTypes+=("$colType")
                break
            else
                echo "[Error] Invalid selection. Please choose a valid data type."
            fi
        done
    done

    # Choose the primary key
    echo "Select the primary key from the columns:"
    select primaryKey in "${colNames[@]}"
    do
        if [[ -n "$primaryKey" ]]
        then
            echo "Primary key set to '$primaryKey'."
            break
        else
            echo "[Error] Invalid selection. Please choose a valid column."
        fi
    done

    # Write metadata to the meta file
    {
        echo "$tableName"
        echo "${#colNames[@]}"
        echo "$primaryKey"
        for ((i = 0; i < colsNum; i++))
        do
            echo "Column $((i + 1)): ${colNames[i]} (${colTypes[i]})"
        done
    } > "$metaFile"

    echo "Table $tableName metadata saved to $metaFile."
}
