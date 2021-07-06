# Tween 1

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Match Three — Final`.

The procedure described in `Tween 0` is repeated for multiple copies of the image. Each time, the asset is moved at a different pace, with maximum time of `10` seconds.

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
        rate = math.random() * TIMER_MAX
      }
    )
  end
end
```

In the `update` function then, each `rate` value is used to move the images to the right.

```lua
function love.update(dt)
  if timer < TIMER_MAX then
    timer = timer + dt
    for k, bird in pairs(birds) do
      bird.x = math.min(VIRTUAL_WIDTH - BIRD_WIDTH, bird.x + (VIRTUAL_WIDTH - BIRD_WIDTH) / bird.rate * dt)
    end
  end
end
```

Once again, using `VIRTUAL_WIDTH - BIRD_WIDTH` to describe the space the images need to cover, and `math.min` to limit the movement to the right edge of the window.

## Random rate

In the script I use `math.random() * TIMER_MAX` to generate the rate of the images. In the video, the lecturer provides a different, but similar solution.

```lua
rate = math.random() + math.random(TIMER_MAX - 1)
```

The issue is that using `math.random(TIMER_MAX)` has the effect of providing a random integer up to and including `TIMER_MAX`. `math.random()` on the other hand, provides a random float in the `[0, 1)` range. The two lines of code are therefore two different ways of providing a random float in the `[0, 9)` range.
