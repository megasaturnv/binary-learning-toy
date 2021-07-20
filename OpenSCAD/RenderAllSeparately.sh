#!/bin/bash

# By MegaSaturnv 2021-07-01

startTime="$(date +%s)"



openscad -q -o "Binary_Display_Toy_BoxLid.stl"       -D "RENDER_BOX_BASE=false" -D "RENDER_BOX_LID=true"  -D "RENDER_DISPLAY_LID=false" -D "RENDER_TP4056_LID=false" -D "RENDER_ARDUINO_LID=false" "Binary_Display_Toy.scad"
echo "BoxLid done"

openscad -q -o "Binary_Display_Toy_DisplayLid.stl"   -D "RENDER_BOX_BASE=false" -D "RENDER_BOX_LID=false" -D "RENDER_DISPLAY_LID=true"  -D "RENDER_TP4056_LID=false" -D "RENDER_ARDUINO_LID=false" "Binary_Display_Toy.scad"
echo "DisplayLid done"

openscad -q -o "Binary_Display_Toy_BoxTP4056Lid.stl" -D "RENDER_BOX_BASE=false" -D "RENDER_BOX_LID=false" -D "RENDER_DISPLAY_LID=false" -D "RENDER_TP4056_LID=true"  -D "RENDER_ARDUINO_LID=false" "Binary_Display_Toy.scad"
echo "TP4056Lid done"

openscad -q -o "Binary_Display_Toy_ArduinoLid.stl"   -D "RENDER_BOX_BASE=false" -D "RENDER_BOX_LID=false" -D "RENDER_DISPLAY_LID=false" -D "RENDER_TP4056_LID=false" -D "RENDER_ARDUINO_LID=true"  "Binary_Display_Toy.scad"
echo "ArduinoLid done"

openscad -q -o "Binary_Display_Toy_BoxBase.stl"      -D "RENDER_BOX_BASE=true"  -D "RENDER_BOX_LID=false" -D "RENDER_DISPLAY_LID=false" -D "RENDER_TP4056_LID=false" -D "RENDER_ARDUINO_LID=false" "Binary_Display_Toy.scad"
echo "BoxBase done"



endTime="$(date +%s)"
echo "seconds taken to render: $(($endTime - $startTime))"
#echo "seconds taken to render: $((endTime - startTime))"
