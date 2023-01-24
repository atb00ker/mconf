#!/usr/bin/env python
# coding: utf-8

import json
import os
import sys

# DISPLAY_NAME = 'LVDS1'
DISPLAY_NAME = sys.argv[1]
shuffle_stack, active_stack, saved_stack = [], [], []

# Read files
try:
    with open('/tmp/i3mru-switch.stack', 'r') as file:
        saved_stack = file.read().split()
except:
    pass
i3config = os.popen("i3-msg -t get_tree").read()
i3config = json.loads(i3config)

# Get current active workspaces list
for node in i3config['nodes']:
    if node['name'] == DISPLAY_NAME:
        display = node
        break

for node in display['nodes']:
    if node['type'] == "con":
        workspaces = node
        break

for workspace in workspaces['nodes']:
    active_stack.append(workspace['name'])

# Create shuffle_stack
for space in saved_stack:
    if space in active_stack:
        shuffle_stack.append(space)

for space in active_stack:
    if space in active_stack and not space in shuffle_stack:
        shuffle_stack.append(space)

# Get the window
dmenu = "echo '{}' | rofi -width 10 -hide-scrollbar -bw 0 -no-fixed-num-lines \
                          -lines 7 -no-custom -sep ' ' -kb-accept-entry '!Alt-Tab' \
                          -kb-row-down Alt-Tab -dmenu".format(
    ' '.join([str(element) for element in shuffle_stack]))
selected = (os.popen(dmenu).read()).replace('\n', '')
os.system("i3-msg 'workspace    number {}'".format(selected))

# Save changed stack
if selected in shuffle_stack:
    shuffle_stack.remove(selected)
save_stack = [selected] + shuffle_stack
with open('/tmp/i3mru-switch.stack', 'w+') as file:
    file.write(' '.join(str(element) for element in save_stack))


'''
Alternative with the problem that it looks for windows not workspaces:
rofi -modi window -show window -hide-scrollbar -auto-select \
             -kb-cancel "Alt+Escape,Escape" \
             -kb-accept-entry "!Alt-Tab,!Alt+Alt_L,Return"\
             -kb-row-down "Alt+Tab,Alt+Down" \
             -kb-row-up "Alt+ISO_Left_Tab,Alt+Up" &
        xdotool search --sync --class Rofi keyup --delay 0 Tab &
        xdotool key --delay 0 Tab &
'''
