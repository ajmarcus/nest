#!/bin/sh

DIR="$( cd "$( dirname "$0" )" && pwd )"

git add *
git commit -a -m "$1"
git push origin master

sh $DIR/deploy.sh
