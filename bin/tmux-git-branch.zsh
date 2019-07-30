#!/usr/bin/env zsh

cd $1
if [ -e .git ]; then
  echo " "$(git status | grep "On branch" | awk '{print $3}')
else
  echo "Not a git repository."
fi
