VIRTUAL_WIDTH = 400
VIRTUAL_HEIGHT = 224

WINDOW_WIDTH = 1200
WINDOW_HEIGHT = 672

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

POKEDEX = {
  {
    ["name"] = "aardart",
    ["stats"] = {
      ["baseHp"] = 14,
      ["baseAttack"] = 9,
      ["baseDefense"] = 5,
      ["baseSpeed"] = 6,
      ["hpIV"] = 3,
      ["attackIV"] = 4,
      ["defenseIV"] = 2,
      ["speedIV"] = 3
    }
  },
  {
    ["name"] = "agnite",
    ["stats"] = {
      ["baseHp"] = 12,
      ["baseAttack"] = 7,
      ["baseDefense"] = 3,
      ["baseSpeed"] = 7,
      ["hpIV"] = 3,
      ["attackIV"] = 4,
      ["defenseIV"] = 2,
      ["speedIV"] = 4
    }
  },
  {
    ["name"] = "anoleaf",
    ["stats"] = {
      ["baseHp"] = 11,
      ["baseAttack"] = 5,
      ["baseDefense"] = 5,
      ["baseSpeed"] = 6,
      ["hpIV"] = 3,
      ["attackIV"] = 3,
      ["defenseIV"] = 3,
      ["speedIV"] = 4
    }
  },
  {
    ["name"] = "bamboon",
    ["stats"] = {
      ["baseHp"] = 13,
      ["baseAttack"] = 6,
      ["baseDefense"] = 4,
      ["baseSpeed"] = 7,
      ["hpIV"] = 3,
      ["attackIV"] = 3,
      ["defenseIV"] = 2,
      ["speedIV"] = 5
    }
  },
  {
    ["name"] = "cardiwing",
    ["stats"] = {
      ["baseHp"] = 14,
      ["baseAttack"] = 7,
      ["baseDefense"] = 3,
      ["baseSpeed"] = 7,
      ["hpIV"] = 3,
      ["attackIV"] = 4,
      ["defenseIV"] = 2,
      ["speedIV"] = 4
    }
  }
}

CURSOR_WIDTH = 14
CURSOR_HEIGHT = 12
