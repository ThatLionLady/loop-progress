#!/bin/sh

# assignment taken from external script

LIST=$1

# function for when list isn't given (starts with already assigned iterated progress number)

function progress_iteration () {

    source progress.tmp                                                                         # brings variables from temporary file into script
    PROGRESS=$((${PROGRESS} - 1))                                                               # calculates current progress
    echo "PROGRESS=${PROGRESS}" > progress.tmp                                                  # prints PROGRESS variable to temporary file (overwrites file)
    echo "COUNT=${COUNT}" >> progress.tmp                                                       # prints COUNT variable to temporary file
    PERCENT=$(echo "scale=4; (${COUNT} - ${PROGRESS}) / ${COUNT} * 100" | bc | cut -d . -f 1)   # calculates percentage of progress achieved
    
    if [ "${PERCENT}" -lt 10 ]; then

        echo -ne "           (${PERCENT}% complete (${PROGRESS}/${COUNT} remaining): $(date +'%m/%d/%Y %r')     \r"
 
    elif [ "${PERCENT}" -ge "10" ] && [ "${PERCENT}" -lt 20 ]; then
    
        echo -ne "#          (${PERCENT}% complete (${PROGRESS}/${COUNT} remaining): $(date +'%m/%d/%Y %r')     \r"

    elif [ "${PERCENT}" -ge 20 ] && [ "${PERCENT}" -lt 30 ]; then
    
        echo -ne "##         (${PERCENT}% complete (${PROGRESS}/${COUNT} remaining): $(date +'%m/%d/%Y %r')     \r"

    elif [ "${PERCENT}" -ge 30 ] && [ "${PERCENT}" -lt 40 ]; then
    
        echo -ne "###        (${PERCENT}% complete (${PROGRESS}/${COUNT} remaining): $(date +'%m/%d/%Y %r')     \r"

    elif [ "${PERCENT}" -ge 40 ] && [ "${PERCENT}" -lt 50 ]; then
    
        echo -ne "####       (${PERCENT}% complete (${PROGRESS}/${COUNT} remaining): $(date +'%m/%d/%Y %r')     \r"

    elif [ "${PERCENT}" -ge 50 ] && [ "${PERCENT}" -lt "60" ]; then
    
        echo -ne "#####      (${PERCENT}% complete (${PROGRESS}/${COUNT} remaining): $(date +'%m/%d/%Y %r')     \r"

    elif [ "${PERCENT}" -ge "60" ] && [ "${PERCENT}" -lt 70 ]; then
    
        echo -ne "######     (${PERCENT}% complete (${PROGRESS}/${COUNT} remaining): $(date +'%m/%d/%Y %r')     \r"

    elif [ "${PERCENT}" -ge 70 ] && [ "${PERCENT}" -lt 80 ]; then
    
        echo -ne "#######    (${PERCENT}% complete (${PROGRESS}/${COUNT} remaining): $(date +'%m/%d/%Y %r')     \r"

    elif [ "${PERCENT}" -ge 80 ] && [ "${PERCENT}" -lt 90 ]; then
    
        echo -ne "########   (${PERCENT}% complete (${PROGRESS}/${COUNT} remaining): $(date +'%m/%d/%Y %r')     \r"    

    elif [ "${PERCENT}" -ge 90 ] && [ "${PERCENT}" -lt 99 ]; then
    
        echo -ne "#########  (${PERCENT}% complete (${PROGRESS}/${COUNT} remaining): $(date +'%m/%d/%Y %r')     \r"

    else

        echo -ne "CONGRATULATIONS! Your analysis finished at $(date +'%m/%d/%Y %r')"
        echo ""
        echo ""
        echo "Thank you for using Loop-Progress :)"
        echo ""

    fi
}

# function for when a list is given (starts with count)

function progress_from_count () {

    echo ""
    echo "Monitoring Progress with ThatLionLady's Loop-Progress"
    echo "github.com/ThatLionLady/loop-progress"
    echo ""

    COUNT=$(cat ${LIST} | wc -l)                 # determines how many items are in the list
    PROGRESS=${COUNT}                            # sets PROGRESS variable as highest number
    echo "PROGRESS=${PROGRESS}" > progress.tmp   # prints PROGRESS variable to temporary file
    echo "COUNT=${COUNT}" >> progress.tmp        # prints COUNT variable to temporary file

    echo -ne "           (0% complete (${PROGRESS}/${COUNT} remaining): $(date +'%m/%d/%Y %r')     \r"

}

# determines which function will be used

# This script should be called twice within the external script.
# The first occurrence is outside the for loop calling the list.
# The second occurrence is inside the for loop calling "x". 

if [ "${LIST}" == "x" ]; then

    progress_iteration

else

    progress_from_count

fi