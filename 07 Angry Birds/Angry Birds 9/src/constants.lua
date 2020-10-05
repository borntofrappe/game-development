VIRTUAL_WIDTH = 640
VIRTUAL_HEIGHT = 360

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

OPTIONS = {
  fullscreen = false,
  vsync = true,
  resizable = true
}

ALIEN_WIDTH = 35
ALIEN_HEIGHT = 35

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

H_OBSTACLES = {
  {width = 110, height = 35},
  {width = 110, height = 35},
  {width = 70, height = 35},
  {width = 70, height = 35},
  {width = 110, height = 70},
  {width = 110, height = 70}
}

V_OBSTACLES = {
  {width = 35, height = 110},
  {width = 35, height = 110},
  {width = 35, height = 70},
  {width = 35, height = 70},
  {width = 70, height = 110},
  {width = 70, height = 110}
}
