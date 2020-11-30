CELL_SIZE = 20

COLUMNS = 32
ROWS = 24

WINDOW_WIDTH = COLUMNS * CELL_SIZE
WINDOW_HEIGHT = ROWS * CELL_SIZE

CANVAS_WIDTH = math.floor(WINDOW_WIDTH / 2)
CANVAS_HEIGHT = WINDOW_HEIGHT

INTERVAL_UPDATE = 0.2
INTERVAL_DRAW = 1

DELAY_INSTRUCTIONS = 2
TWEEN_INSTRUCTIONS = 0.5

DELAY_GAMEOVER = 1

OPACITY = 0.5

COLORS = {
  ["p1"] = {
    ["r"] = 0.16,
    ["g"] = 0.83,
    ["b"] = 0.69
  },
  ["p2"] = {
    ["r"] = 0.62,
    ["g"] = 0,
    ["b"] = 1
  },
  ["text"] = {
    ["r"] = 0.3,
    ["g"] = 0.3,
    ["b"] = 0.3
  }
}
