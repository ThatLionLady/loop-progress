#!/bin/bash

LIST=test.list

loop-progress ${LIST}

for THING in $(<${LIST}); do
	sleep 1
	loop-progress x
done

