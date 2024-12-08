import pygame
from graphics.colors import *


class expantablePanel:
    def __init__(self, screen, widgets = [], startCollapsed = False, COLLAPSED_RELATIVE_WIDTH = 0.01, EXPANDED_RELATIVE_WIDTH = 0.2, COLLAPSED_RELATIVE_HEIGHT = 1, EXPANDED_RELATIVE_HEIGHT = 1, RELATIVE_X = 0, RELATIVE_Y = 0):
        self.COLLAPSED_RELATIVE_HEIGHT = COLLAPSED_RELATIVE_HEIGHT
        self.COLLAPSED_RELATIVE_WIDTH = COLLAPSED_RELATIVE_WIDTH
        self.EXPANDED_RELATIVE_HEIGHT = EXPANDED_RELATIVE_HEIGHT
        self.EXPANDED_RELATIVE_WIDTH = EXPANDED_RELATIVE_WIDTH
        self.RELATIVE_X = RELATIVE_X
        self.RELATIVE_Y = RELATIVE_Y
        if startCollapsed:  
            self.width = screen.get_width()*COLLAPSED_RELATIVE_WIDTH
            self.height = screen.get_height()*COLLAPSED_RELATIVE_HEIGHT
            self.collapsed = True
        else:
            self.width = screen.get_width()*EXPANDED_RELATIVE_WIDTH
            self.height = screen.get_height()*EXPANDED_RELATIVE_HEIGHT
            self.collapsed = False

        self.surface = pygame.Surface((self.width, self.height))
        self.widgets = widgets

    def update(self, screen, events):
        pass

    def draw(self, screen):
        pass

class Button:
    def __init__(self, RELATIVE_WIDTH = [0.5], RELATIVE_HEIGHT=[0.5], RELATIVE_X = 0, RELATIVE_Y = 0, ):
        self.isHovered = False
        self.isDown = False

    def draw(surface):
        pass

    def update(surface, events):
        pass