#!/bin/bash


shopt -s checkwinsize
WIDTH=80
HEIGHT=24
WINDOW_HEIGHT=""
WINDOW_WIDTH=""


function setWindowSize() {
  local x=$1; shift
  local y=$1; shift

  printf "\033[8;${y};${x}t"
}

function clearWindow() {
  printf "\033c"
}

function getWindowWidth() {
  echo $COLUMNS
}

function getWindowHeight() {
  echo $LINES
}

function getWindowSize() {
  (:) # Subshell sets $LINES and $COLUMNS
  WINDOW_WIDTH=$(getWindowWidth)
  WINDOW_HEIGHT=$(getWindowHeight)
}

setWindowSize $WIDTH $HEIGHT
clearWindow
getWindowSize
