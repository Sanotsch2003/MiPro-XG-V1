import pygame
from graphics.colors import *
from graphics.utils import checkMouseIntersect

def press():
    print("pressed")

def release():
    print("released")

class Window:
    def __init__(self, SCREEN_WIDTH, SCREEN_HEIGHT, BACKGROUND_COLOR=PURPLE):
        self.surface  = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT), pygame.RESIZABLE)
        self.backgroundColor = BACKGROUND_COLOR
        self.widgets = []
        self.events = []

    def addWidget(self, widget):
        self.widgets.append(widget)

    def resize(self):
        for widget in self.widgets:
            widget.resize(parent = self)

    def update(self, events):
        self.events = events
        for widget in self.widgets:
            widget.update(parent = self)

    def draw(self):
        # Fill the main screen (background)
        self.surface.fill(self.backgroundColor)
        for widget in self.widgets:
            widget.draw(parent = self)
        pygame.display.flip()

    def _getRelativeMousePos(self, relativeReference = "Width"):
        mouseX, mouseY = pygame.mouse.get_pos()
        absolutWindowWidth = self.surface.get_width()
        absolutWindowHeight = self.surface.get_height()
        if relativeReference == "Width":
            relativeX = mouseX/absolutWindowWidth
            relativeY = mouseY/absolutWindowWidth
        elif relativeReference == "Height":
            relativeX = mouseX/absolutWindowHeight
            relativeY = mouseY/absolutWindowHeight
        else:
            relativeY = mouseX/absolutWindowWidth
            relativeX = mouseY/absolutWindowHeight

        return relativeX, relativeY
    



