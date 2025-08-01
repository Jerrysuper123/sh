#!/bin/bash
# program to output a system page

TITLE="System information report for $HOSTNAME"
CURRENT_TIME=$(date +"%Y-%m-%d %H:%M:%S")
USER=$(whoami)
TIME_STAMP="Generated on $CURRENT_TIME, by $USER"

# upper case for constants
# lower case for variables
cat << _EOF_
<html>
         <head>
            <title>$TITLE</title>
        </head>
           <body>
                <h1>$TITLE</h1>
                <p>$TIME_STAMP</p>
            </body>
        </html>"
_EOF_