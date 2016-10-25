#!/bin/bash
if [ ! -e syncconfig.ini ]
then
  echo "You need to execute this in the directory that contains syncconfig.ini"
  exit 1
fi
ytag=$(cat syncconfig.ini | grep "ytagbase" | cut -d'=' -f 2)

nsfiles=$(mongo --quiet upmu_database --eval "db.received_files.find({\"ytag\":52}).count()")
nfiles=$(mongo --quiet upmu_database --eval "db.received_files.find().count()")

if [ $nsfiles -gt 0 ]
then
  echo "There are approximately $nsfiles out of $nfiles received files that are safe to delete"
  read -p "Type 'delete' to proceed>" confirm
  if [ "$confirm" = "delete" ]
  then
    echo "Deleting"
    mongo --quiet upmu_database --eval "db.received_files.remove({\"ytag\":$ytag})"
    echo "Done"
  else
    echo "Aborting! No files deleted"
  fi
else
  echo "No files are safe to delete (there are $nfiles total files)"
fi
