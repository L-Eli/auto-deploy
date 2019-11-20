#!/bin/sh
WORKING_DIR=`pwd`
AUTO_DEPLOY_DIR=`dirname $BASH_SOURCE[0]`
cd $AUTO_DEPLOY_DIR
CRON_SH_PATH="`pwd`/cron.sh"

# Detecting directory
directory=$1

if [ ! $directory ]; then
  echo "Please enter project's path."
  exit
fi

if [ ! -d $directory ]; then
  directory="${WORKING_DIR}${directory}"
  if [ ! -d $directory ]; then
    echo "Project not found."
    exit
  fi
elif [ $directory == "." ]; then
  directory="${WORKING_DIR}"
fi

cd $directory
PROJECT_DIRECTORY=`pwd`


# Detecting deploy time
deploy_time=$2

if [ ! $deploy_time ]; then
  deploy_time=`date '+%m-%d,%H:%M'`
fi

date_time=(`date -j -f '%m-%d,%H:%M' "$deploy_time" +'%m %d %H %M'`)
MONTH="${date_time[0]}"
DAY="${date_time[1]}"
HOUR="${date_time[2]}"
MINUTE="${date_time[3]}"


# Detecting version tag
VERSION_TAG=$3

CRON_COMMAND="* ${CRON_SH_PATH} ${PROJECT_DIRECTORY} ${VERSION_TAG}"
CRON_JOB="${MINUTE} ${HOUR} ${DAY} ${MONTH} $CRON_COMMAND"

(crontab -l | grep -v -F "$CRON_COMMAND" ; echo "$CRON_JOB") | crontab -
