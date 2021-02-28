#!/bin/bash

#script for local security checks

function checks() {
	if [[ $3 = "" ]]
	then
	current_value="empty"
	else
	current_value=$3
	fi

	if [[ $2 = "" ]]
        then
        correct_value="empty"
        else
        correct_value=$2
        fi

	if [[ $2 != $3 ]]
	then

		echo -e "\e[1;31mThe $1 policy is not compliant. The current policy should be: $correct_value, the current value is: $current_value.\e[0m"
		is_compliant=0
	else

		echo -e "\e[1;32mThe $1 is compliant. Current value is $current_value.\e[0m"

		is_compliant=1
	fi
}

#Check the password max days policy

pmax=$(egrep -i '^PASS_MAX_DAYS' /etc/login.defs | awk ' {print $2} ')
# Checks for password max
#           $1              $2       $3
checks "Password Max Days" "365" "${pmax}"
if [[ $is_compliant = 0 ]]
then
        echo -e "Set the PASS_MAX_DAYS parameter to conform to site policy in /etc/login.defs : \n PASS_MAX_DAYS 365 \n Modify user parameters for all users with a password set to match: \n chage --maxdays 365 <user>"
fi
# Check the  pass min days between changes
pmin=$(egrep -i '^PASS_MIN_DAYS' /etc/login.defs | awk ' {print $2} ')
checks "Password Min Days" "14" "${pmin}"
if [[ $is_compliant = 0 ]]
then
        echo -e "Set the PASS_MIN_DAYS parameter to conform to site policy in /etc/login.defs : \n PASS_MIN_DAYS 14"
fi
#Check the pass warn age
pwarn=$(egrep -i '^PASS_WARN_AGE' /etc/login.defs | awk ' {print $2} ')
checks "Password Warn AGE" "7" "${pwarn}"
if [[ $is_compliant = 0 ]]
then
        echo -e "Set the PASS_WARN_AGE parameter to conform to site policy in /etc/login.defs : \n PASS_WARN_AGE 7"
fi
#Check the SSH UsePam configuration
chkSSHPAM=$(egrep -i "^UsePAM" /etc/ssh/sshd_config | awk ' { print $2 }' )
checks "SSH UsePAM" "yes" "${chkSSHPAM}"
if [[ $is_compliant = 0 ]]
then
        echo -e "Just fix it"
fi
#Check permissions on users home directory
echo ""
for eachDIR in $(ls -l /home | egrep '^d' | awk ' {print $3 } ')
do

	ChDIR=$(ls -ld /home/${eachDir} | awk ' { print $1 } ')
	checks "Home directory ${eachDir}" "drwx------" "${ChDir}"
	if [[ $is_compliant = 0 ]]
then
        echo -e "run chown to fix it"
fi

done


#checks if IP forwarding is set to 0
ip_forward_chk=$(sysctl net.ipv4.ip_forward | awk '{print $3}')
checks " IP forwarding" "0" "${ip_forward_chk}"
if [[ $is_compliant = 0 ]]
then
	echo -e "Edit /etc/sysctl.conf and set: \nnet.ipv4.ip_forward=1\nto\nnet.ipv4.ip_forward=0.\nThen run: \n sysctl -w"
fi

#Checks if ICMP redirects have been turned off
icmp_redirect_chk=$(sysctl net.ipv4.conf.all.accept_redirects | awk '{print $3}')
checks " ICMP redirecting" "0" "${icmp_redirect_chk}" 
if [[ $is_compliant = 0 ]]
then
echo -e "Set the following parameters in /etc/sysctl.conf or a /etc/sysctl.d/* file: \nnet.ipv4.conf.all.accept_redirects = 0 \nnet.ipv4.conf.default.accept_redirects = 0\n"
fi

#Checks crontab permissions are set up
cron_chk=$(stat /etc/crontab | egrep -i "^Access" | head -n 1)
if [[ ${cron_chk} =  "Access: (0600/-rw-------) Uid: ( 0/ root) Gid: ( 0/ root)" ]]
then
p=0
else
p=1
fi
checks " Checking Crontab permissions /etc/crontab" "0" "${p}"
if [[ $is_compliant = 0 ]]
then
echo -e "run these commands for /etc/crontab as sudo: \n chown root:root /etc/crontab \n chmod og-rwx /etc/crontab \n"
fi

