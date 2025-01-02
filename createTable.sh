function createTable {

  dataBaseName=$1
  
  # do these operations but for the table
  echo "Enter table name: "
  read tableName

  if isEmpty "$tableName"
  then
    echo "[Error] table name name cannot be empty."
    echo "Tip: A valid table name should contain at least one character."
    return
  fi

  if isStartWithChars "$tableName"
  then
    echo "[Error] table name name cannot start with a number or specail character."
    echo "Tip: Use alphabetic characters or underscores (_) at the beginning."
    return
  fi

  if isAlreadyExists -t "$tableName"
  then
    echo "[Warning] The table name '$tableName' already exists."
    echo "Tip: Use a different name or proceed to modify the existing table name."
    return
  fi

    touch "$dataFile" "$metaFile"
      if [[ $? == 0 ]]
      then
        echo "Table $tableName created successfully in database $dataBaseName."

        # Prompt user to define columns and data types
        echo -e "Enter table columns (comma-separated, e.g., id,name,age): \c"
        read columns
        echo -e "Enter data types for the columns (comma-separated, e.g., int,string,int): \c"
        read dataTypes

        # Validate the number of columns matches the number of data types
        columnCount=$(echo "$columns" | awk -F',' '{print NF}')
        typeCount=$(echo "$dataTypes" | awk -F',' '{print NF}')

        if [[ $columnCount -eq $typeCount ]]; then
          # Display columns to select a primary key
          echo "Columns: $columns"
          echo -e "Enter the name of the primary key column: \c"
          read primaryKey

          # Check if the primary key is a valid column
          if [[ $(echo "$columns" | grep -w "$primaryKey") ]]; then
            # Save headers, data types, and primary key in the .meta file
            echo "$columns" > "$metaFile"
            echo "$dataTypes" >> "$metaFile"
            echo "PrimaryKey:$primaryKey" >> "$metaFile"
            echo "Table names , data types, and primary key saved successfully in $tableName.meta."
          else
            echo "Error: $primaryKey is not a valid column."
            # Remove the created files if schema definition fails
            rm "$dataFile" "$metaFile"
          fi
        else
          echo "Error: Number of columns does not match number of data types."
          # Remove the created files if schema definition fails
          rm "$dataFile" "$metaFile"
        fi
      else
        echo "Error creating table $tableName in database $dbName."
      fi
    fi
  else
    echo "Database $dbName does not exist."
  fi
}
  # Check if the database exists
  if [[ -d $HOME/DBMS/$dbName ]]; then
    echo -e "Enter Table Name: \c"
    read tableName

    # Path to the table files
    dataFile="$HOME/DBMS/$dbName/$tableName.data"
    metaFile="$HOME/DBMS/$dbName/$tableName.meta"

    # Check if the table already exists
    if [[ -f $dataFile || -f $metaFile ]]; then
      echo "Table $tableName already exists in database $dbName."
