#!/bin/bash
# This script creates an account on the local Linux system.

# Check to see if user has root privileges.
if [[ "${UID}" -ne 0 ]]
then
 echo 'Log in as root.'
  exit 1
fi

# Ask for the user name (login).
read -p 'Enter the username to create: ' USER_NAME

# Ask for the real name (contents for the description field).
read -p 'Enter the name of the person who this account is for: ' COMMENT


# Ask for password.
read -p 'Enter the password for the account: ' PASSWORD

# Create the user account with the password.
useradd -c "${COMMENT}" -m ${USER_NAME}

# Inform user if account was not created and return an exit status of 1.Else, display username, password and host where the account was created.
if [[ "${?}" -ne 0 ]]
then
 echo 'Your account was not created'
exit 1
fi

# Set the password for the user.
echo ${PASSWORD} | passwd --stdin ${USER_NAME}
if [[ "${?}" -ne 0 ]]
then
   echo 'The password for the account could not be set.'
   exit 1
fi

# Force the user to change password on first login.
passwd -e ${USER_NAME}

# Display the username, password, and the host where the user was created.
echo
echo 'username'
echo "${USER_NAME}"
echo 
echo 'password'
echo "${PASSWORD}"
echo
echo 'host'
echo "${HOSTNAME}"
exit 0

