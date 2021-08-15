TITLE = "Missile Command"

WINDOW_WIDTH = 560
WINDOW_HEIGHT = 420

STRUCTURE_WIDTH = 56
STRUCTURE_HEIGHT = 46

TARGET_SIZE = 4
TRACKBALL_SIZE = 8
TRACKBALL_UPDATE_SPEED = 120

LINE_RESOLUTION = 5

ANTI_MISSILE_UPDATE_SPEED = 0.0001
ANTI_MISSILES = {
  ["number"] = 15
}

MISSILE_UPDATE_SPEED = 0.0009
MISSILES = {
  ["number"] = {10, 20},
  ["delay-max"] = {10, 20},
  ["launch-pad-odds"] = 5
}

EXPLOSION = {
  ["interval"] = 0.2,
  ["radius"] = 18
}
