#!/bin/bash

dconf load /com/gexperts/Tilix/ < $1
dconf update