class Button:
    def __init__(self, RELATIVE_WIDTH = [0.5, 0.6], RELATIVE_HEIGHT=[0.5, 0.6], RELATIVE_X = [0.5], RELATIVE_Y = [0.5], RELATIVE_BORDER_WIDTH = [0.015, 0.015], BORDER_COLOR=[BLACK], BACKGROUND_COLOR = [RED, GREEN, PINK], TEXT=["button normal", "button hovered", "button pressed"], TEXT_COLOR=[BLACK], RELATIVE_REFERENCE = "Width", onPress=press, onRelease=release):

        self.RELATIVE_WIDTH = self._listToStateDict(RELATIVE_WIDTH)
        self.RELATIVE_HEIGHT = self._listToStateDict(RELATIVE_HEIGHT)
        self.RELATIVE_X = self._listToStateDict(RELATIVE_X)
        self.RELATIVE_Y = self._listToStateDict(RELATIVE_Y)
        self.RELATIVE_BORDER_WIDTH = self._listToStateDict(RELATIVE_BORDER_WIDTH)
        self.BORDER_COLOR = self._listToStateDict(BORDER_COLOR)
        self.BACKGROUND_COLOR = self._listToStateDict(BACKGROUND_COLOR)
        self.TEXT = self._listToStateDict(TEXT)
        self.TEXT_COLOR = self._listToStateDict(TEXT_COLOR)

        self.onPress = onPress
        self.onRelease = onRelease

        self.RELATIVE_REFERENCE = RELATIVE_REFERENCE
        self.state = 'normal'
        self.widgets = []

        self.surface = pygame.Surface((1,1))
        self.relativeMousePosOfParent = None

        self.events = []

        self.mouseBtnDown = False

        

    def draw(self, parent):
        self.surface.fill(self.BORDER_COLOR[self.state])
        absoluteBorderWidth = self.RELATIVE_BORDER_WIDTH[self.state]*self.surface.get_width()
        absoluteWidth = self.surface.get_width() - 2*absoluteBorderWidth
        absoluteHeight = self.surface.get_height() - 2*absoluteBorderWidth
        innerRect = pygame.Rect(0+absoluteBorderWidth, 0+absoluteBorderWidth, absoluteWidth, absoluteHeight)
        pygame.draw.rect(self.surface, self.BACKGROUND_COLOR[self.state], innerRect)

        # Render the text
        fontSize = int(min(absoluteHeight, absoluteHeight) // 5)  # Scaled font size
        font = pygame.font.SysFont("Arial", fontSize)
        textSurface = font.render(self.TEXT[self.state], True, self.TEXT_COLOR[self.state])

        centerX = absoluteWidth * 0.5
        centerY = absoluteHeight * 0.5
        # Center the text
        textRect = textSurface.get_rect(center=(centerX, centerY))
        self.surface.blit(textSurface, textRect)

        for widget in self.widgets:
            widget.draw(parent = self)

        if self.RELATIVE_REFERENCE == "Width":
            x = parent.surface.get_width() * self.RELATIVE_X[self.state]
            y = parent.surface.get_width() * self.RELATIVE_X[self.state]
        elif self.RELATIVE_REFERENCE == "Height":
            x = parent.surface.get_height() * self.RELATIVE_Y[self.state]
            y = parent.surface.get_height() * self.RELATIVE_Y[self.state]
        else:
            x = parent.surface.get_width() * self.RELATIVE_X[self.state]
            y = parent.surface.get_height() * self.RELATIVE_Y[self.state]

        parent.surface.blit(self.surface, (x-self.surface.get_width()/2, y-self.surface.get_height()/2))

    def update(self, parent):
        self.resize(parent=parent)

        self.events = parent.events

        for event in self.events:
            if event.type == pygame.MOUSEBUTTONDOWN:
                if self.state == 'hovered':
                    self.mouseBtnDown = True
                    if not self.onPress == None:
                        self.onPress()
            
            if event.type == pygame.MOUSEBUTTONUP:
                self.mouseBtnDown = False
                if self.state == 'pressed':
                    if not self.onRelease == None:
                        self.onRelease()

        self.relativeMousePosOfParent = parent._getRelativeMousePos(relativeReference = self.RELATIVE_REFERENCE)
        if checkMouseIntersect(relativeMousePos=self.relativeMousePosOfParent, relativePos=(self.RELATIVE_X[self.state], self.RELATIVE_Y[self.state]), relativeWidth=self.RELATIVE_WIDTH[self.state], relativeHeight=self.RELATIVE_HEIGHT[self.state]):
            if self.state == 'hovered'  and self.mouseBtnDown:
                self.state = 'pressed'
            elif self.state == 'hovered' and not self.mouseBtnDown:
                self.state = 'hovered'
            elif self.state == "normal" and self.mouseBtnDown:
                self.state = 'pressed'
            elif self.state == "normal" and not self.mouseBtnDown:
                self.state = 'hovered'
            elif self.state == 'pressed' and self.mouseBtnDown:
                self.state = 'pressed'
            else:
                self.state = 'hovered'
        else:
            self.state = 'normal'

        for widgets in self.widgets:
            widgets.update(parent = self)

    def resize(self, parent):
        if self.RELATIVE_REFERENCE == 'Width':
            self.absoluteWidth = parent.surface.get_width() * self.RELATIVE_WIDTH[self.state]
            self.absoluteHeight = parent.surface.get_width() * self.RELATIVE_HEIGHT[self.state]

        elif self.RELATIVE_REFERENCE == 'Height':
            self.absoluteWidth = parent.surface.get_height() * self.RELATIVE_WIDTH[self.state]
            self.absoluteHeight = parent.surface.get_height() * self.RELATIVE_HEIGHT[self.state]
        else:
            self.absoluteWidth = parent.surface.get_width() * self.RELATIVE_WIDTH[self.state]
            self.absoluteHeight = parent.surface.get_height() * self.RELATIVE_HEIGHT[self.state]
        
        self.surface = pygame.Surface((self.absoluteWidth,self.absoluteHeight))

        for widget in self.widgets:
            widget.resize(parent = self)

    def addWidget(self, widget):
        self.widgets.append(widget)

    def _getRelativeMousePos(self, relativeReference):
        topLeftX = self.RELATIVE_X[self.state]-self.RELATIVE_WIDTH[self.state]/2
        topLeftY = self.RELATIVE_Y[self.state]-self.RELATIVE_HEIGHT[self.state]/2

        relativeOffsetX = self.relativeMousePosOfParent[0]-topLeftX
        relativeOffsetY = self.relativeMousePosOfParent[1]-topLeftY

        if relativeReference == "Width":
            relativeMouseX = relativeOffsetX/self.RELATIVE_WIDTH[self.state]
            relativeMouseY = relativeOffsetY/self.RELATIVE_WIDTH[self.state]

        elif relativeReference == "Height":
            relativeMouseX = relativeOffsetX/self.RELATIVE_HEIGHT[self.state]
            relativeMouseY = relativeOffsetY/self.RELATIVE_HEIGHT[self.state]

        else:
            relativeMouseX = relativeOffsetX/self.RELATIVE_WIDTH[self.state]
            relativeMouseY = relativeOffsetY/self.RELATIVE_HEIGHT[self.state]

        return relativeMouseX, relativeMouseY

    # Utility function to convert a list to a dictionary with keys: normal, hovered, pressed
    def _listToStateDict(self, input_list):
        states = ['normal', 'hovered', 'pressed']
        if not isinstance(input_list, list):
            input_list = [input_list] * 3  # If input is not a list, duplicate it 3 times
        while len(input_list) < 3:
            input_list.append(input_list[-1])  # Extend list with the last element
        return {state: input_list[i] for i, state in enumerate(states)}
    


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
