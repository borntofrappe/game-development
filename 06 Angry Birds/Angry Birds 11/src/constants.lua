VIRTUAL_WIDTH = 640
VIRTUAL_HEIGHT = 360

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

OPTIONS = {
  fullscreen = false,
  vsync = true,
  resizable = true
}

GRAVITY_X = 0
GRAVITY_Y = 400
ALIEN_WIDTH = 36
ALIEN_HEIGHT = 36
VELOCITY_DESTROY = 150
VELOCITY_RESET = 5

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

PLAYER = {
  x = VIRTUAL_WIDTH / 4,
  y = VIRTUAL_HEIGHT * 3 / 4
}

TARGET = {
  x = VIRTUAL_WIDTH * 3 / 4,
  y = VIRTUAL_HEIGHT - ALIEN_HEIGHT / 2
}

OBSTACLES = {
  {
    x = VIRTUAL_WIDTH * 3 / 4 - 55,
    y = VIRTUAL_HEIGHT - 55,
    direction = "vertical"
  },
  {
    x = VIRTUAL_WIDTH * 3 / 4 + 55,
    y = VIRTUAL_HEIGHT - 55,
    direction = "vertical"
  },
  {
    x = VIRTUAL_WIDTH * 3 / 4,
    y = VIRTUAL_HEIGHT - 110 - 17.5,
    direction = "horizontal"
  }
}
