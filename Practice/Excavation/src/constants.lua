TITLE = "Excavation"

TILE_SIZE = 8
TILE_TYPES = 6

WINDOW_COLUMNS = 22
WINDOW_ROWS = 14
TILES_COLUMNS = 16
TILES_ROWS = 9

VIRTUAL_WIDTH = TILE_SIZE * WINDOW_COLUMNS
VIRTUAL_HEIGHT = TILE_SIZE * WINDOW_ROWS

WINDOW_SCALE = 3
WINDOW_WIDTH = VIRTUAL_WIDTH * WINDOW_SCALE
WINDOW_HEIGHT = VIRTUAL_HEIGHT * WINDOW_SCALE

OPTIONS = {
  fullscreen = false,
  vsync = true,
  resizable = true
}

GEMS_MAX = 4
GEM_SIZES = {2, 3, 4} -- measured relative to the tile size
GEM_COLORS = {"blue", "green", "red", "rose"}

TOOLS = {"pickaxe", "hammer"}
TOOLS_TYPE = {"outline", "fill"}
TOOLS_WIDTH = 21
TOOLS_HEIGHT = 22

PROGRESS_WIDTHS = {8, 8, 6, 6} -- measured in pixels
