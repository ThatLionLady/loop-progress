# ThatLionLady's Loop-Progress
 
This script is for monitoring the progress of a for loop that otherwise doesn't have any terminal output to tell you where your analysis is at.

- [Installation](#installation)
- [Requirements](#requirements)
- [Usage](#usage)
- [Testing Testing 1, 2, 3](#testing-testing-1-2-3)
- [Detailed Description](#detailed-description)
  - [***FYI***](#fyi)

# Installation

Clone it!

```sh
git clone https://github.com/ThatLionLady/loop-progress.git
```

# Requirements

- `loop-progress.sh` from this repository
- a file with a list of what your for loop will run through (ex. `test.list`)
- your script with a for loop (ex. `test.sh`)

# Usage

The `loop-progress.sh` script should be called twice within the your script.  
(*See [Detailed Description](#detailed-description) for the explanation why.*)
1. outside the for loop calling your list
2. inside the for loop calling x

Your *very simplified* script should look something like this:

```sh
#!/bin/sh

LIST=Path/to/Your.list

bash loop-progress.sh ${LIST}

for THING in $(<${LIST}); do
	command
	bash loop-progress.sh x
done
```

# Testing Testing 1, 2, 3

If you want to see what it looks like before you commit to putting it into your own script:
- Run the `test.sh` script from the loop-progress directory. 
  - It should look like this:

![Alt Text](test.gif)

# Detailed Description

This script should be called twice within the your script.
1. The first occurrence is outside the for loop calling your list.
   - This calls a function that starts by counting the number of items in your list and sets the initial progress number at that number.
        - Your script:
  
        ```sh
        #!/bin/sh

        LIST=Path/to/Your.list

        bash loop-progress.sh ${LIST}
        ```
        - This script:

        ```sh
        function progress_from_count () {

            COUNT=$(cat ${LIST} | wc -l)
            PROGRESS=${COUNT}
            echo "PROGRESS=${PROGRESS}" > progress.tmp
            echo "COUNT=${COUNT}" >> progress.tmp

            echo -ne "           (0% complete (${PROGRESS}/${COUNT} remaining): $(date +'%m/%d/%Y %r')     \r"

        }
        ```

2. The second occurrence is inside the for loop calling "x".
   - This calls a function that starts by sourcing the progress number in a temporary file calculated during the previous call.
   - This will run through as part of your for loop until the progress reaches "0" and it congratulates you that your for loop is complete.
        - Your script:
  
        ```sh
        for THING in $(<${LIST}); do
	        command
	        bash loop-progress.sh x
        done
        ```

        - This script:

        ```sh
        function progress_iteration () {

            source progress.tmp
            PROGRESS=$((${PROGRESS} - 1))
            echo "PROGRESS=${PROGRESS}" > progress.tmp
            echo "COUNT=${COUNT}" >> progress.tmp
            PERCENT=$(echo "scale=4; (${COUNT} - ${PROGRESS}) / ${COUNT} * 100" | bc | cut -d . -f 1)
    
            if elif ... else 

            echo -ne "CONGRATULATIONS! Your analysis finished at $(date +'%m/%d/%Y %r')"

        fi
        ```

The `if elif else` statement determines what to print in the terminal based on the calculated percentage completed. For example:

```sh
elif [ "${PERCENT}" -ge 20 ] && [ "${PERCENT}" -lt 30 ]; then
    
    echo -ne "##         (${PERCENT}% complete (${PROGRESS}/${COUNT} remaining): $(date +'%m/%d/%Y %r')     \r"
```

To break it down:
- `elif [ "${PERCENT}" -ge 20 ] && [ "${PERCENT}" -lt 30 ]; then` = if the calculated percentage is greater than or equal to 20 and less than 30 (between 20 and 29.99...) then
- `echo -ne` = print to the terminal without a trailing newline (a.k.a. a line break) while interpreting backslash-escaped characters
- `"##         ${PERCENT}% complete (${PROGRESS}/${COUNT} remaining): $(date +'%m/%d/%Y %r')     \r"` = what will be printed to the terminal
  - `##         ` = progress bar
  - `${PERCENT}% complete` = calculated percentage complete
  - `(${PROGRESS}/${COUNT} remaining)` = calculated progress of total count remaining
  - `$(date +'%m/%d/%Y %r')` = date in month/day/year format followed by 12-hour clock time
  - `     \r` = overwrite buffer with a carriage return
    - This (in combination with `-ne`) is needed to overwrite the previously printed line and make the appearance of a progress bar.

## ***FYI*** 
To see the importance of the echo flags I used and have a better understanding if you want to make your own changes (e.g. if you want to keep when each loop is finished (i.e. no line replacement)):

- removing `\r` prints on one line like this:

    ```
               0% complete (26/26 remaining): 06/23/2022 11:46:49 PM                3% complete (25/26 remaining): 06/23/2022 11:46:50 PM                7% complete (24/26 remaining): 06/23/2022 11:46:51 PM     #          11% complete (23/26 remaining): 06/23/2022 11:46:52 PM     #          15% complete (22/26 remaining): 06/23/2022 11:46:53 PM
    ```

- removing the `n` flag from `echo` prints like this:

    ```
               0% complete (26/26 remaining): 06/23/2022 11:41:30 PM
               3% complete (25/26 remaining): 06/23/2022 11:41:31 PM
               7% complete (24/26 remaining): 06/23/2022 11:41:32 PM
    #          11% complete (23/26 remaining): 06/23/2022 11:41:33 PM
    #          15% complete (22/26 remaining): 06/23/2022 11:41:34 PM
    ```

- removing the `e` flag from `echo` prints on one line like this:

    ```
               0% complete (26/26 remaining): 06/23/2022 11:52:42 PM     \r           3% complete (25/26 remaining): 06/23/2022 11:52:43 PM     \r           7% complete (24/26 remaining): 06/23/2022 11:52:44 PM     \r#          11% complete (23/26 remaining): 06/23/2022 11:52:45 PM     \r#          15% complete (22/26 remaining): 06/23/2022 11:52:46 PM     \r^
    ```

- removing both `-ne` but leaving `\r` prints like this:

    ```
               0% complete (26/26 remaining): 06/23/2022 11:54:00 PM     \r
               3% complete (25/26 remaining): 06/23/2022 11:54:01 PM     \r
               7% complete (24/26 remaining): 06/23/2022 11:54:02 PM     \r
    #          11% complete (23/26 remaining): 06/23/2022 11:54:03 PM     \r
    #          15% complete (22/26 remaining): 06/23/2022 11:54:04 PM     \r
    ```

- removing `-ne` and `\r` prints like this:

    ```
               0% complete (26/26 remaining): 06/23/2022 11:55:53 PM
               3% complete (25/26 remaining): 06/23/2022 11:55:54 PM
               7% complete (24/26 remaining): 06/23/2022 11:55:55 PM
    #          11% complete (23/26 remaining): 06/23/2022 11:55:56 PM
    #          15% complete (22/26 remaining): 06/23/2022 11:55:57 PM
    ```
