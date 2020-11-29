#!/bin/bash
#
## update, remove unwanted softwate and install preferred software
#

## functions
function fill_log {
	if [ -f "install.log" ]
	then
		tee -a install.log
	else
		tee install.log
	fi
}
function show_progress {
	case $1 in
		1)
			echo
			echo "1. Updating your Linux System"
			echo "-----------------------------"
			;;
		2)
			echo
			echo "2. Uninstalling Unwanted Software"
			echo "---------------------------------"
			;;
		3)
			echo
			echo "3. Installing New So9ftware"
			echo "---------------------------"
			;;
		4)
			echo
			echo '4. Your System will now Reboot"
			echo "------------------------------"
			;;
	esac
}
function update_system {
	#compare version info
	sudo apt update
	#update any software that has newer versions
	sudo apt --yes upgrade
}
function remove_software {
	#remove everything including config files
	sudo apt --yes purge $(cat uninstall.conf)
	#remove packages not needed anymore
	sudo apt autoremove
}
function install_software {
	#install new software without prompts
	sudo apt --yes install $(cat install.conf)
}

## end functions

#remove old install log file if it exists
rm install.log 2>/dev/null

#update the system
show_progress 1 | fill_log
update_system | fill_log

#uninstall any unwanted software
show_progress 2 | fill_log

if [ -s "uninstall.conf" ]
then
	#uninstall.conf file exists and contains asoftware list to remove
	remove_software | fill_log
elif [ -f "uninstall.conf" ]
then
	#file exists but is black
	echo "No software was selected to be removed." | fill_log
else
	#file doesn't exist
	echo "The uninstall.conf file will be created." | fill_log
	echo "Make a space seperated list of software to remove." | fill_log
	echo "Save the blank file to remove no software." | fill_log
	echo "Press Enter to continue..." | fill_log
	read
	vim uninstall.conf

	if [ -s "uninstall.conf" ]
	then
		remove_software | fill_log
	else
		echo "No software was selected to be removed." | fill_log
	fi
fi

#install any unwanted software
show_progress 3 | fill_log

if [ -s "install.conf" ]
then
        #install.conf file exists and is not empty
        install_software | fill_log
elif [ -f "install.conf" ]
then
        #file exists but is black
        echo "No new software was selected to be installed." | fill_log
else
        #file doesn't exist
        echo "The install.conf file will be created." | fill_log
        echo "Make a space seperated list of software to install." | fill_log
        echo "Save the blank file to install no software." | fill_log
        echo "Press Enter to continue..." | fill_log
        read
        vim install.conf

        if [ -s "install.conf" ]
        then
                install_software | fill_log
        else
                echo "No new software was selected to be installed." | fill_log
        fi
fi

#reboot
show_progress 4 | fill_log
sudo systemctl reboot
