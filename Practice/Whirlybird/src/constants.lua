WINDOW_WIDTH = 400
WINDOW_HEIGHT = 600

UPPER_THRESHOLD = 100
LOWER_THRESHOLD = 550

GRAVITY = 16
FRICTION = 10
SLIDE = 5
BOUNCE = 12

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

INTERACTABLES_SAFE = {"solid", "fading", "crumbling", "moving", "trampoline"}

INTERACTABLES = {
  ["solid"] = {
    ["x"] = 0,
    ["y"] = 60,
    ["width"] = 39,
    ["height"] = 9,
    ["frames"] = 1,
    ["animation"] = {
      ["isAnimated"] = false
    },
    ["interaction"] = {
      ["canBeInteracted"] = false
    },
    ["movement"] = {
      ["canMove"] = false
    },
    ["hatOdds"] = 5
  },
  ["fading"] = {
    ["x"] = 0,
    ["y"] = 69,
    ["width"] = 39,
    ["height"] = 9,
    ["frames"] = 4,
    ["animation"] = {
      ["isAnimated"] = true,
      ["interval"] = 0.8
    },
    ["interaction"] = {
      ["canBeInteracted"] = false
    },
    ["movement"] = {
      ["canMove"] = false
    },
    ["hatOdds"] = 0
  },
  ["crumbling"] = {
    ["x"] = 0,
    ["y"] = 78,
    ["width"] = 39,
    ["height"] = 15,
    ["frames"] = 4,
    ["animation"] = {
      ["isAnimated"] = false
    },
    ["interaction"] = {
      ["canBeInteracted"] = true,
      ["interval"] = 0.07,
      ["isDestroyed"] = true
    },
    ["movement"] = {
      ["canMove"] = false
    },
    ["hatOdds"] = 5
  },
  ["moving"] = {
    ["x"] = 0,
    ["y"] = 93,
    ["width"] = 39,
    ["height"] = 15,
    ["frames"] = 2,
    ["animation"] = {
      ["isAnimated"] = true,
      ["interval"] = 4
    },
    ["interaction"] = {
      ["canBeInteracted"] = false
    },
    ["movement"] = {
      ["canMove"] = true,
      ["dx"] = 80
    },
    ["hatOdds"] = 5
  },
  ["cloud"] = {
    ["x"] = 0,
    ["y"] = 108,
    ["width"] = 39,
    ["height"] = 15,
    ["frames"] = 4,
    ["animation"] = {
      ["isAnimated"] = false
    },
    ["interaction"] = {
      ["canBeInteracted"] = true,
      ["interval"] = 0.08,
      ["isDestroyed"] = true
    },
    ["movement"] = {
      ["canMove"] = false
    },
    ["hatOdds"] = 0
  },
  ["trampoline"] = {
    ["x"] = 0,
    ["y"] = 123,
    ["width"] = 39,
    ["height"] = 21,
    ["frames"] = 4,
    ["animation"] = {
      ["isAnimated"] = false
    },
    ["interaction"] = {
      ["canBeInteracted"] = true,
      ["interval"] = 0.05,
      ["isDestroyed"] = false
    },
    ["movement"] = {
      ["canMove"] = false
    },
    ["hatOdds"] = 0
  },
  ["spikes"] = {
    ["x"] = 0,
    ["y"] = 144,
    ["width"] = 39,
    ["height"] = 21,
    ["frames"] = 4,
    ["animation"] = {
      ["isAnimated"] = true,
      ["interval"] = 0.05
    },
    ["interaction"] = {
      ["canBeInteracted"] = false
    },
    ["movement"] = {
      ["canMove"] = false
    },
    ["hatOdds"] = 0
  },
  ["enemy"] = {
    ["x"] = 0,
    ["y"] = 165,
    ["width"] = 39,
    ["height"] = 39,
    ["frames"] = 4,
    ["animation"] = {
      ["isAnimated"] = true,
      ["interval"] = 0.5
    },
    ["interaction"] = {
      ["canBeInteracted"] = false
    },
    ["movement"] = {
      ["canMove"] = true,
      ["dx"] = 80
    },
    ["hatOdds"] = 0
  }
}

HAT = {
  ["x"] = 0,
  ["y"] = 42,
  ["width"] = 21,
  ["height"] = 18,
  ["frames"] = 4
}

PARTICLES = {
  ["x"] = 198,
  ["y"] = 45,
  ["width"] = 27,
  ["height"] = 27,
  ["frames"] = 6
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
