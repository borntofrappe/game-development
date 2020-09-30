ROWS = 15
COLUMNS = 20
CELL_SIZE = 25

WINDOW_WIDTH = COLUMNS * CELL_SIZE
WINDOW_HEIGHT = ROWS * CELL_SIZE

PADDING = 5
MARGIN = 5

OPTIONS = {
  fullscreen = false,
  vsync = true,
  resizable = false
}

DIRECTIONS = {"top", "right", "bottom", "left"}
DIRECTIONS_CHANGE = {
  ["top"] = {
    ["column"] = 0,
    ["row"] = -1
  },
  ["right"] = {
    ["column"] = 1,
    ["row"] = 0
  },
  ["bottom"] = {
    ["column"] = 0,
    ["row"] = 1
  },
  ["left"] = {
    ["column"] = -1,
    ["row"] = 0
  }
}
