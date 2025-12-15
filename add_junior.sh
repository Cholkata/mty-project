#!/bin/bash
echo "Give user name: "
read user
adduser "$user"
if [ $? -eq 0 ]; then
	echo "User created successfully!"
else
	echo "Failed to create user."
	exit 1
fi
chsh -s /bin/bash "$user"
if ! getent group developers > /dev/null; then
	groupadd developers
	echo "Developers group created."
fi
usermod -aG developers "$user"
echo "User joined developers group!"