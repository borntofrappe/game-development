# Tween 0

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Match Three — Final`.

The goal is to have an image, found `bird.png`, which moves from side to side in two seconds. This is achieved by having a variable describing the duration.

```lua
MOVE_DURATION = 2
```

The variable is used to consider how much to update the horizontal position.

```lua
function love.load()
  timer = 0
end

function love.update(dt)
  if timer < MOVE_DURATION then
    timer = timer + dt
    bird.x = math.min(VIRTUAL_WIDTH - BIRD_WIDTH, bird.x + (VIRTUAL_WIDTH - BIRD_WIDTH) / MOVE_DURATION * dt)
  end
end
```

`VIRTUAL_WIDTH - BIRD_WIDTH` describes the space the image needs to cover.

`math.min` is used out of convenience to make sure the asset never exceeds the right edge of the window.
