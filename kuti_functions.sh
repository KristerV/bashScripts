#!/bin/bash

function startGromit {
	ps | grep gromit

	if [ "$?" -ne "0" ];
		then
			gromit-mpx -a &
			
			# setup wacom buttons
			xsetwacom --set "Wacom Bamboo Craft Pad pad" Button 3 "key F9"
			xsetwacom --set "Wacom Bamboo Craft Pad pad" Button 8 "key +super g"
			xsetwacom --set "Wacom Bamboo Craft Pad pad" Button 9 "key +alt F9"
			xsetwacom --set "Wacom Bamboo Craft Pad pad" Button 1 "key +shift F9"

			notify-send "Gromit started"
		else
			notify-send "Gromit already online"
	fi

}

function toggleConky {
	if pidof conky | grep [0-9] > /dev/null
	then
		exec killall conky
	else
		exec conky
	fi
}

$@