#!/bin/bash


shopt -s checkwinsize     # Gather window size
tput cnorm                # Hide cursor
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

function draw() {
  local pos_x=$((WINDOW_WIDTH/2))
  local pos_y=$((WINDOW_HEIGHT/2))

  # Place cursor in middle of board
  tput cup ${pos_y} ${pos_x}
  echo -n X
  tput cup ${pos_y} ${pos_x}
  while true
  do
    read -s -n 1 direction

   # ...There's a case for the below to be a case

    # Move left
    if [ $direction == '1' ]
    then
      if [ $pos_x -gt 1 ]
      then
        let pos_x=pos_x-1
        tput cup ${pos_y} ${pos_x}
        echo -n X
        # Put cursor in new pos -- check if there's a 
        # replace mode for this
        tput cup ${pos_y} ${pos_x}
      fi
    fi

    # Move right
    if [ $direction == '2' ]
    then
      if [ $pos_x -lt $((WINDOW_WIDTH-2)) ]
      then
        let pos_x=pos_x+1
        tput cup ${pos_y} ${pos_x}
        echo -n X
        # Put cursor in new pos -- check if there's a 
        # replace mode for this
        tput cup ${pos_y} ${pos_x}
      fi
    fi

  done
}

function cleanup() {
  clearWindow
  tput reset
}

trap cleanup EXIT
setWindowSize $WIDTH $HEIGHT
clearWindow
getWindowSize
drawBorder
draw
