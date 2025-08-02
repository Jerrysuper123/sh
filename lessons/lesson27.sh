#!/bin/bash

x=5

if [ $x -eq 5 ]; then
    echo "x is equal to 5"
else
    echo "x is not equal to 5"
fi

test_file(){
    FILE="~/.bashrc"
    if [ -e $FILE ]; then
        if [ -f $FILE ]; then
            echo "$FILE is a regular file"
        fi
        if [-d $FILE ]; then
            echo "$FILE is a directory"
        fi
        else
            echo "$FILE does not exist"
            exit 1
    fi   
}

test_file