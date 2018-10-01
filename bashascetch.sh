#!/bin/bash


function setWindowSize() {
  local x=$1; shift
  local y=$1; shift

  printf "\033[8;${y};${x}t"
}

setWindowSize 80 24
