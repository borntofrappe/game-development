Move the sprite for the character.

## Movement

For the movement, the script removes the logic for the camera scroll and in its place changes the `x` coordinate of the sprite.

```lua
function love.update(dt)
  if love.keyboard.isDown("right") then
    characterX = characterX + CHARACTER_MOVEMENT_SPEED * dt
  elseif love.keyboard.isDown("left") then
    characterX = characterX - CHARACTER_MOVEMENT_SPEED * dt
  end
end
```
