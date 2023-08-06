#!/bin/bash

# Check if the first argument is "sync"
if [ "$1" == "sync" ]; then
    if [ "$2" == "db" ]; then
        echo "Syncing database"
        exit 1
    fi
    if [ "$2" == "files" ]; then
        echo "Syncing files"
        exit 1
    fi
    if [ "$2" == "all" ]; then
        echo "Syncing files and database"
        exit 1
    fi

#elif [ "$1" == "stop" ]; then
#    echo "Stopping the program..."
else
    echo "Unknown command: $1"
fi
