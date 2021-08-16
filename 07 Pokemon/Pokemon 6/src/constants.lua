VIRTUAL_WIDTH = 400
VIRTUAL_HEIGHT = 224

WINDOW_WIDTH = 800
WINDOW_HEIGHT = 448

OPTIONS = {
  fullscreen = false,
  resizable = true,
  vsync = true
}

POKEDEX = {"aardart", "agnite", "anoleaf", "bamboon", "cardiwing"}
POKEMON_WIDTH = 64
POKEMON_HEIGHT = 64

TILE_SIZE = 16
TILE_BACKGROUND = 46
TILE_GRASS = 42

TILE_PLAYER = {
  ["down"] = {1, 2, 3},
  ["left"] = {13, 14, 15},
  ["right"] = {25, 26, 27},
  ["up"] = {37, 38, 39}
}

COLUMNS = math.floor(VIRTUAL_WIDTH / TILE_SIZE)
ROWS = math.floor(VIRTUAL_HEIGHT / TILE_SIZE)
ROWS_GRASS = 5
