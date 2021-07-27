WINDOW_WIDTH = 400
WINDOW_HEIGHT = 600

UPPER_THRESHOLD = 100
LOWER_THRESHOLD = 500

GRAVITY = 15
FRICTION = 10
SLIDE = 4
JUMP = 10

FRICTION = 4
PLAYER = {
  ["default"] = {
    ["x"] = 0,
    ["y"] = 0,
    ["width"] = 39,
    ["height"] = 33,
    ["frames"] = 1
  },
  ["flying"] = {
    ["x"] = 39,
    ["y"] = 0,
    ["width"] = 36,
    ["height"] = 42,
    ["frames"] = 3
  },
  ["falling"] = {
    ["x"] = 147,
    ["y"] = 0,
    ["width"] = 39,
    ["height"] = 45,
    ["frames"] = 2
  }
}

SPRITES = {
  ["types"] = 2,
  ["frames"] = 6,
  ["width"] = 45,
  ["height"] = 48
}

MARKS = {
  ["y"] = 96,
  ["types"] = 2,
  ["width"] = 30,
  ["height"] = 24
}

BUTTON = {
  ["y"] = 120,
  ["width"] = 66,
  ["height"] = 50
}
