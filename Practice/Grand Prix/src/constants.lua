TITLE = "Grand Prix"

TILE_SIZE = {
  ["car"] = 16,
  ["texture"] = 8
}

COLUMNS = 26
ROWS = 16

VIRTUAL_WIDTH = COLUMNS * TILE_SIZE.texture
VIRTUAL_HEIGHT = ROWS * TILE_SIZE.texture

WINDOW_WIDTH = VIRTUAL_WIDTH * 4
WINDOW_HEIGHT = VIRTUAL_HEIGHT * 4

OPTIONS = {
  fullscreen = false,
  vsync = true,
  resizable = true
}
