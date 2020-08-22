Allow the character to jump by modifying the `y` coordinate.

## Gravity

The logic is similar to _Flappy Bird_: Have a variable describe the gravity, and have this variable modify the y coordinate with an increasing influence. The difference is that the gravity is reset when the character reaches the level of the bricks.

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

The animation is included to loop through the second and third sprite. This animation is included as the `space` key is pressed, and is replaced by the previous two — moving and idle — when the character stops jumping.

```lua
jumpingAnimation =
  Animation(
  {
    frames = {3, 2},
    interval = 0.3
  }
)
```
