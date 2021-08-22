TITLE = "Grand Prix"

CAR_SIZE = 16

TEXTURE_SIZE = 8
TEXTURES = {
  ["default"] = [[
    3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3
    2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
    2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
    3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3
  ]],
  ["finish-line"] = [[
    3 3 3
    2 2 2
    4 4 4
    4 4 4
    4 4 4
    4 4 4
    4 4 4
    4 4 4
    4 4 4
    4 4 4
    4 4 4
    4 4 4
    4 4 4
    4 4 4
    2 2 2
    3 3 3
  ]]
}

COLUMNS = TEXTURES.default:gsub(" ", ""):find("\n") - 1
local _, newLineCharacters = TEXTURES.default:gsub("\n", "")
ROWS = newLineCharacters

VIRTUAL_WIDTH = COLUMNS * TEXTURE_SIZE
VIRTUAL_HEIGHT = ROWS * TEXTURE_SIZE

WINDOW_SCALE = 3
WINDOW_WIDTH = VIRTUAL_WIDTH * WINDOW_SCALE
WINDOW_HEIGHT = VIRTUAL_HEIGHT * WINDOW_SCALE

OPTIONS = {
  fullscreen = false,
  vsync = true,
  resizable = true
}

OFFSET_SPEED_DEFAULT = 40
OFFSET_SPEED_SET = 20
OFFSET_SPEED_GO = 100

OFFSET_SPEED_CAR = {
  ["min"] = 50,
  ["max"] = 200
}

OFFSET_SPEED_CARS = {
  ["min"] = 40,
  ["max"] = 160
}

X_SPEED = 50
Y_SPEED = 70
SLOWDOWN_SPEED = 200

TWEEN_IN = 0.12
TWEEN_OUT = 0.08
