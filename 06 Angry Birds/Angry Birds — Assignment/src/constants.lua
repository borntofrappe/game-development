VIRTUAL_WIDTH = 640
VIRTUAL_HEIGHT = 360

WINDOW_WIDTH = 960
WINDOW_HEIGHT = 540

OPTIONS = {
  fullscreen = false,
  vsync = true,
  resizable = true
}

TILE_SIZE = 35
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
    y1 = VIRTUAL_HEIGHT - TILE_SIZE / 2,
    x2 = VIRTUAL_WIDTH,
    y2 = VIRTUAL_HEIGHT - TILE_SIZE / 2
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

LEVELS = {
  {
    ["player"] = {
      x = VIRTUAL_WIDTH / 4,
      y = VIRTUAL_HEIGHT * 3 / 4 - 17.5
    },
    ["target"] = {
      x = VIRTUAL_WIDTH * 3 / 4,
      y = VIRTUAL_HEIGHT - ALIEN_HEIGHT / 2 - 17.5
    },
    ["obstacles"] = {
      {
        x = VIRTUAL_WIDTH * 3 / 4 - 55,
        y = VIRTUAL_HEIGHT - 55 - 17.5,
        direction = "vertical",
        type = 1
      },
      {
        x = VIRTUAL_WIDTH * 3 / 4 + 55,
        y = VIRTUAL_HEIGHT - 55 - 17.5,
        direction = "vertical",
        type = 1
      },
      {
        x = VIRTUAL_WIDTH * 3 / 4,
        y = VIRTUAL_HEIGHT - 110 - 17.5 - 17.5,
        direction = "horizontal",
        type = 1
      }
    }
  },
  {
    ["player"] = {
      x = VIRTUAL_WIDTH * 3 / 4,
      y = VIRTUAL_HEIGHT * 3 / 4 - 17.5
    },
    ["target"] = {
      x = VIRTUAL_WIDTH / 4 - 75,
      y = VIRTUAL_HEIGHT - ALIEN_HEIGHT / 2 - 17.5
    },
    ["obstacles"] = {
      {
        x = VIRTUAL_WIDTH / 2,
        y = VIRTUAL_HEIGHT - 35 - 17.5,
        direction = "vertical",
        type = 3
      },
      {
        x = VIRTUAL_WIDTH / 4,
        y = VIRTUAL_HEIGHT - 55 - 17.5,
        direction = "vertical",
        type = 1
      },
      {
        x = VIRTUAL_WIDTH / 2 + 10,
        y = VIRTUAL_HEIGHT - 70 - 35 - 17.5,
        direction = "horizontal",
        type = 5
      },
      {
        x = VIRTUAL_WIDTH / 2 - 10,
        y = VIRTUAL_HEIGHT - 70 - 70 - 55 - 17.5,
        direction = "vertical",
        type = 2
      }
    }
  }
}
