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

function drawBoxCorner() {
  echo -n '+'
}

function drawBoxDash() {
  echo -n '-'
}

function drawBoxPipe() {
  echo -n '|'
}

function drawBoxBar() {
  local x_pos=0
  local y_pos=0
  local window_width=$WINDOW_WIDTH
  drawBoxCorner
  let window_width=window_width-2
  while [ $x_pos -lt $window_width ]
  do
    drawBoxDash
    let x_pos=x_pos+1
  done	
  drawBoxCorner
}

function drawBoxSides() {
  local y_pos=1
  getWindowSize

  while [ $y_pos -lt $((WINDOW_HEIGHT-1)) ]
  do
    tput cup ${y_pos} 0
    drawBoxPipe
    tput cup ${y_pos} $WINDOW_WIDTH
    drawBoxPipe
    let y_pos=y_pos+1
  done
}

function drawBorder() {
  local x_pos=0
  local y_pos=0
  # Draw the top line
  tput cup ${y_pos} ${x_pos}
  drawBoxBar
  drawBoxSides
  drawBoxBar

}

setWindowSize $WIDTH $HEIGHT
clearWindow
getWindowSize
drawBorder
sleep 10
