#!/bin/bash


shopt -s checkwinsize     # Gather window size
tput cnorm                # Hide cursor
stty -echo                # Hide user input

WIDTH=160
HEIGHT=48
MARK='X'
WINDOW_HEIGHT=""
WINDOW_WIDTH=""
CURSOR_X=0
CURSOR_Y=0

function clearWindow() {
  tput sgr0    # Reset 'pen'
  tput clear
}

function getWindowWidth() {
  tput cols
}

function getWindowHeight() {
  tput lines
}

function setWindowSize() {
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

  while [ $y_pos -lt $((WINDOW_HEIGHT-1)) ]
  do
    tput cup ${y_pos} 0
    drawBoxPipe
    tput cup ${y_pos} $WINDOW_WIDTH
    drawBoxPipe
    let y_pos=y_pos+1
  done
}

function drawGame() {
  setWindowSize
  # Determine game center
  CURSOR_X=$((WINDOW_WIDTH/2))
  CURSOR_Y=$((WINDOW_HEIGHT/2))
  clearWindow

  # Set border colour
  tput bold
  tput setaf 20
  tput setab 25

  # Move cursor to top left
  tput cup 0 0

  # Start drawing border
  drawBoxBar
  drawBoxSides
  drawBoxBar

  tput sgr0    # Reset 'pen'
  tput civis   # Hide cursor

  # Place cursor in middle of board
  tput cup ${CURSOR_Y} ${CURSOR_X}
  tput setab 255
  tput setaf 255
  echo -n ${MARK}
  tput cup ${CURSOR_Y} ${CURSOR_X}
}

function draw() {
  while true
  do
    read -s -n 1 direction

   # ...There's a case for the below to be a case

    # Move left
    if [ "${direction}" == '1' ]
    then
      if [ $CURSOR_X -gt 1 ]
      then
        let CURSOR_X=CURSOR_X-1
        tput cup ${CURSOR_Y} ${CURSOR_X}
        echo -n ${MARK}
        # Put cursor in new pos -- check if there's a 
        # replace mode for this
        tput cup ${CURSOR_Y} ${CURSOR_X}
      fi
    fi

    # Move right
    if [ "${direction}" == '2' ]
    then
      if [ $CURSOR_X -lt $((WINDOW_WIDTH-2)) ]
      then
        let CURSOR_X=CURSOR_X+1
        tput cup ${CURSOR_Y} ${CURSOR_X}
        echo -n ${MARK}
        # Put cursor in new pos -- check if there's a 
        # replace mode for this
        tput cup ${CURSOR_Y} ${CURSOR_X}
      fi
    fi

    # Move down
    if [ "${direction}" == '9' ]
    then
      if [ $CURSOR_Y -lt $((WINDOW_HEIGHT-2)) ]
      then
        let CURSOR_Y=CURSOR_Y+1
        tput cup ${CURSOR_Y} ${CURSOR_X}
        echo -n ${MARK}
        # Put cursor in new pos -- check if there's a 
        # replace mode for this
        tput cup ${CURSOR_Y} ${CURSOR_X}
      fi
    fi

    # Move up
    if [ "${direction}" == '0' ]
    then
      if [ $CURSOR_Y -gt 1 ]
      then
        let CURSOR_Y=CURSOR_Y-1
        tput cup ${CURSOR_Y} ${CURSOR_X}
        echo -n ${MARK}
        # Put cursor in new pos -- check if there's a 
        # replace mode for this
        tput cup ${CURSOR_Y} ${CURSOR_X}
      fi
    fi

    # Shake up
    if [ "${direction}" == "" ]
    then
      tput sgr0    # Reset 'pen'
      clearWindow
      drawGame
    fi

  done
}

function cleanup() {
  clearWindow
  tput reset
  stty echo
}

trap cleanup EXIT
trap drawGame SIGWINCH
drawGame
draw
