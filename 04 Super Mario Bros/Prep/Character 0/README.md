# Character 0

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Super Mario Bros — Final`.

## Sprite

The demo consider the sprites of the character from `character.png`. Each sprite is 16 pixels wide by 20 tall, and the specific script renders the first sprite in the center of the game's window, on the top of the first row. To this end, the logic to decide whether or not to render a row of bricks is slightly modified.

```lua
local tile = {id = y < ROWS_SKY and TILE_SKY or TILE_GROUND}
```

This allows to reference the same row for the character in order to position the sprite above the bricks.

```lua
characterY = TILE_SIZE * (ROWS_SKY - 1) - CHARACTER_HEIGHT
```
