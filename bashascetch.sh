#!/bin/bash

WIDTH=80
HEIGHT=24

function setWindowSize() {
  local x=$1; shift
  local y=$1; shift

  printf "\033[8;${y};${x}t"
}

function clearWindow() {
  printf "\033c"
}

setWindowSize $WIDTH $HEIGHT
clearWindow
