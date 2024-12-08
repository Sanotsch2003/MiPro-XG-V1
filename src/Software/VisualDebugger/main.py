import pygame
import sys
from graphics.UI import Button, Window
from graphics.settings import *
from graphics.colors import *

# Initialize Pygame
pygame.init()

def helloWorld():
    print("Hello World")

# Initialize the main screen
window = Window(SCREEN_WIDTH, SCREEN_HEIGHT)

btn1 = Button(RELATIVE_REFERENCE="Height", onPress=None, onRelease=helloWorld)
btn2 = Button(BACKGROUND_COLOR=[BLUE, LIGHT_BLUE, RED], RELATIVE_REFERENCE="Width", onPress=None, onRelease=None)
btn1.addWidget(btn2)
window.addWidget(btn1)

pygame.display.set_caption("Visual Debugger")


# Clock for controlling the frame rate
clock = pygame.time.Clock()

# Main game loop
running = True
while running:
    events = pygame.event.get()
    for event in events:
        if event.type == pygame.QUIT:
            running = False
        if event.type ==pygame.VIDEORESIZE:
            window.resize()
    
    window.draw()
    window.update(events=events)

    clock.tick(FPS)

# Quit Pygame
pygame.quit()
sys.exit()
