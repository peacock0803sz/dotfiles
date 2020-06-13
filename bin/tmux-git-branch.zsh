#!/usr/bin/env zsh

cd $1
if [ `git status 2>&1 | tr '\n' ' ' | awk '{print $2}'` = 'branch' ]; then
  echo " "$(git status | grep "On branch" | awk '{print $3}')
else
  echo ""
fi
