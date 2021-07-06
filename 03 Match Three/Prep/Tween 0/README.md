# Tween 0

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Match Three — Final`.

The goal is to move an image from the `res/graphics` folder from side to side and in the span of two seconds. This is achieved by having a variable describing the duration.

```lua
MOVE_DURATION = 2
```

The variable is used alongside a counter variable keeping track of delta time. As the counter increases, the position of the image is updated considering the remaining width.

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

`VIRTUAL_WIDTH - BIRD_WIDTH` describes the space the image needs to cover. `math.min` is used out of convenience to make sure the asset never exceeds the right edge of the window.

To highlight the feature, note how `love.keypressed` resets the timer and horizontal coordinate by pressing the letter `r`.

```lua
if key == "r" then
  bird.x = 0
  timer = 0
end
```
