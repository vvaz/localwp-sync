#!/bin/bash

WPPath=--path=public/

while read line; do    
    declare $line    
done < variables.dat

echo "o seu site é $siteName e o IP é $ipRuncloud"

exit 0