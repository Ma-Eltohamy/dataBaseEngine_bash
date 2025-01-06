function manageDataBase(){
    dataBaseName=$1

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
                1) createTable "$dataBaseName"
                    break ;;

                2) listTables  "$dataBaseName"
                    break ;;

                3) dropTable "$dataBaseName"
                    break ;;

                4) insertIntoTable "$dataBaseName"
                    break ;;

                5) selectFromTable "$dataBaseName"
                    break ;;

                6) deleteFromTable "$dataBaseName"
                    break;;

                7) updateRowInTable "$dataBaseName"
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
