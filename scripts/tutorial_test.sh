#!/bin/bash

############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "Tests the tutorial"
   echo
   echo "Syntax: test.sh [-h]"
   echo "options:"
   echo "h     Print this Help."
   echo
}

############################################################
############################################################
# Main program                                             #
############################################################
############################################################

SHELL_FILE_DIRECTORY="tmp"
SHELL_FILE="shell_tutorial.sh"

set -o errexit

# Removing the created SHELL_FILE_DIRECTORY if it exists
echo "Removing previous tmp directory if it exists"
rm -r $SHELL_FILE_DIRECTORY &> /dev/null || true 

# The script will happen in SHELL_FILE_DIRECTORY to avoid any problem with other files
mkdir $SHELL_FILE_DIRECTORY
cd $SHELL_FILE_DIRECTORY

# Copying the README of the concerned tutorial
echo "Copying the tutorial README"
cp "../README.md" .

# Creating the file with only the shell lines of the tutorial
echo > $SHELL_FILE
echo '#!/bin/bash' > $SHELL_FILE
echo '' > $SHELL_FILE
chmod +x $SHELL_FILE

# Extracting from the README the shell lines
echo "Extracting the shell commands from the README"
sed -e "/\`\`\`shell/,/\`\`\`/!d" "README.md" | grep '^[^`]' >> $SHELL_FILE
rm "README.md"

# Checking if docker is up and running
docker ps &> /dev/null

# Running the generated script
echo "Running the generated script"
./$SHELL_FILE &> /dev/null

# Stopping the ARLAS stack
echo "Stopping the ARLAS stack"
cd $(find . -type d -regex "\.\/[^/]*")
./$(find . -type d -regex "\.\/ARLAS[^/]*")/stop.sh &> /dev/null

# Removing the SHELL_FILE_DIRECTORY
cd ../..
rm -r $SHELL_FILE_DIRECTORY

echo "The AIS tutorial is working!"