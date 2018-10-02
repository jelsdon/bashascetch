#!/bin/bash


shopt -s checkwinsize     # Gather window size
tput cnorm                # Hide cursor
stty -echo                # Hide user input

WIDTH=160
HEIGHT=48
MARK='X'
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
  tput cols
}

function getWindowHeight() {
  tput lines
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
  getWindowSize
  drawBoxCorner
  while [ $x_pos -lt $((WINDOW_WIDTH-2)) ]
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
  # Draw the top line
  tput cup 0 0
  drawBoxBar
  drawBoxSides
  drawBoxBar
}

function draw() {
  local pos_x=$((WINDOW_WIDTH/2))
  local pos_y=$((WINDOW_HEIGHT/2))

  # Hide cursor
  tput civis
  # Place cursor in middle of board
  tput cup ${pos_y} ${pos_x}
  echo -n ${MARK}
  tput cup ${pos_y} ${pos_x}
  while true
  do
    read -s -n 1 direction

   # ...There's a case for the below to be a case

    # Move left
    if [ "${direction}" == '1' ]
    then
      if [ $pos_x -gt 1 ]
      then
        let pos_x=pos_x-1
        tput cup ${pos_y} ${pos_x}
        echo -n ${MARK}
        # Put cursor in new pos -- check if there's a 
        # replace mode for this
        tput cup ${pos_y} ${pos_x}
      fi
    fi

    # Move right
    if [ "${direction}" == '2' ]
    then
      if [ $pos_x -lt $((WINDOW_WIDTH-2)) ]
      then
        let pos_x=pos_x+1
        tput cup ${pos_y} ${pos_x}
        echo -n ${MARK}
        # Put cursor in new pos -- check if there's a 
        # replace mode for this
        tput cup ${pos_y} ${pos_x}
      fi
    fi

    # Move down
    if [ "${direction}" == '9' ]
    then
      if [ $pos_y -lt $((WINDOW_HEIGHT-2)) ]
      then
        let pos_y=pos_y+1
        tput cup ${pos_y} ${pos_x}
        echo -n ${MARK}
        # Put cursor in new pos -- check if there's a 
        # replace mode for this
        tput cup ${pos_y} ${pos_x}
      fi
    fi

    # Move up
    if [ "${direction}" == '0' ]
    then
      if [ $pos_y -gt 1 ]
      then
        let pos_y=pos_y-1
        tput cup ${pos_y} ${pos_x}
        echo -n ${MARK}
        # Put cursor in new pos -- check if there's a 
        # replace mode for this
        tput cup ${pos_y} ${pos_x}
      fi
    fi

    # Shake up
    if [ "${direction}" == "" ]
    then
      clearWindow
      drawBorder

      # Hide cursor
      tput civis
    fi

  done
}

function cleanup() {
  clearWindow
  tput reset
  stty echo
}

trap cleanup EXIT
setWindowSize $WIDTH $HEIGHT
clearWindow
getWindowSize
drawBorder
draw
