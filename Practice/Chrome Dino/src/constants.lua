WINDOW_WIDTH = 606
WINDOW_HEIGHT = 312

VIRTUAL_WIDTH = 202
VIRTUAL_HEIGHT = 104

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

SCROLL_SPEED = 80

CLOUD_WIDTH = 18
CLOUD_HEIGHT = 6

CACTI_TYPES = {
    {
        ["width"] = 9,
        ["height"] = 12
    },
    {
        ["width"] = 9,
        ["height"] = 12
    },
    {
        ["width"] = 11,
        ["height"] = 18
    }
}

BIRD_WIDTH = 16
BIRD_HEIGHT = 11
