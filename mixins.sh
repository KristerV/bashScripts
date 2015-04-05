#!/bin/bash

function confirm {
    if [ "$?" -ne "0" ];
        then
            notify-send "ERROR: $(tail -1 ~/.tmp/error.txt)"
        else
            notify-send $1
    fi
}

function getdatetime {
	datetime=$(date "+%Y-%m-%d_%H:%M:%S")
}