WINDOW_WIDTH = 528
WINDOW_HEIGHT = 288

VIRTUAL_WIDTH = 176
VIRTUAL_HEIGHT = 96

OPTIONS = {
  fullscreen = false,
  vsync = true,
  resizable = true
}

DINO_STATES = {
  ["idle"] = {
    ["frames"] = 1,
    ["x"] = 0,
    ["y"] = 0,
    ["width"] = 16,
    ["height"] = 16
  },
  ["jump"] = {
    ["frames"] = 1,
    ["x"] = 0,
    ["y"] = 0,
    ["width"] = 16,
    ["height"] = 16
  },
  ["run"] = {
    ["frames"] = 2,
    ["x"] = 16,
    ["y"] = 0,
    ["width"] = 16,
    ["height"] = 16
  },
  ["duck"] = {
    ["frames"] = 2,
    ["x"] = 48,
    ["y"] = 5,
    ["width"] = 21,
    ["height"] = 11
  },
  ["stop"] = {
    ["frames"] = 1,
    ["x"] = 90,
    ["y"] = 0,
    ["width"] = 16,
    ["height"] = 16
  }
}
