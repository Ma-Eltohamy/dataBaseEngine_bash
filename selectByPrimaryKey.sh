function selectByPrimaryKey() {
  headersString=$1
  echo
  echo "Enter the value of the primary key ($primaryKey):"
  read pkValue

  if [ -z "$pkValue" ]
  then
    echo "[Error] Primary key value cannot be empty."
    break
  fi

  if [ -z "$result" ]
  then
    echo "[Error] No rows found with the primary key value: $pkValue"
  else
    {
      echo "$headersString"
      echo "$result"
    } | column -ts ":"
  fi
}
