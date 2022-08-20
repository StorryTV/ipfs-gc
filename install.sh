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
echo -n 'Do you want to run IPFS GC Automatically at a given schedule? (y/n): '
read VAR
if [[ $VAR = 'y' ]]; then
        echo -n 'Do you want to run IPFS GC hourly(h), daily(d), weekly(w) or monthly(m)? (h/d/w/m): '
        read VAR
        if [[ $VAR = 'h' ]]; then
                VAR_1='0 * * * *'
        elif [[ $VAR = 'd' ]]; then
                echo -n 'At what hour? (Choose from 00 to 23): '
                read VAR_
                if [[ $VAR_ -lt 24 ]]; then
                        VAR_1="0 ${VAR_} * * *"
                fi
        elif [[ $VAR = 'w' ]]; then
                echo -n 'What day of the week: Monday(1), Tuesday(2), Wednesday(3), Thursday(4), Friday(5), Saturday(6), Sunday(7)? (Choose from 1 to 7): '
                read VAR_
                if [[ $VAR_ -lt 8 ]]; then
                        echo -n 'At what hour? (Choose from 00 to 23): '
                        read VAR__
                        if [[ $VAR__ -lt 24 ]]; then
                                VAR_1="0 ${VAR__} * * ${VAR_}"
                        fi
                fi
        elif [[ $VAR = 'm' ]]; then
                echo -n 'What day of the month? (Choose from 1 to 28): '
                read VAR_
                if [[ $VAR_ -lt 32 ]]; then
                        echo -n 'At what hour? (Choose from 00 to 23): '
                        read VAR__
                        if [[ $VAR__ -lt 24 ]]; then
                                VAR_1="0 ${VAR__} ${VAR_} * *"
                        fi
                fi
        fi
        IPFS_GC_CRONCMD="/usr/bin/ipfs-gc"
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
