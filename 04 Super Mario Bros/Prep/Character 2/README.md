# Character 2

## Movement

The idea is to have the camera focused on the character. To this end, the script reintroduces `cameraScroll` with a value dependant on `characterX`.

```lua
cameraScroll = characterX + CHARACTER_WIDTH / 2 - VIRTUAL_WIDTH / 2
```

With this value, the character moves, and the camera matches the horizontal position to have the sprite always centered.

## Clamping

The horizontal movement is limited in two ways:

- prevent the character from exceeding the area described by the bricks

  On the left side, this means having a value of `0` at minimum.

  ```lua
  characterX = math.max(0, characterX - CHARACTER_MOVEMENT_SPEED * dt)
  ```

  On the right side, this means having a coordinate matching the width fo the bricks, minus the width of the character itself.

  ```lua
  characterX = math.min(mapWidth * TILE_SIZE - CHARACTER_WIDTH, characterX + CHARACTER_MOVEMENT_SPEED * dt)
  ```

- avoid having the scroll of the camera past the beginning and end of the level

  This means the camera scroll needs to be clamped as well. The values are the same as the ones introduced in `Tiles 1`, but are included in a single statement nesting `math.max` and `math.min` in the same line
