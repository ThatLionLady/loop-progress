#!/bin/sh

LIST=test.list

bash loop-progress.sh ${LIST}

for THING in $(<${LIST}); do
	sleep 1
	bash loop-progress.sh x
done