#Checks cron.hourly permissions are set up
 cronH_chk=$(stat /etc/cron.hourly | egrep -i "^Access" | head -n 1)
 if [[ ${cronH_chk} =  "Access: (0700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)" ]]
 then
 p=0
 else
 p=1
 fi
 checks " Checking Cron.hourly permissions /etc/cron.hourly" "0" "${p}"
 if [[ $is_compliant = 0 ]]
 then
     echo -e "run these commands for /etc/cron.hourly as sudo: \n chown root:root /etc/cron.hourly \n chmod og-rwx /etc/cron.houlry \n"
 fi



#Checks cron.daily permissions are set up
  cronD_chk=$(stat /etc/cron.daily | egrep -i "^Access" | head -n 1)
  if [[ ${cronD_chk} =  "Access: (0700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)" ]]
  then
  p=0
  else
  p=1
  fi
  checks " Checking Cron.daily permissions /etc/cron.daily" "0" "${p}"
  if [[ $is_compliant = 0 ]]
  then
      echo -e "run these commands for /etc/cron.daily as sudo: \n chown root:root /etc/cron.daily \n chmod og-rwx /etc/cron.daily \n"
  fi

#Checks cron.weekly permissions are set up
  cronW_chk=$(stat /etc/cron.weekly | egrep -i "^Access" | head -n 1)
  if [[ ${cronW_chk} =  "Access: (0700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)" ]]
  then
  p=0
  else
  p=1
  fi
  checks " Checking cron.weekly permissions /etc/cron.weekly" "0" "${p}"
  if [[ $is_compliant = 0 ]]
  then
      echo -e "run these commands for /etc/cron.weekly as sudo: \n chown root:root /etc/cron.weekly \n chmod og-rwx /etc/cron.weekly \n"
  fi




#Checks cron.monthly permissions are set up
cronM_chk=$(stat /etc/cron.weekly | egrep -i "^Access" | head -n 1)
if [[ ${cronM_chk} =  "Access: (0700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)" ]]
then
p=0
else
p=1
fi
checks " Checking cron.monthly permissions /etc/cron.monthly" "0" "${p}"
if [[ $is_compliant = 0 ]]
then
     echo -e "run these commands for /etc/cron.monthly as sudo: \n chown root:root /etc/cron.monthly \n chmod og-rwx /etc/cron.monthly"
 fi




 #Checks PASSWD permissions are set up
 passwd_chk=$(stat /etc/passwd | egrep -i "^Access" | head -n 1)
 if [[ ${passwd_chk} =  "Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)" ]]
 then
 p=0
 else
 p=1
 fi
 checks " Checking passwd permissions /etc/passwd" "0" "${p}"
 if [[ $is_compliant = 0 ]]
 then
      echo -e "run these commands for /etc/passwd as sudo: \n chown root:root /etc/passwd \n chmod 644 /etc/passwd \n"
 fi




#Checks shadow permissions are set up
  shadow_chk=$(stat /etc/shadow | egrep -i "^Access" | head -n 1)
  if [[ ${shadow_chk} =  "Access: (0640/-rw-r-----) Uid: ( 0/ root) Gid: ( 42/ shadow)" ]]
  then
  p=0
  else
  p=1
  fi
  checks " Checking shadow permissions /etc/shadow" "0" "${p}"
  if [[ $is_compliant = 0 ]]
  then
      echo -e "run these commands for /etc/shadow as sudo: \n chown root:shadow /etc/shadow \n  chmod o-rwx,g-wx /etc/shadow  \n"
fi



#Checks group permissions are set up
  group_chk=$(stat /etc/group | egrep -i "^Access" | head -n 1)
  if [[ ${group_chk} =  "Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)" ]]
  then
    p=0
  else
  p=1
  fi
  checks " Checking group permissions /etc/group" "0" "${p}"
  if [[ $is_compliant = 0 ]]
  then
        echo -e "run these commands for /etc/group as sudo: \n chown root:root /etc/group \n  chmod 644 /etc/group  \n"
fi

#Checks gshadow permissions are set up
   gshadow_chk=$(stat /etc/gshadow | egrep -i "^Access" | head -n 1)
   if [[ ${gshadow_chk} =  "Access: (0640/-rw-r-----) Uid: ( 0/ root) Gid: ( 42/ shadow)" ]]
   then
   p=0
   else
   p=1
   fi
   checks " Checking gshadow permissions /etc/gshadow" "0" "${p}"
   if [[ $is_compliant = 0 ]]
   then
       echo -e "run these commands for /etc/gshadow as sudo: \n chown root:shadow /etc/gshadow \n  chmod o-rwx,g-wx /etc/gshadow  \n"
