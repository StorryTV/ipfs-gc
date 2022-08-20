#!/bin/bash
CURRENT_DIR=$(pwd)
IPFS_GC_TMP='/var/ipfs_gc/'
if [[ -d "${IPFS_GC_TMP}" ]]; then
	echo ''
else
	mkdir $IPFS_GC_TMP || command_failed=1
        if [ ${command_failed:-0} -eq 1 ]; then
		echo "Failed: mkdir ${IPFS_GC_TMP}"
		command_failed=0
	fi
fi
echo -n 'Do you want to run IPFS GC Automatically at a given schedule? (y/n) '
echo -n ': '
read VAR
if [[ $VAR = 'y' ]]; then
	echo ''
        echo -n 'Do you want to run IPFS GC hourly(h), daily(d), weekly(w) or monthly(m)? (h/d/w/m): '
	echo -n ': '
        read VAR
        if [[ $VAR = 'h' ]]; then
                VAR_1='0 * * * *'
        elif [[ $VAR = 'd' ]]; then
		echo ''
                echo -n 'At what hour? (Choose from 00 to 23): '
		echo -n ': '
                read VAR
                if [[ $VAR_ -lt 24 ]]; then
                        VAR_1="0 ${VAR} * * *"
                fi
        elif [[ $VAR = 'w' ]]; then
		echo ''
                echo -n 'What day of the week: Monday(1), Tuesday(2), Wednesday(3), Thursday(4), Friday(5), Saturday(6), Sunday(7)? (Choose from 1 to 7): '
		echo -n ': '
                read VAR
                if [[ $VAR -lt 8 ]]; then
			echo ''
                        echo -n 'At what hour? (Choose from 00 to 23): '
			echo -n ': '
                        read VAR_
                        if [[ $VAR_ -lt 24 ]]; then
                                VAR_1="0 ${VAR_} * * ${VAR}"
                        fi
                fi
        elif [[ $VAR = 'm' ]]; then
		echo ''
                echo -n 'What day of the month? (Choose from 1 to 28): '
		echo -n ': '
                read VAR
                if [[ $VAR -lt 32 ]]; then
			echo ''
                        echo -n 'At what hour? (Choose from 00 to 23): '
			echo -n ': '
                        read VAR_
                        if [[ $VAR_ -lt 24 ]]; then
                                VAR_1="0 ${VAR_} ${VAR} * *"
                        fi
                fi
        fi
	echo ''
        echo -n "Does your ipfs daemon run under the following user: $(whoami) (y/n): "
	echo -n ': '
	read VAR
	if [[ $VAR = 'y' ]]; then
		IPFS_GC_PARAMS_NAME="$(whoami)"
	elif [[ $VAR = 'n' ]]; then
		echo -n "Please enter the username the ipfs daemon runs under: "
		echo -n ': '
		read $VAR
		IPFS_GC_PARAMS_NAME=" -u ${VAR}"
	fi
	echo ''
        echo -n "Enter how much free space has to be left for IPFS GC to run (in Kilobytes/kb!): "
	echo -n ': '
	read VAR
	IPFS_GC_PARAMS_STORAGE=" -s ${VAR}"
	echo ''
        echo -n "Please enter the full path to the IPFS blocks for correct disk size calculations (if you have a standard IPFS setup you can just enter 'n') : "
	echo -n ': '
	read VAR
	if [[ $VAR = 'n' ]]; then
		IPFS_GC_PARAMS_PATHTOBLOCKS=''
	else
		IPFS_GC_PARAMS_PATHTOBLOCKS=" -p ${VAR}"
	fi
	IPFS_GC_CRONCMD="/usr/bin/ipfs-gc${IPFS_GC_PARAMS_NAME}${IPFS_GC_PARAMS_STORAGE}${IPFS_GC_PARAMS_PATHTOBLOCKS}"
        IPFS_GC_CRONJOB="${VAR_1} ${IPFS_GC_CRONCMD}"
        echo 'Installing Cronjob...'
        (( crontab -l | grep -v -F "${IPFS_GC_CRONCMD}" ; echo "${IPFS_GC_CRONJOB}" ) | crontab -) || command_failed=1
        if [ ${command_failed:-0} -eq 1 ]; then
                echo "Failed: mkdir (( crontab -l | grep -v -F ${IPFS_GC_CRONCMD} ; echo ${IPFS_GC_CRONJOB} ) | crontab -)"
                command_failed=0
        else
                echo 'Cronjob installed succesfully!'
        fi
fi
chmod 775 "${CURRENT_DIR}/ipfs-gc" || command_failed=1
if [ ${command_failed:-0} -eq 1 ]; then
        echo "Failed: chmod 775 \"${CURRENT_DIR}/ipfs-gc\""
        command_failed=0
fi
mv "${CURRENT_DIR}/ipfs-gc" /usr/bin/ || command_failed=1
if [ ${command_failed:-0} -eq 1 ]; then
        echo "Failed: mv \"${CURRENT_DIR}/ipfs-gc\" /usr/bin/"
        command_failed=0
else
        echo 'IPFS GC has been sucesfully installed! You can also run it manually by entering: ipfs-gc as root or using sudo: sudo ipfs-gc'
fi
