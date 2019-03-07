-- include here those constant values used throughout the application

-- measures for the screen width and height
WINDOW_WIDTH = 1024
WINDOW_HEIGHT = 576
-- virtual measures for the push library
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- values for the tile map
-- id(s) for the tiles
TILE_GROUND = 2
TILE_SKY = 1
TILE_TOP = 1
-- size of each tile
TILE_SIZE = 16

-- number of tiles present in the height/width of the screen
MAP_WIDTH = 32 * 3
MAP_HEIGHT = 18
-- row at which point to start drawing the tiles for the ground
MAP_SKY = 14
PILLAR_HEIGHT = 2

-- size of the background
BACKGROUND_WIDTH = 256
BACKGROUND_HEIGHT = 128

-- size of the character
CHARACTER_WIDTH = 16
CHARACTER_HEIGHT = 20
-- speed of the character
CHARACTER_SCROLL_SPEED = 100

-- speed of the jump
CHARACTER_JUMP_SPEED = -400
GRAVITY = 20