-- constants used across the game

-- the window is structured to be a grid of squares
-- the snake is made moving only along its tracks, so it is best to have the window being a multiple of the snake's own width and height
WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
CELL_SIZE = 20

SNAKE_WIDTH = CELL_SIZE
SNAKE_HEIGHT = CELL_SIZE
SNAKE_SPEED = 2

-- size of the item
ITEM_SIZE = CELL_SIZE
-- overlap that must occur before detecting a collision
ITEM_OVERLAP = 5