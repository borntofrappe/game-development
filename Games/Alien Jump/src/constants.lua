WINDOW_WIDTH = 800
WINDOW_HEIGHT = 450

VIRTUAL_WIDTH = 256
VIRTUAL_HEIGHT = 144

OPTIONS = {
  fullscreen = false,
  vsync = true,
  resizable = true
}

BACKGROUND_WIDTH = VIRTUAL_WIDTH
BACKGROUND_HEIGHT = VIRTUAL_HEIGHT

SCROLL_SPEED = 120
GRAVITY = 20

ALIEN_WIDTH = 16
ALIEN_HEIGHT = 20
ALIEN_X = 8
ALIEN_Y = VIRTUAL_HEIGHT - ALIEN_HEIGHT
ALIEN_JUMP_SPEED = 400

ALIEN_ANIMATION = {
  ["idle"] = Animation(
    {
      frames = {1},
      interval = 1
    }
  ),
  ["jump"] = Animation(
    {
      frames = {2},
      interval = 1
    }
  ),
  ["squat"] = Animation(
    {
      frames = {3},
      interval = 1
    }
  ),
  ["walk"] = Animation(
    {
      frames = {4, 5},
      interval = 0.1
    }
  )
}

BUSH_SIZE = 16
BUSH_VARIANTS = {
  {3, 4},
  {1, 3, 4},
  {2, 3, 4},
  {1, 5, 3, 4},
  {2, 5, 3, 4},
  {3, 4, 1},
  {3, 4, 2},
  {3, 4, 5, 1},
  {3, 4, 5, 2},
  {1, 3, 4, 2},
  {2, 3, 4, 1},
  {1, 5, 3, 4, 2},
  {2, 5, 3, 4, 1},
  {1, 3, 4, 5, 2},
  {2, 3, 4, 5, 1}
}

COIN_SIZE = 16
COIN_POINTS = {
  [1] = 10,
  [2] = 25,
  [3] = 50
}

CREATURE_SIZE = 16
SCROLL_SPEED_CREATURE = SCROLL_SPEED + 50
