#!/bin/bash
#TODO
echo "Give user name: " 
read user
`addusr 'user'`
echo "User created successfully!"
`chsh -s /bin/bash`
`usermod -G developers $user`
if ($developers=true)
	echo "User joined developers group!"
else
	`groupadd developers`
	echo "User joined developers group!"
fi	
