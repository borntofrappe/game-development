# Tween 2

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Match Three — Final`.

The approach described in `Tween 0` and `Tween 1` works, but becomes brittle the more values you need to change over time.

With this script, the goal is to change the position, but also the opacity of the images. `min.lua` shows how to achieve this with a series of variables, while `main.lua` incorporates the `knife/timer` library.

## Opacity

Change the opacity with the fourth argument of the `setColor` function.

```lua
love.graphics.setColor(1, 1, 1, alpha)
love.graphics.draw(BIRD_IMAGE, bird.x, bird.y)
```

## min

Without the library, you'd modify the opacity with an additional variable.

```lua
function love.load()
    for k, bird in pairs(birds) do
      -- previous attributes
      bird.opacity = 0
    end
end

function love.update(dt)
  if timer < TIMER_MAX then
    timer = timer + dt
    for k, bird in pairs(birds) do
      -- update bird.x
      bird.opacity = math.min(1, bird.opacity + 1 / bird.duration * dt)
    end
  end
end
```

## main

The `knife/timer` library provides a tween function in `Timer.tween`. The function accepts as argument a duration and a table defining the tween's own rules.

For instance and to modify the horizontal coordinate.

```lua
Timer.tween(bird.duration, {
  [bird] = { x = VIRTUAL_WIDTH - BIRD_WIDTH }
})
```

This has the effect of modifying the `x` attribute of the `bird` entity up to `VIRTUAL_WIDTH - BIRD_WIDTH`.

To modify the opacity as well, all you need is another key-value pair in the table describing which values to change.

```lua
Timer.tween(bird.duration, {
  [bird] = { x = VIRTUAL_WIDTH - BIRD_WIDTH, opacity = 1 }
})
```

In both instances, the `update` function needs to update the `Timer` object only.

```lua
function love.update(dt)
  Timer.update(dt)
end
```

Note that, when replaying the animation by pressing the letter `r` and before initializing a new set of tweens, the timer object is first cleared through the `Timer.clear()` function.

```lua
if key == "r" then
  Timer.clear()

  -- initialize tweens
end
```
