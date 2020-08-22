Render the sprite for the character.

## Sprite(s)

The demo consider the sprites of the character from _character.png_. Each sprite is 16 wide by 20 tall, and the specific script renders the first sprite in the center of the game's window.

## Clamp

The update clamps the value for the camera scroll on the left side, but also the right side. This considering the width of the tilesheet.

```lua
function love.update(dt)
  if love.keyboard.isDown("right") then
    cameraScroll = math.min(mapWidth * TILE_SIZE - VIRTUAL_WIDTH, cameraScroll + CAMERA_SCROLL_SPEED * dt)
  end
end

```

The left side was already covered in _Tiles 1_.
