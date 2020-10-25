TILE_SIZE = 24
COLUMNS = 10
ROWS = 15

WINDOW_WIDTH = TILE_SIZE * COLUMNS + TILE_SIZE * 2 + TILE_SIZE * 7
WINDOW_HEIGHT = TILE_SIZE * ROWS

TETRIMINOS = {
  [1] = {
    [1] = {
      {-1, 0},
      {0, 0},
      {1, 0},
      {0, 1}
    },
    [2] = {
      {-1, 0},
      {0, -1},
      {0, 0},
      {0, 1}
    },
    [3] = {
      {-1, 0},
      {0, 0},
      {1, 0},
      {0, -1}
    },
    [4] = {
      {1, 0},
      {0, -1},
      {0, 0},
      {0, 1}
    }
  },
  [2] = {
    [1] = {
      {-1, 0},
      {0, 0},
      {-1, 1},
      {0, 1}
    }
  },
  [3] = {
    [1] = {
      {-1, 0},
      {0, 0},
      {1, 0},
      {2, 0}
    },
    [2] = {
      {0, -1},
      {0, 0},
      {0, 1},
      {0, 2}
    }
  }
}
