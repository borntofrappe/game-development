WINDOW_WIDTH = 1024
WINDOW_HEIGHT = 576

VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216
TILE_SIZE = 16

OPTIONS = {
  fullscreen = false,
  vsync = true,
  resizable = true
}

COLUMNS = math.floor(VIRTUAL_WIDTH / TILE_SIZE)
ROWS = math.floor(VIRTUAL_HEIGHT / TILE_SIZE)
PADDING = 4
MARGIN_TOP = VIRTUAL_HEIGHT - ROWS * TILE_SIZE

ROOM_IDS = {
  ["empty"] = 21,
  ["door"] = {
    ["up"] = {
      ["closed"] = {134, 135, 153, 154},
      ["opened"] = {98, 99, 117, 118}
    },
    ["right"] = {
      ["closed"] = {175, 194, 174, 193},
      ["opened"] = {173, 192, 172, 191}
    },
    ["down"] = {
      ["closed"] = {235, 236, 216, 217},
      ["opened"] = {160, 161, 141, 142}
    },
    ["left"] = {
      ["closed"] = {219, 238, 220, 239},
      ["opened"] = {181, 200, 182, 201}
    }
  },
  ["corner"] = {
    ["up-left"] = 4,
    ["up-right"] = 5,
    ["down-right"] = 24,
    ["down-left"] = 23
  },
  ["side"] = {
    ["up"] = {58, 59, 60},
    ["right"] = {78, 97, 116},
    ["down"] = {79, 80, 81},
    ["left"] = {77, 96, 115}
  },
  ["terrain"] = {
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    26,
    27,
    28,
    29,
    30,
    31,
    32,
    45,
    46,
    47,
    48,
    49,
    50,
    51,
    64,
    65,
    66,
    67,
    68,
    69,
    70,
    88,
    89,
    107,
    108
  }
}
