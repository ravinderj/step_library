#! /usr/local/bin/bash

psql -v p=$PWD -f ./libraryDDL.sql
STATUS=$?
if [ $STATUS -ne 0 ]
  then exit 1
  echo "setup failed"
else
  echo "setup done"
fi
