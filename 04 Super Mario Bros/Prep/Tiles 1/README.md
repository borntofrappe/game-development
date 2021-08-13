# Tiles 1

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Super Mario Bros — Final`.

## Translate

The function in question is `love.graphics.translate`, accepting two arguments for the `x` and `y` translation.

```lua
love.graphics.translate(-math.floor(cameraScroll), 0)
```

Use the opposite value so fake the movement in the desired direction. When pressing right, for instance, the idea is to have the tiles move to the left, giving the illusion of moving to the right.

```lua
function love.update(dt)
  if love.keyboard.isDown("right") then
    cameraScroll = cameraScroll + CAMERA_SCROLL_SPEED * dt
  end
end
```

The illusion of movement is broken once you go past the left of the screen, or when you go to the right of the available tilesheet, but you can avoid this by clamping the scroll within the area in which the tiles are rendered. For instance and for the left side:

```lua
cameraScroll = math.max(0, cameraScroll - CAMERA_SCROLL_SPEED * dt)
```

## math.floor

The lecturer explains how the `math.floor` is necessary to have the game render correctly. This to maintain the pixelated artwork and resolution allowed by the `push` library.
