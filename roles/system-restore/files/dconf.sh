#!/bin/bash

dconf load / < $1
dconf update
