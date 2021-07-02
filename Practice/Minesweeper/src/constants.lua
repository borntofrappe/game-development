COLUMNS = 7
ROWS = 11

PADDING_X = 28
PADDING_Y = 24

CELL_SIZE = 50

WINDOW_WIDTH = COLUMNS * CELL_SIZE + PADDING_X * 2
WINDOW_HEIGHT = ROWS * CELL_SIZE + PADDING_Y * 2

COLORS = {
  ["background-light"] = {
    ["r"] = 0.35,
    ["g"] = 0.57,
    ["b"] = 0.22
  },
  ["background-dark"] = {
    ["r"] = 0.29,
    ["g"] = 0.46,
    ["b"] = 0.18
  },
  ["cell-light"] = {
    ["r"] = 0.65,
    ["g"] = 0.83,
    ["b"] = 0.29
  },
  ["cell-dark"] = {
    ["r"] = 0.61,
    ["g"] = 0.79,
    ["b"] = 0.25
  },
  ["cell-revealed-light"] = {
    ["r"] = 0.89,
    ["g"] = 0.75,
    ["b"] = 0.63
  },
  ["cell-revealed-dark"] = {
    ["r"] = 0.8,
    ["g"] = 0.68,
    ["b"] = 0.56
  },
  ["mine"] = {
    ["r"] = 0.95,
    ["g"] = 0.21,
    ["b"] = 0.03
  },
  ["number-1"] = {
    ["r"] = 0.09,
    ["g"] = 0.46,
    ["b"] = 0.83
  },
  ["number-2"] = {
    ["r"] = 0.22,
    ["g"] = 0.55,
    ["b"] = 0.24
  },
  ["number-3"] = {
    ["r"] = 0.83,
    ["g"] = 0.18,
    ["b"] = 0.18
  }
}

FONTS = {
  ["normal"] = love.graphics.newFont("res/fonts/font.ttf", 18),
  ["bold"] = love.graphics.newFont("res/fonts/font-bold.ttf", math.floor(CELL_SIZE / 1.5))
}
