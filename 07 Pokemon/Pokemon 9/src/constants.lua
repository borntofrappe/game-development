VIRTUAL_WIDTH = 400
VIRTUAL_HEIGHT = 224

WINDOW_WIDTH = 800
WINDOW_HEIGHT = 448

OPTIONS = {
  fullscreen = false,
  resizable = true,
  vsync = true
}

TILE_SIZE = 16
TILE_IDS = {
  ["background"] = 46,
  ["tall-grass"] = 42,
  ["empty"] = 101
}

COLUMNS = math.floor(VIRTUAL_WIDTH / TILE_SIZE)
ROWS = math.floor(VIRTUAL_HEIGHT / TILE_SIZE)
ROWS_GRASS = 5

POKEMON_WIDTH = 64
POKEMON_HEIGHT = 64
POKEDEX = {"aardart", "agnite", "anoleaf", "bamboon", "cardiwing"}

CURSOR_WIDTH = 14
CURSOR_HEIGHT = 12
