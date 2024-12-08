import pygame
import sys

# Initialize Pygame
pygame.init()

# Constants
SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
FPS = 60
BACKGROUND_COLOR = (30, 30, 30)
LEFT_SURFACE_COLOR = (50, 150, 250)
RIGHT_SURFACE_COLOR = (250, 100, 100)
EXPAND_SPEED = 10  # Speed at which the surfaces expand

# Initialize the main screen
screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT), pygame.RESIZABLE)
pygame.display.set_caption("Expandable Surfaces")

# Initialize surface widths
left_surface_width = 0
right_surface_width = 0

# Clock for controlling the frame rate
clock = pygame.time.Clock()

# Main game loop
running = True
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

        # Key presses to expand surfaces
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_LEFT:  # Expand left surface
                left_surface_width = min(left_surface_width + EXPAND_SPEED, SCREEN_WIDTH // 2)
            if event.key == pygame.K_RIGHT:  # Expand right surface
                right_surface_width = min(right_surface_width + EXPAND_SPEED, SCREEN_WIDTH // 2)

        # Key presses to retract surfaces
        if event.type == pygame.KEYUP:
            if event.key == pygame.K_LEFT:  # Retract left surface
                left_surface_width = max(left_surface_width - EXPAND_SPEED, 0)
            if event.key == pygame.K_RIGHT:  # Retract right surface
                right_surface_width = max(right_surface_width - EXPAND_SPEED, 0)

    # Update screen size dynamically
    SCREEN_WIDTH, SCREEN_HEIGHT = screen.get_size()

    # Fill the main screen (background)
    screen.fill(BACKGROUND_COLOR)

    # Draw the left surface
    left_surface = pygame.Surface((left_surface_width, SCREEN_HEIGHT))
    left_surface.fill(LEFT_SURFACE_COLOR)
    screen.blit(left_surface, (0, 0))  # Top-left corner

    # Draw the right surface
    right_surface = pygame.Surface((right_surface_width, SCREEN_HEIGHT))
    right_surface.fill(RIGHT_SURFACE_COLOR)
    screen.blit(right_surface, (SCREEN_WIDTH - right_surface_width, 0))  # Top-right corner

    # Update the display
    pygame.display.flip()
    clock.tick(FPS)

# Quit Pygame
pygame.quit()
sys.exit()
