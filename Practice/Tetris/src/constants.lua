CELL_SIZE = 8

GRID_COLUMNS = 10
GRID_ROWS = 18

BORDER_COLUMNS = 1
PADDING_COLUMNS = 1
LEVEL_COLUMNS = 8

GRID_WIDTH = CELL_SIZE * (GRID_COLUMNS + BORDER_COLUMNS * 2)
GRID_HEIGHT = CELL_SIZE * GRID_ROWS

VIRTUAL_WIDTH = GRID_WIDTH + CELL_SIZE * (PADDING_COLUMNS * 2 + LEVEL_COLUMNS)
VIRTUAL_HEIGHT = GRID_HEIGHT

local SCALE = math.floor(700 / VIRTUAL_WIDTH)

WINDOW_WIDTH = VIRTUAL_WIDTH * SCALE
WINDOW_HEIGHT = VIRTUAL_HEIGHT * SCALE

gFont = love.graphics.newFont("res/fonts/font.ttf", 8)

gColors = {
  {["r"] = 0.22, ["g"] = 0.22, ["b"] = 0.16},
  {["r"] = 0.48, ["g"] = 0.44, ["b"] = 0.38},
  {["r"] = 0.71, ["g"] = 0.63, ["b"] = 0.41},
  {["r"] = 0.9, ["g"] = 0.82, ["b"] = 0.61}
}

gTexture = love.graphics.newImage("res/graphics/spritesheet.png")
