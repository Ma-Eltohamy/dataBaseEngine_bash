# Database Engine Project

## Overview
This project implements a database engine written in Bash, providing fundamental database operations through a command-line interface with user-friendly menu-driven interactions. The engine allows for creating, listing, connecting to, and dropping databases, among other features, making it a simple yet effective tool for managing databases.

## Features
- **Create Database**: Create new databases.
- **List Databases**: Display all available databases.
- **Connect to Database**: Access a specific database for table and data operations.
- **Drop Database**: Delete an existing database.
- **Exit**: Exit the application gracefully.
- **Error Handling**: Provides error messages for invalid options and operations.

## Requirements
- Bash shell
- `figlet` (for stylized text output)
- Linux-based operating system

## Project Structure
The project consists of the following files:

### Main Script
- **`databaseEngine.sh`**: The entry point of the application. It initializes the menu and handles user inputs.

### Sourced Scripts
Each operation is modularized into its own script file for better organization and maintainability:

- `connectToDataBase.sh`
- `createDataBase.sh`
- `createTable.sh`
- `deleteFromTable.sh`
- `dropDataBase.sh`
- `dropTable.sh`
- `insertIntoTable.sh`
- `listDataBases.sh`
- `listTables.sh`
- `manageDataBase.sh`
- `selectFromTable.sh`
- `selectAllData.sh`
- `selectByCondition.sh`
- `selectByPrimaryKey.sh`
- `selectSpecificColumns.sh`
- `sortData.sh`
- `updateRowInTable.sh`
- `validation.sh`

## Usage
### Running the Script
1. Ensure all required scripts are in the same directory as `databaseEngine.sh`.
2. Run the script with the following command:
   ```bash
   ./databaseEngine.sh start
   ```
3. To display help information, use:
   ```bash
   ./databaseEngine.sh --help
   ```

### Interacting with the Application
- Upon execution, the main menu will be displayed via the terminal.
- Select an option from the menu to perform the corresponding action.
- Follow the prompts for specific operations.

## Directory Setup
The script ensures that a directory named `DBMS` is created in the user's home directory if it does not already exist. This directory is used to store database files and related data.

## Code Highlights
### Menu System
The menu system is implemented using Bash's `select` command, providing a clean and interactive interface:
```bash
PS3="Please choose an option: "
select choice in "${menu[@]}"
do
  case $REPLY in
    1) createDataBase
       break ;;
    2) listDataBases
       break ;;
    3) connectToDataBase
       break ;;
    4) dropDataBase
       break ;;
    5) echo "Exiting..."
       exit 0 ;;
    *) echo "Invalid option. Please try again."
       break ;;
  esac
done
```

### Error Handling
Invalid selections are gracefully handled with error messages:
```bash
echo "Invalid option. Please try again."
```

### Directory Management
Ensures the necessary directory structure exists:
```bash
if ! isAlreadyExists -m; then
  mkdir -p "$HOME/DBMS"
fi
```

## Prerequisites
### Install figlet
For stylized terminal output:
```bash
sudo apt-get install figlet
```
or
```bash
yum install figlet
```

## Contributing
Contributions are welcome! Please follow these steps:
1. Fork the repository.
2. Create a new branch.
3. Implement your changes.
4. Submit a pull request.

## License
This project is licensed under the GPL License.

## Acknowledgments
- Bash scripting community and resources

## Future Enhancements
- Add support for advanced SQL-like queries.
- Introduce user authentication for database access.
- Enhance the menu system with more features and better usability.

---

Thank you for using the Database Engine! If you encounter any issues or have suggestions, feel free to reach out.
