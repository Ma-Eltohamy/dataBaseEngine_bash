# I am the only internal user for this function so i 100% will be a firendly user
function isAlreadyExists(){
  local flag="$1"
  local dataBaseName="$2"
  local tableName="$3"

  case "$flag" in
    -m)
      if test -d "$HOME/DBMS"
      then
        return 0 # Success
      fi;;
    -d)
      if test -d "$HOME/DBMS/$dataBaseName"
      then
        return 0 # Success
      fi;;
    -t)
      if test -f "$HOME/DBMS/$dataBaseName/$tableName.meta" || \
        test -f "$HOME/DBMS/$dataBaseName/$tableName.data"
            then
              return 0 # Success
      fi;;
    *)
      echo "Error: Invalid flag provided. User -m, -d, or -t."
      return 0;; # Success
  esac

  return 1 # Failuer
}

function isEmpty(){
  local userInput="$@"  # Treat all given parameters as a single string

  # Check if the input is empty
  if [ -z "$userInput" ] # the -z is specifically designed for string length checks
    # -z returns true if the string is zero
  then
    return 0  # Success
  fi
  return 1  # Failure
}

function isStartWithChars() {
  local userInput="$@"  # Treat the given parameters as one entity

  if [[ "$userInput" =~ ^[^a-zA-Z] ]]
  then
    return 0  # Success: Starts with a number or special character
  fi
  return 1  # Failuer: Does not start with a number or special character
}

