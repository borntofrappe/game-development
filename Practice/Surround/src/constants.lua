TITLE = "Surround"

WINDOW_WIDTH = 640
WINDOW_HEIGHT = 420

CELL_SIZE = 20

COLUMNS = math.floor(WINDOW_WIDTH / CELL_SIZE)
ROWS = math.floor(WINDOW_HEIGHT / CELL_SIZE)

TITLE_SHADOW = {
  ["x"] = -2,
  ["y"] = 3,
  ["opacity"] = 0.4
}

INSTRUCTION_INTERVAL = {
  ["delay"] = 2,
  ["duration"] = 0.5,
  ["label"] = "instruction"
}

COLORS = {
  ["player-1"] = {
    ["r"] = 0.16,
    ["g"] = 0.83,
    ["b"] = 0.69
  },
  ["player-2"] = {
    ["r"] = 0.62,
    ["g"] = 0,
    ["b"] = 1
  },
  ["text"] = {
    ["r"] = 0.3,
    ["g"] = 0.3,
    ["b"] = 0.3
  },
  ["play-area"] = {
    ["r"] = 0.97,
    ["g"] = 0.97,
    ["b"] = 0.97
  },
  ["background"] = {
    ["r"] = 0.25,
    ["g"] = 0.25,
    ["b"] = 0.25
  }
}
