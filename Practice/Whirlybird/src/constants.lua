WINDOW_WIDTH = 400
WINDOW_HEIGHT = 600

UPPER_THRESHOLD = WINDOW_HEIGHT / 8
LOWER_THRESHOLD = WINDOW_HEIGHT - WINDOW_HEIGHT / 8

GRAVITY = 16
FRICTION = 10
SLIDE = 4
JUMP = 12

FRICTION = 4
PLAYER = {
  ["data"] = {
    {
      ["width"] = 39,
      ["height"] = 33,
      ["varieties"] = {1}
    },
    {
      ["width"] = 36,
      ["height"] = 42,
      ["varieties"] = {2, 3, 4}
    },
    {
      ["width"] = 39,
      ["height"] = 45,
      ["varieties"] = {5, 6}
    }
  },
  ["types"] = {
    ["default"] = 1,
    ["flying"] = 2,
    ["falling"] = 3
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
