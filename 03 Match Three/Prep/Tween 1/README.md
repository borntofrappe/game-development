# Tween 1

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Match Three — Final`.

The procedure described in `Tween 0` is repeated for multiple copies of the image. The images move at different rates, reaching the right edge of the window in up to ten seconds.

```lua
TIMER_MAX = 10

function love.load()
  birds = {}
  for i = 1, 100 do
    table.insert(
      birds,
      {
        x = 0,
        y = math.random(0, VIRTUAL_HEIGHT - BIRD_HEIGHT),
        duration = math.random() * TIMER_MAX
      }
    )
  end
end
```

In the `update` function then, each `duration` value is used to move the images to the right.

```lua
function love.update(dt)
  if timer < TIMER_MAX then
    timer = timer + dt
    for k, bird in pairs(birds) do
      bird.x = math.min(VIRTUAL_WIDTH - BIRD_WIDTH, bird.x + (VIRTUAL_WIDTH - BIRD_WIDTH) / bird.duration * dt)
    end
  end
end
```

Once again, `VIRTUAL_WIDTH - BIRD_WIDTH` describes the space the images need to cover, and `math.min` limits the movement to the right edge of the window.

## Random value

`math.random() * TIMER_MAX` provides the duration for a single image. In the video, the lecturer provides a different, but similar solution.

```lua
duration = math.random() + math.random(TIMER_MAX - 1)
```

The issue is that using `math.random(TIMER_MAX)` has the effect of providing a random integer up to and including `TIMER_MAX`. `math.random()` on the other hand, provides a random float in the `[0, 1)` range. The two lines of code are therefore two different ways of providing a random float in the `[0, 9)` range.
