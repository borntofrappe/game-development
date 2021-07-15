VIRTUAL_WIDTH = 640
VIRTUAL_HEIGHT = 360

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

OPTIONS = {
  fullscreen = false,
  vsync = true,
  resizable = true
}

ALIEN_WIDTH = 36
ALIEN_HEIGHT = 36

EDGES = {
  ["top"] = {
    x1 = 0,
    y1 = 0,
    x2 = VIRTUAL_WIDTH,
    y2 = 0
  },
  ["right"] = {
    x1 = VIRTUAL_WIDTH,
    y1 = 0,
    x2 = VIRTUAL_WIDTH,
    y2 = VIRTUAL_HEIGHT
  },
  ["bottom"] = {
    x1 = 0,
    y1 = VIRTUAL_HEIGHT,
    x2 = VIRTUAL_WIDTH,
    y2 = VIRTUAL_HEIGHT
  },
  ["left"] = {
    x1 = 0,
    y1 = 0,
    x2 = 0,
    y2 = VIRTUAL_HEIGHT
  }
}
