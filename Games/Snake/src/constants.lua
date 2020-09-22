WINDOW_WIDTH = 400
WINDOW_HEIGHT = 500

OPTIONS = {
  fullscreen = false,
  vsync = true,
  resizable = false
}

CELL_SIZE = 25
CELL_MOVEMENT_SPEED = 2
CELL_DIRECTIONS = {"top", "right", "bottom", "left"}
CELL_DIRECTIONS_SPEED = {
  ["top"] = {
    x = 0,
    y = -1
  },
  ["right"] = {
    x = 1,
    y = 0
  },
  ["bottom"] = {
    x = 0,
    y = 1
  },
  ["left"] = {
    x = -1,
    y = 0
  }
}
