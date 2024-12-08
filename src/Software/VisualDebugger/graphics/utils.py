from graphics.settings import *
import pygame

def draw_responsive_rectangle(
    surface,
    rel_x=DEFAULT_REL_X, rel_y=DEFAULT_REL_Y,
    rel_width=DEFAULT_REL_WIDTH, rel_height=DEFAULT_REL_HEIGHT,
    rel_border_thickness=DEFAULT_REL_BORDER_THICKNESS,
    border_color=DEFAULT_BORDER_COLOR,
    background_color=DEFAULT_BACKGROUND_COLOR,
    name=DEFAULT_NAME, name_color=DEFAULT_NAME_COLOR,
    value=DEFAULT_VALUE, value_color=DEFAULT_VALUE_COLOR
):
    """
    Draws a rectangle with a border, name (top-left), and value (centered), scaled to surface width.
    """
    # Calculate absolute values based on surface width
    surface_width = surface.get_width()
    abs_x = int(rel_x * surface_width)
    abs_y = int(rel_y * surface_width)
    abs_width = int(rel_width * surface_width)
    abs_height = int(rel_height * surface_width)
    abs_border_thickness = int(rel_border_thickness * surface_width)

    # Outer rectangle (border)
    pygame.draw.rect(surface, border_color, (abs_x, abs_y, abs_width, abs_height))

    # Inner rectangle (background)
    inner_rect = pygame.Rect(
        abs_x + abs_border_thickness,
        abs_y + abs_border_thickness,
        abs_width - 2 * abs_border_thickness,
        abs_height - 2 * abs_border_thickness
    )
    pygame.draw.rect(surface, background_color, inner_rect)

    # Font scaling logic
    font_size = max(12, abs_width // 15)  # Ensure minimum font size of 12
    font = pygame.font.SysFont("Arial", font_size)

    # Render and position the name text (top-left)
    name_surface = font.render(name, True, name_color)
    name_position = (inner_rect.x + 5, inner_rect.y + 5)  # Slight padding
    surface.blit(name_surface, name_position)

    # Render and position the value text (centered)
    value_surface = font.render(value, True, value_color)
    value_rect = value_surface.get_rect(center=inner_rect.center)
    surface.blit(value_surface, value_rect)