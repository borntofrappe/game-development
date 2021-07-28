WINDOW_WIDTH = 400
WINDOW_HEIGHT = 600

UPPER_THRESHOLD = 100
LOWER_THRESHOLD = 500

GRAVITY = 16
FRICTION = 10
SLIDE = 4
JUMP = 12
HOP = 4

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

INTERACTABLES = {
  ["solid"] = {
    ["x"] = 0,
    ["y"] = 60,
    ["width"] = 39,
    ["height"] = 9,
    ["frames"] = 1
  },
  ["fading"] = {
    ["x"] = 0,
    ["y"] = 69,
    ["width"] = 39,
    ["height"] = 9,
    ["frames"] = 4,
    ["interval"] = 0.8,
    ["isAnimated"] = true
  },
  ["crumbling"] = {
    ["x"] = 0,
    ["y"] = 78,
    ["width"] = 39,
    ["height"] = 15,
    ["frames"] = 4,
    ["interval"] = 0.07,
    ["canBeDestroyed"] = true
  },
  ["moving"] = {
    ["x"] = 0,
    ["y"] = 93,
    ["width"] = 39,
    ["height"] = 15,
    ["frames"] = 2,
    ["interval"] = 0.25,
    ["isAnimated"] = true
  },
  ["cloud"] = {
    ["x"] = 0,
    ["y"] = 108,
    ["width"] = 39,
    ["height"] = 15,
    ["frames"] = 4,
    ["interval"] = 0.08,
    ["canBeDestroyed"] = true
  },
  ["trampoline"] = {
    ["x"] = 0,
    ["y"] = 123,
    ["width"] = 39,
    ["height"] = 21,
    ["frames"] = 4,
    ["interval"] = 0.05,
    ["canBeDestroyed"] = false
  },
  ["spikes"] = {
    ["x"] = 0,
    ["y"] = 144,
    ["width"] = 39,
    ["height"] = 21,
    ["frames"] = 4,
    ["interval"] = 0.05,
    ["isAnimated"] = true
  },
  ["enemy"] = {
    ["x"] = 0,
    ["y"] = 165,
    ["width"] = 39,
    ["height"] = 39,
    ["frames"] = 4,
    ["interval"] = 0.05,
    ["isAnimated"] = true
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
