#! /usr/local/bin/bash

psql -v p=$PWD -f ./libraryDDL.sql
STATUS=$?
if [ $STATUS -ne 0 ]
  then exit 1
else
  echo "setup done"
fi