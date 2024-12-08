import pygame
from graphics.colors import *

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

        self.absoluteXonWindow = 0
        self.absoluteYonWindow = 0

        self.absoluteXonParent = 0 
        self.absoluteYonParent = 0

    def addWidget(self, widget):
        self.widgets.append(widget)

    def resize(self):
        #self.absoluteXonWindow = self.surface.get_width() 
        #self.absoluteYonWindow = self.surface.get_height() 

        #self.absoluteXonParent = self.surface.get_width() 
        #self.absoluteYonParent = self.surface.get_height() 

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

        self.absoluteXonWindow = 0
        self.absoluteYonWindow = 0

        self.absoluteXonParent = 0
        self.absoluteYonParent = 0

        self.absoluteWidth = 0
        self.absoluteHeight = 0

        self.absoluteBorderWidth = 0

        self.xUnit = 0
        self.yUnit = 0

        

    def draw(self, parent):
        self.surface.fill(self.BORDER_COLOR[self.state])
        innerRect = pygame.Rect(0+self.absoluteBorderWidth, 0+self.absoluteBorderWidth, self.absoluteWidth-self.absoluteBorderWidth*2, self.absoluteHeight-self.absoluteBorderWidth*2)
        pygame.draw.rect(self.surface, self.BACKGROUND_COLOR[self.state], innerRect)

        # Render the text
        fontSize = int(min(self.absoluteHeight, self.absoluteWidth) // 5)  # Scaled font size
        font = pygame.font.SysFont("Arial", fontSize)
        textSurface = font.render(self.TEXT[self.state], True, self.TEXT_COLOR[self.state])

        centerX = self.absoluteWidth * 0.5
        centerY = self.absoluteHeight * 0.5
        # Center the text
        textRect = textSurface.get_rect(center=(centerX, centerY))
        self.surface.blit(textSurface, textRect)

        for widget in self.widgets:
            widget.draw(parent = self)


        parent.surface.blit(self.surface, (self.absoluteXonParent, self.absoluteYonParent))

    def update(self, parent):
        self.resize(parent=parent)

        #updating button based on mouse inputs
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

        surfaceRect = self.surface.get_rect()
        surfaceRect.topleft = (self.absoluteXonWindow, self.absoluteYonWindow)
        if surfaceRect.collidepoint(pygame.mouse.get_pos()):
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
        parentSurfaceWidth = parent.surface.get_width()
        parentSurfaceHeight = parent.surface.get_height()

        absoluteXParent = parent.absoluteXonWindow
        absoluteYParent = parent.absoluteYonWindow

        #calculating new absolute and relative sizes

        if self.RELATIVE_REFERENCE == 'Width':
            self.xUnit = parentSurfaceWidth
            self.yUnit = parentSurfaceWidth

        elif self.RELATIVE_REFERENCE == 'Height':
            self.xUnit = parentSurfaceHeight
            self.yUnit = parentSurfaceHeight
        
        else:
            self.xUnit = parentSurfaceWidth
            self.yUnit = parentSurfaceHeight

        self.absoluteWidth = self.xUnit * self.RELATIVE_WIDTH[self.state]
        self.absoluteHeight = self.yUnit * self.RELATIVE_HEIGHT[self.state]

        self.absoluteXonParent = self.xUnit*self.RELATIVE_X[self.state]
        self.absoluteYonParent = self.yUnit*self.RELATIVE_Y[self.state]

        self.absoluteXonWindow = absoluteXParent + self.absoluteXonParent
        self.absoluteYonWindow = absoluteYParent + self.absoluteYonParent

        self.absoluteBorderWidth = self.absoluteWidth * self.RELATIVE_BORDER_WIDTH[self.state]

        #center coordinates
        self._centerCoordinates()

        #updating the surface
        self.surface = pygame.Surface((self.absoluteWidth,self.absoluteHeight))

        #updating all the other widgets
        for widget in self.widgets:
            widget.resize(parent = self)

    def addWidget(self, widget):
        self.widgets.append(widget)


    # Utility function to convert a list to a dictionary with keys: normal, hovered, pressed
    def _listToStateDict(self, input_list):
        states = ['normal', 'hovered', 'pressed']
        if not isinstance(input_list, list):
            input_list = [input_list] * 3  # If input is not a list, duplicate it 3 times
        while len(input_list) < 3:
            input_list.append(input_list[-1])  # Extend list with the last element
        return {state: input_list[i] for i, state in enumerate(states)}
    
    def _centerCoordinates(self):
        xOffset = self.absoluteWidth // 2
        yOffset = self.absoluteHeight // 2

        self.absoluteXonParent = self.absoluteXonParent - xOffset
        self.absoluteYonParent = self.absoluteYonParent - yOffset

        self.absoluteXonWindow = self.absoluteXonWindow - xOffset
        self.absoluteYonWindow = self.absoluteYonWindow - yOffset

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
