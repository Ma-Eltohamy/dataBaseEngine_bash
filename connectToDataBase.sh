function manageDataBase(){
    local options=(
        "Create Table"
        "List Tables"
        "Drop Table"
        "Insert into Table"
        "Select From Table"
        "Delete From Table"
        "Update Row"
        "Exit"
    )

    while true; do
        PS3="Choose an operation:"
        select option in "${options[@]}"; do
            case $REPLY in
                1)  # Create Table
                    echo "Creating a new table..."
                    # Implement table creation logic here
                    ;;
                2)  # List Tables
                    echo "Listing all tables..."
                    # Implement list tables logic here (e.g., `ls` the tables directory)
                    ;;
                3)  # Drop Table
                    echo "Dropping a table..."
                    # Implement table drop logic here
                    ;;
                4)  # Insert into Table
                    echo "Inserting data into a table..."
                    # Implement insert logic here
                    ;;
                5)  # Select From Table
                    echo "Selecting data from a table..."
                    # Implement select logic here
                    ;;
                6)  # Delete From Table
                    echo "Deleting data from a table..."
                    # Implement delete logic here
                    ;;
                7)  # Update Row
                    echo "Updating a row in a table..."
                    # Implement update logic here
                    ;;
                8)  # Exit
                    echo "Exiting table operations."
                    break 2  # Exit the select menu and return to the main menu
                    ;;
                *)  # Invalid option
                    echo "Invalid option, please try again."
                    ;;
            esac
        done
    done
}

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
    manageDataBase
}
