CELL_SIZE = 8

COLUMNS_WHITESPACE = 1 -- before the grid, between the grid and game data, after the game data
COLUMNS_BORDER = 1 -- around the grid
COLUMNS_GRID = 10
COLUMNS_GAMEDATA = 6

ROWS_GRID = 18
ROWS_WHITESPACE = 0.5 -- before the game data, before and after the next tetrimino
ROWS_NEXT_TETROMINO = 6
ROWS_DATA = ROWS_GRID - ROWS_NEXT_TETROMINO - ROWS_WHITESPACE * 3

COLUMNS = COLUMNS_WHITESPACE * 3 + COLUMNS_BORDER * 2 + COLUMNS_GRID + COLUMNS_GAMEDATA
ROWS = ROWS_GRID
