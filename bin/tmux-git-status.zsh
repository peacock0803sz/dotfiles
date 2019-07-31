#!/usr/bin/env zsh

STATUS=""
UNTRACKED="?"
ADDED="+"
MODIFIED="!"
RENAMED="»"
DELETED="✘"
STASHED="$"
UNMERGED="="
AHEAD="⇡"
BEHIND="⇣"
DIVERGED="⇕"

cd $1
if [ `git status 2>&1 | tr '\n' ' ' | awk '{print $2}'` = 'branch' ]; then
  if [ `git status --untracked-file=all --porcelain | grep '??' | tr "\n" " " | awk '{print $1}'` = '??' ]; then
    STATUS=$UNTRACKED$STATUS
  fi
  if [ `git status --untracked-file=all --porcelain | grep 'A' | tr "\n" " " | awk '{print $1}'` = 'A' ]; then
    STATUS=$ADDED$STATUS
  fi
  if [ `git status --untracked-file=all --porcelain | grep 'M' | tr "\n" " " | awk '{print $1}'` = 'M' ]; then
    STATUS=$MODIFIED$STATUS
  fi
  if [ `git status --untracked-file=all --porcelain | grep 'R' | tr "\n" " " | awk '{print $1}'` = 'R' ]; then
    STATUS=$RENAMED$STATUS
  fi
  if [ `git status --untracked-file=all --porcelain | grep 'D' | tr "\n" " " | awk '{print $1}'` = 'D' ]; then
    STATUS=$DELETED$STATUS
  fi
  if [ `git rev-parse --verify refs/stash 2>&1` != 'fatal: Needed a single revision' ]; then
    STATUS=$STASHED$STATUS
  fi
  if [ `git status --untracked-file=all --porcelain | grep 'U' | tr "\n" " " | awk '{print $1}'` = 'U' ]; then
    STATUS=$UNMERGED$STATUS
  fi
  if [ `git status --untracked-file=all --porcelain -b | grep 'ahead' | tr "\n" " " | awk '{print $3}'` = '[ahead' ]; then
    STATUS=$AHEAD$STATUS
  fi
  if [ `git status --untracked-file=all --porcelain -b | grep 'behind' | tr "\n" " " | awk '{print $3}'` = '[behind' ]; then
    STATUS=$BEHIND$STATUS
  fi
  if [ `git status --untracked-file=all --porcelain | grep '' | tr "\n" " " | awk '{print $1}'` = '' ]; then
    STATUS=$DIVERGED$STATUS
  fi
  echo "["$STATUS"]"
fi
