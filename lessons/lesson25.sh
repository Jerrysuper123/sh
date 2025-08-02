#!/bin/bash
# program to output a system page

TITLE="System information report for $HOSTNAME"
CURRENT_TIME=$(date +"%Y-%m-%d %H:%M:%S")
USER=$(whoami)
TIME_STAMP="Generated on $CURRENT_TIME, by $USER"

# upper case for constants
# lower case for variables

report_uptime(){
cat << _EOF_
    <h2>Uptime Report</h2>
    <pre>Uptime: $(uptime)</pre>
_EOF_
    return
}

report_disk_space(){
cat << _EOF_
    <h2>disk space Report</h2>
    <pre>$(df -h)</pre>
_EOF_
    return
}

report_home_space(){
    if [["$(id -u)" -eq 0 ]]; then
cat << _EOF_
    <h2>home space</h2>
    <pre>$(du -sh /home/*)</pre>
_EOF_
    else
cat << _EOF_
    <h2>home space</h2>
    <pre>$(du -sh /home/*)</pre>
_EOF_

    fi
    return
}

cat << _EOF_
<html>
         <head>
            <title>$TITLE</title>
        </head>
           <body>
                <h1>$TITLE</h1>
                <p>$TIME_STAMP</p>
                $(report_uptime)
                $(report_disk_space)
                $(report_home_space)
            </body>
        </html>"
_EOF_