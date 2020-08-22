Render and move the sprite for the character.

## Sprite(s)

The demo consider the sprites of the character from _character.png_. Each sprite is 16 wide by 20 tall, and the specific script renders the first sprite in the center of the game's window, on the very top of the first row. To this end, the logic to decide whether or not to render a row of bricks is modified.

```lua
local tile = {id = y < ROWS_SKY and TILE_SKY or TILE_GROUND}
```

This ensures it's enough to reference the same row for the character in order to position it appropriately atop the rows.

```lua
characterY = TILE_SIZE * (ROWS_SKY - 1) - CHARACTER_HEIGHT
```
