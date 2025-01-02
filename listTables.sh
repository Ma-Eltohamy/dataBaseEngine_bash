function listTables(){
    echo "Listing Tables:"
    echo "---------------------------------"
    ls -1 *.data *.meta 2>/dev/null | sed -E 's/\.(data|meta)$//' | sort -u # sort -u to remove redundency
    echo "---------------------------------"
}
