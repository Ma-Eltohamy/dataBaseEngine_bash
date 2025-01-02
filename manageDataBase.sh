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

    while true
    do
        PS3="Choose an operation:"
        select option in "${options[@]}"
        do
            case $REPLY in
                1) createTable
                    break ;;

                2) listTables
                    break ;;

                3) echo "Dropping a table..."
                    break ;;

                4) echo "Inserting data into a table..."
                    break ;;

                5) echo "Selecting data from a table..."
                    break ;;

                6) echo "Deleting data from a table..."
                    break;;

                7) echo "Updating a row in a table..."
                    break;;
                    
                8) echo "Exiting table operations."
                    return 0 ;;  # Exit the select menu and return to the main menu

                *)  # Invalid option
                    echo "Invalid option, please try again."
                    ;;
            esac
        done
    done
}
