Initialize the play state with hearts and an empty room.

## constants

The size of the window is modify to ensure that the room has a greater number of rows and columns. This is achieved by scaling up the virtual measures.

```lua
VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216
```

From this starting point, `COLUMNS` and `ROWS` consider the available space and `TILE_SIZE`.

```lua
COLUMNS = math.floor(VIRTUAL_WIDTH / TILE_SIZE)
ROWS = math.floor(VIRTUAL_HEIGHT / TILE_SIZE)
```

Horizontally, the size ensures that the room covers the entire width (`384` being a multiple of `16`). Vertically, the room does not stretch completely. The idea is to here leave the space at the top for the health of the player, and align the room to the bottom of the window.

```lua
MARGIN_TOP = VIRTUAL_HEIGHT - ROWS * TILE_SIZE
```

## graphics

`backgrounds.png` is retouched to have the texture span the updated width and height.
