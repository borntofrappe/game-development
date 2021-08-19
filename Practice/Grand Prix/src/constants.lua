TITLE = "Grand Prix"

TILE_SIZE = {
  ["car"] = 16,
  ["texture"] = 8
}

COLUMNS = 26
ROWS = 16

VIRTUAL_WIDTH = COLUMNS * TILE_SIZE.texture
VIRTUAL_HEIGHT = ROWS * TILE_SIZE.texture

WINDOW_SCALE = 3.5
WINDOW_WIDTH = VIRTUAL_WIDTH * WINDOW_SCALE
WINDOW_HEIGHT = VIRTUAL_HEIGHT * WINDOW_SCALE

OPTIONS = {
  fullscreen = false,
  vsync = true,
  resizable = true
}
