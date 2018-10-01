#!/bin/bash


function setWindowSize() {
  local x=$1; shift
  local y=$1; shift

  printf "\033[8;${y};${x}t"
}

function clearWindow() {
  printf "\033c"
}

setWindowSize 80 24
clearWindow
