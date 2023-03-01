#!/bin/bash

echo PASS=$password
echo FILE=$auth_control_file
(
	sleep 5
	if [ "$password" = "testyes" ]; then
		echo SUCCESS
		if [ -n "$auth_control_file" ]; then
			echo 1 >$auth_control_file
		fi
		exit 0
	fi

	echo FAIL
	if [ -n "$auth_control_file" ]; then
		echo 0 >$auth_control_file
	fi
	exit 1
)&
exit 2
