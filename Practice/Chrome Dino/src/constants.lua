WINDOW_WIDTH = 480
WINDOW_HEIGHT = 288

VIRTUAL_WIDTH = 160
VIRTUAL_HEIGHT = 96

OPTIONS = {
    fullscreen = false,
    vsync = true,
    resizable = true
}

SCROLL_SPEED = {
    ["min"] = 80,
    ["max"] = 200
}

-- fraction of the scroll speed
SCORE_SPEED = 0.1
FILE_PATH = "highscores.lst"

DINO = {
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

CACTI = {
    {
        ["x"] = 0,
        ["y"] = 16,
        ["width"] = 9,
        ["height"] = 12
    },
    {
        ["x"] = 9,
        ["y"] = 16,
        ["width"] = 9,
        ["height"] = 12
    },
    {
        ["x"] = 18,
        ["y"] = 16,
        ["width"] = 11,
        ["height"] = 18
    }
}

BIRD = {
    {
        ["x"] = 47,
        ["y"] = 16,
        ["width"] = 16,
        ["height"] = 15
    },
    {
        ["x"] = 63,
        ["y"] = 16,
        ["width"] = 16,
        ["height"] = 15
    }
}

CLOUD = {
    ["x"] = 29,
    ["y"] = 16,
    ["width"] = 18,
    ["height"] = 6
}
