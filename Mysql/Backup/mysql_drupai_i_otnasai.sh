#!/bin/bash
######################################
# Create Backup every night in 00:00 #
#         by V.Varbanovski           #
######################################

# Dump mysql bases.
user=your_username
pass=your_password
# All bases with content
#mysqldump -u $user -p$pass --opt --all-databases | gzip > /your/path/to/save/all_$(date "+%Y-%m-%d").sql.gz
# Without content
# mysqldump -u $user -p$pass --no-data base1 | gzip > /your/path/to/save/base1$(date "+%Y-%m-%d").sql.gz
mysqldump -u $user -p$pass base1 | gzip > /your/path/to/save/base1$(date "+%Y-%m-%d").sql.gz
mysqldump -u $user -p$pass base2 | gzip > /your/path/to/save/base2$(date "+%Y-%m-%d").sql.gz
mysqldump -u $user -p$pass base3 | gzip > /your/path/to/save/base3$(date "+%Y-%m-%d").sql.gz
mysqldump -u $user -p$pass base4 | gzip > /your/path/to/save/base4$(date "+%Y-%m-%d").sql.gz
mysqldump -u $user -p$pass base5 | gzip > /your/path/to/save/base5$(date "+%Y-%m-%d").sql.gz

# Single without data
mysqldump -u $user -p$pass --no-data base | gzip > /your/path/to/save/base$(date "+%Y-%m-%d").sql.gz

exit 0;
