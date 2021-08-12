# Character 4

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Super Mario Bros — Final`.

## Gravity

The logic is similar to `Flappy Bird`: initialize a variable describe the gravity, and have this variable modify the `y` coordinate with an increasing influence. The difference is that the gravity is reset when the character reaches the row of the bricks.

```lua
if characterY > TILE_SIZE * (ROWS_SKY - 1) - CHARACTER_HEIGHT then
    characterY = TILE_SIZE * (ROWS_SKY - 1) - CHARACTER_HEIGHT
    characterDY = 0
  end
```

I decided to also include a boolean in `jumping`, so to update `characterDY` conditional to the variable being true.

```lua
if jumping then
  characterDY = characterDY + GRAVITY
  characterY = characterY + characterDY * dt
end
```

This makes it even more accurate to allow for only one jump at a time.

```lua
if key == "space" then
  if not jumping then
    jumping = true
    characterDY = -CHARACTER_JUMP_SPEED
  end
end
```

## Animation

The jumping state relies on a single frame, included through a specific animation.

```lua
jumpingAnimation =
  Animation(
  {
    frames = {3},
    interval = 1
  }
)
```