fi

#Checks PASSWD- permissions are set up
 passwd1_chk=$(stat /etc/passwd- | egrep -i "^Access" | head -n 1)
  if [[ ${passwd1_chk} =  "Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)" ]]
  then
  p=0
  else
  p=1
  fi
  checks " Checking passwd- permissions /etc/passwd-" "0" "${p}"
  if [[ $is_compliant = 0 ]]
  then
       echo -e "run these commands for /etc/passwd- as sudo: \n chown root:root /etc/passwd- \n chmod u-x,go-wx /etc/passwd \n"
  fi


#Checks shadow- permissions are set up
shadow1_chk=$(stat /etc/shadow | egrep -i "^Access" | head -n 1)
if [[ ${shadow1_chk} =  "Access: (0640/-rw-r-----) Uid: ( 0/ root) Gid: ( 42/ shadow)" ]]
then
p=0
else
P=1
fi
checks " Checking shadow- permissions /etc/shadow-" "0" "${p}"
if [[ $is_compliant = 0 ]]
then
 echo -e "run these commands for /etc/shadow- as sudo: \n chown root:shadow /etc/shadow- \n  chmod o-rwx,g-wx /etc/shadow-  \n"
fi



#Checks group- permissions are set up
 group1_chk=$(stat /etc/group- | egrep -i "^Access" | head -n 1)
 if [[ ${group1_chk} =  "Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)" ]]
 then
  p=0
   else
 p=1
   fi
    checks " Checking group- permissions /etc/grou-p" "0" "${p}"
 if [[ $is_compliant = 0 ]]
 then
       echo -e "run these commands for /etc/group- as sudo: \n chown root:root /etc/group- \n  chmod u-x,go-wx /etc/group  \n"
fi


 #Checks gshadow permissions are set up
 gshadow1_chk=$(stat /etc/gshadow- | egrep -i "^Access" | head -n 1)
  if [[ ${gshadow1_chk} =  "Access: (0640/-rw-r-----) Uid: ( 0/ root) Gid: ( 42/ shadow)" ]]
  then
  p=0
  else
  p=1
  fi
  checks " Checking gshadow- permissions /etc/gshadow-" "0" "${p}"
  if [[ $is_compliant = 0 ]]
   then
     echo -e "run these commands for /etc/gshadow- as sudo: \n chown root:shadow /etc/gshadow- \n  chmod o-rwx,g-wx /etc/gshadow-  \n"
fi

#Ensure no legacy "+" entries exist in /etc/passwd
legacy1=$(grep '^\+:' /etc/passwd)
checks " legacy entries check in /etc/passwd" "" "${legacy1}"
if [[ $is_compliant = 0 ]]
then
        echo -e "Remove any legacy '+' entries from /etc/passwd if they exist."
fi

#Ensure permissions on /etc/crontab are configured
bruh=$(stat /etc/crontab | egrep -i '^Access' | head -n 1)
if [[ ${bruh} == "Access: (0600/-rw-------) Uid: ( 0/ root) Gid: ( 0/ root)" ]]
then
perms1=0
else
perms1=1
fi
checks " Ensuring permissions on /etc/crontab" "0" "${perms1}"
if [[ $is_compliant = 0 ]]
then
	echo -e "Run the following commands to set ownership and permissions on /etc/crontab: \nchown root:root /etc/crontab \nchmod og-rwx /etc/crontab\n"
fi


#Ensure no legacy "+" entries exist in /etc/shadow
legacy2=$(grep '^\+:' /etc/shadow)
checks " legacy entries check in /etc/shadow" "" "${legacy2}"
if [[ $is_compliant = 0 ]]
then
        echo -e "Remove any legacy '+' entries from /etc/shadow if they exist."
fi

#Ensure no legacy "+" entries exist in /etc/group
legacy3=$(grep '^\+:' /etc/group)
checks " legacy entries check in /etc/group" "" "${legacy3}"
if [[ $is_compliant = 0 ]]
then
        echo -e "Remove any legacy '+' entries from /etc/group if they exist."
fi

#Ensure root is the only UID 0 account
root_chk=$(cat /etc/passwd | awk -F: '($3 == 0) { print $1 }')
checks " UID 0 check" "root" "${root_chk}"
if [[ $is_compliant = 0 ]]
then
        echo -e "Remove any users other than root with UID 0 or assign them a new UID if appropriate."
fi
