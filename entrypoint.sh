#!/bin/bash
if [ $# -eq 0 ]; then
	/usr/games/fortune -a | cowsay
else
	cowsay "$@"
fi

