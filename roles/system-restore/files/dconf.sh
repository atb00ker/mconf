#!/bin/bash

dconf load /org/gnome/ < $1
dconf update
