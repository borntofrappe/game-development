TITLE = "Excavation"

TILE_SIZE = 8
COLUMNS = 26
ROWS = 16

VIRTUAL_WIDTH = TILE_SIZE * COLUMNS
VIRTUAL_HEIGHT = TILE_SIZE * ROWS

WINDOW_SCALE = 3
WINDOW_WIDTH = VIRTUAL_WIDTH * WINDOW_SCALE
WINDOW_HEIGHT = VIRTUAL_HEIGHT * WINDOW_SCALE

OPTIONS = {
  fullscreen = false,
  vsync = true,
  resizable = true
}

TEXTURE_SIZE = TILE_SIZE
TEXTURE_TYPES = 6

GEM_SIZES = {2, 3, 4} -- relative to the tile size
GEM_COLORS = {"blue", "green", "red", "rose"}

TOOLS = {"pickaxe", "hammer"}
TOOLS_TYPE = {"outline", "fill"}
TOOLS_WIDTH = 21
TOOLS_HEIGHT = 22
