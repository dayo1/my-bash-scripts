#!/bin/bash
# This script creates a new user account and password on the local Linux system.
# User must supply a username as an argument to the script.
# User may optionally provide a comment for the account as an argument.
# A password will be automatically generated for the user account.
# The username, password, and host for the account will also be displayed.


# Check to see if user has root privileges.
if [[ "${UID}" -ne 0 ]]
then
 echo 'You are not logged in as root.' >&2
 exit 1
fi

# Provide help if they do not supply at least one argument.
if [[ "${#}" -lt 1 ]]
then
  echo "Usage: ${0} USER_NAME [COMMENT]..." >&2
  echo 'You have to first create an account on the local system with the name of USER_NAME and a comments field of COMMENT.' >&2
  exit 1
fi

# Ask for the user name (login).
USER_NAME="${1}"

# The rest of the parameters are for the account comments
shift
COMMENT="${@}"


# Ask for the real name (contents for the description field).
read -p 'Enter the name of the person who this account is for: ' COMMENT


# Generate a password
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c48)


# Create the user account with the password.
useradd -c "${COMMENT}" -m ${USER_NAME} &> /dev/null

# Check to see if the useradd command succeeded.
# We don't want to tell the user that an account has been created when it hasn't been.
# Inform user if account was not created and return an exit status of 1.
if [[ "${?}" -ne 0 ]]
then
 echo 'The account was not created' >&2
 exit 1
fi

# Set the password for the user.
echo ${PASSWORD} | passwd --stdin ${USER_NAME} &> /dev/null

# Check to see if the passwd command succeeded.
if [[ "${?}" -ne 0 ]]
then
 echo 'The password for the account could not be set' >&2
exit 1
fi

# Force the user to change password on first login.
passwd -e ${USER_NAME} &> /dev/null

# Display the username, password, and the host where the user was created.
echo 'username:'
echo "${USER_NAME}"
echo
echo 'password:'
echo "${PASSWORD}"
echo
echo 'host:'
echo "${HOSTNAME}"
exit 0
