#!/bin/bash
function confirm()
{
	if [ $CONTINUOUS_INTEGRATION ]; then
		echo "This is a continuous integration VM. Automatically confirming."
		return 1
	fi
	while true
		do
		read -r -p "${1:-Do you want to continue? [y/n])} " response
		case $response in
		[yY][eE][sS]|[yY]) return 1;;
		[nN][oO]|[nN]) return 0;;
		*) echo 'Response not valid';;
		esac
	done
}

function sourceROS(){
	# If ROS is there, source it
	if [ -d "/opt/ros" ]; then
		if [ -d "/opt/ros/"* ]; then
			. `ls -d /opt/ros/*`/setup.bash
		else 
			echo "ROS was not found."
		fi
	fi
}
