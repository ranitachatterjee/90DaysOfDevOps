# taking the option from the user
 
read -p "Type C or c or create for account creation , Type D or d or delete for account deletion , Type R or r or reset for password reset , Type L or l or list to list all the users , Type H or h or help to display all the option information  :  " option

#n = $(cat /etc/passwd | grep -o "$user" | wc -l) --- it will not work if the new user's name matches partly with the existing user ; then it wil  show the user exits. For eg - user has typed a new user 'rani' and 'ranita' is already existing ; then it will show user exits (ie. rani = ranita [it is assuming]). Even though rani is a new user , it will show 'rani' already exists ; as rani is partly matching with the patter 'ranita'
 # used switch case in this prog. here the options C for creation , D for deletion , R for reset , L for list, H for help are cosidered as a case.If C is typed then the 1st case which contains the user creation logic , is executed. 
case $option in
       	C | c | create)
	#creating a new user
	#
	
	echo "===User Creation==="
	read -p "Enter the username :: " user # Username is taken as input from the user
	
 	
	n=$(cat /etc/passwd | cut -d: -f1)  #using cut command extracting the 1st field before the delimiter':', from each row in etc/passwd file.The 1st field contains the username present in etc/passwd file. The users are stored in variable n.
	for firstword in $n  # firstword is used to iterate over all the users stored in variable n.
	do
		if [ "$firstword" == "$user" ] #if firstword (ie. the existing user) matches with the username entered through input
	
		
		 	then 
		 	echo  "$user already exists" # then print that the user entered through input already exists a
			exit 1 # and exit from the program
		fi
	done		

#			echo "\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"
			
			sudo useradd -m $user	 # this line is executed when the entered user through input,  does not match with the user in etc/passwd file.

	       	#the -s denotes that  password cannot be seen while typing
			read -s -p "Type  password : " ps1
			echo
			read -s -p "Retype password : " ps2
			echo
			
			if [ "$ps1" != "$ps2" ] # checking if the typed password does not match with retyped password.
			then
				echo "password entered is incorrect" # if the above condition is true then print password entered is incorrect
				exit 1 # and exit the program with status 1

			else
			      echo  "$user:$ps1" | sudo chpasswd  #chpasswd sets passwd for user.Takes input in username:password format.Password will be set when the typed and the retyped password both are same. 
                       echo " '$user' created successfully  "	# After creating the new user and setting the password, print username created successfully.

			fi
			;;

			
	
	D | d | delete)
	 #account deletion---------------------------------------------------------------------------------------------------------
	echo "====Account deletion===="
	read -p "Enter the user you want to delete ::  " deleteuser # Username to be delted is taken as input from the user
	n=$(cat /etc/passwd | cut -d: -f1)
	for firstword in $n
	do
		if [ "$firstword" == "$deleteuser" ] # if the usename taken as input , matches with the user present in etc/passwd , then perform delete operation and print user deleted successfully and exit the prog with status 0.
		then
			sudo userdel -r $deleteuser
			echo "user deleted succesfully"
			echo
			exit 0
		fi
	done

		
			echo "The account '$deleteuser' you wish to delete, is not present. Hence unable to delete" # if the usrname taken as input does not matche with the user in etc/passwd , then delete operation cannot be performed and print unable to delete the user and exit the prog. 
			exit 1
			;;
			

	R | r | reset)	
	
	#password reset of an account------------------------------------------------------------------------------------------------------
	echo "====Password Reset===="	
	read -p "Enter the user , whose password you want to reset :: " userpasswordreset
        echo	
	n=$(cat /etc/passwd | cut -d: -f1)
	for firstword in $n
	do
		if [ "$firstword" == "$userpasswordreset" ] #if the user in etc/passwd matches with the user taken as input ; then type a new passwordd. Retype the newly entered password again. If the typed and the retyped password do not match; then print passwords do not match and then exit the program. if the typed and the retyped passwds match then reset the passwd of the existing user using sudo chpasswd.and print passwd reset successfully and exit.
		then
			
			
			read -s -p  "type the new password :: " ps1
			echo
			read -s  -p " retype the password :: " ps2
			echo
			if [ "$ps1" != "$ps2" ]
				then
				echo "Password do not match"
			echo
				exit 0

			fi
		echo "$userpasswordreset:$ps1" | sudo chpasswd 
		echo
		echo "Password reset successfully"
		exit 1
		fi
	done	
 		echo "user does not exist" # if the user taken as input does not match with the users in etc/passwd file , then print user does not exist.
		;;

	L | l | list)
                
		# Listing all the users and their corresponding UID
		echo "----list all the users----"
		echo "printing the users with corresponding UID"
		user_list=$(cat /etc/passwd | cut -d: -f1)
		for firstword in $user_list
		do
			n2=$(id -u $firstword) # it is a command to list all the UID of the users , and firstword is a varible that  denotes the user present in etc/passwd file
			echo "name : $firstword uid : $n2"
		done
		;;

	H | h| help)

		#Giving a brief of what each option does

		echo "----List of all the options available and their usage----"

                 echo "Usage: $0 [OPTION]"
                 echo
                 echo "Options:"
                 echo "  -c, -C, -create     Create a new user"
                 echo "  -d, -D, -delete     Delete a user"
                 echo "  -r, -R, -reset      Reset a user's password"
                 echo "  -h, -H, -help       Display this help message"
                 echo
                 exit 0

                 ;;



	*) # * indicates any other input other than the above options of the cases
		echo "Invalid Input" ;;
	esac
