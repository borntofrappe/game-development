WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500

OPTIONS = {
  fullscreen = false,
  vsync = true,
  resizable = false
}

DIRECTIONS = {"top", "right", "bottom", "left"}

CELL_SIZE = 20
CELL_MOVEMENT_SPEED = 60
CELL_DIRECTION_SPEED = {
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
