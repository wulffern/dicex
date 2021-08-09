#!/usr/bin/env python3
######################################################################
##        Copyright (c) 2021 Carsten Wulff Software, Norway
## ###################################################################
## Created       : wulff at 2021-8-10
## ###################################################################
##  The MIT License (MIT)
##
##  Permission is hereby granted, free of charge, to any person obtaining a copy
##  of this software and associated documentation files (the "Software"), to deal
##  in the Software without restriction, including without limitation the rights
##  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
##  copies of the Software, and to permit persons to whom the Software is
##  furnished to do so, subject to the following conditions:
##
##  The above copyright notice and this permission notice shall be included in all
##  copies or substantial portions of the Software.
##
##  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
##  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
##  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
##  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
##  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
##  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
##  SOFTWARE.
##
######################################################################
#

import pygame
import sys
import re
import os
import subprocess
pygame.init()

size = width, height = 800, 800
speed = [2, 2]
black = 0, 0, 0
white = (255,255,255)
red = 255,0,0
redvisited = 127,0,0
screen = pygame.display.set_mode(size)

clock = pygame.time.Clock()

#- Fill screen
maze = list()

with open("maze.txt","r") as fi:
    for line in fi:
        line = line.strip()
        slist = list()
        for s in line:
            slist.append(s)
        maze.append(slist)


M = len(slist)
N = len(maze)
if(M != N):
    raise Exception("Not a square %d %d" %(M,N))
screen.fill(white)

step = width/M

x = 0
y = 0
for l in maze:
    x=0
    for s in l:
        if(s == "1"):
            pygame.draw.rect(screen, black, pygame.Rect(x, y, step+1, step+1))
        x += step
    y += step


turtle = list()
with open("turtle.txt","r") as fi:
    for line in fi:
        xy = line.strip()
        sxy = re.split(",",line)
        x = (M - int(sxy[0]))*step - step
        y = int(sxy[1])*step
        turtle.append((x,y))

(x,y) = turtle[0]

plot = False
if(len(sys.argv)> 1):
    plot = True


filenamelist = [0]*len(turtle)
os.makedirs("pics", exist_ok=True)
i = 0
while 1:
    for event in pygame.event.get():
        if event.type == pygame.QUIT: sys.exit()

    if(i < len(turtle)):
        pygame.draw.rect(screen, redvisited,pygame.Rect(x,y,step+1,step+1))
        (x,y) = turtle[i]
        pygame.draw.rect(screen, red,pygame.Rect(x,y,step+1,step+1))

        if(plot):
            filenamelist[i] = "pics/pic" + str(i) + ".png"
            pygame.image.save(screen, filenamelist[i])
        else:
            clock.tick(50)
        pygame.display.flip()
        i+=1
    else:
        if(plot):
        #Combine into a GIF using ImageMagick's "convert"-command (called using subprocess.call()):
            convertexepath = "convert"  # Hardcoded
            convertcommand = [convertexepath, "-delay", "1", "-size", str(width) + "x" + str(height)] + filenamelist + ["maze.gif"]

            subprocess.call(convertcommand)

        #Remove the PNG files (if they were meant to be temporary):
            for filename in filenamelist:
                os.remove(filename)
        pass


    #Save as PNG images on disk:
