from graphics.settings import *
from graphics.colors import *
import pygame

def checkMouseIntersect(relativeMousePos, relativePos, relativeWidth, relativeHeight):
    topLeftX = relativePos[0] - relativeWidth/2
    topLeftY = relativePos[1] - relativeHeight/2

    if relativeMousePos[0] > topLeftX and relativeMousePos[0] < topLeftX+relativeWidth and relativeMousePos[1] > topLeftY and relativeMousePos[1] < topLeftY + relativeHeight:
        return True
    else:
        return False

