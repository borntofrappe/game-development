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
    ["dx"] = 0,
    ["dy"] = -1
  },
  ["right"] = {
    ["dx"] = 1,
    ["dy"] = 0
  },
  ["bottom"] = {
    ["dx"] = 0,
    ["dy"] = 1
  },
  ["left"] = {
    ["dx"] = -1,
    ["dy"] = 0
  }
}
