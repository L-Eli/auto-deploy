#!/bin/sh
AUTO_DEPLOY_DIR=`dirname $BASH_SOURCE[0]`
cd $AUTO_DEPLOY_DIR
CRON_SH_PATH="`pwd`/cron.sh"

echo "*******************************************************"
echo "*                                                     *"
echo "*  Name:    Auto Deploy                               *"
echo "*  Author:  Eli Lin                                   *"
echo "*  Version: 1.0.0                                     *"
echo "*  Date:    2019/11/14                                *"
echo "*                                                     *"
echo "*******************************************************"
echo ""


# Detecting directory
PROJECT_DIRECTORY=$1

if [ ! $PROJECT_DIRECTORY ]; then
  echo "Please enter project's path."
  exit
fi

cd $PROJECT_DIRECTORY


# Detecting version tag
VERSION_TAG=$2

git tag -a $VERSION_TAG -m "${VERSION_TAG}"
git push origin $VERSION_TAG

CRON_COMMAND="* ${CRON_SH_PATH} ${PROJECT_DIRECTORY} ${VERSION_TAG}"
(crontab -l | grep -v -F "$CRON_COMMAND") | crontab -
