#!/bin/bash
sh build.sh
ssh carl@adahl.dyndns.org cat < deploy/stead.tar.bz2 ">" /home/carl/stead/stead.tar.bz2
