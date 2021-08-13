# Character 1

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Super Mario Bros — Final`.

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
