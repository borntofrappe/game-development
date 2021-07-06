# Timer 1

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Match Three — Final`.

The goal is to here consider multiple timers, counting upwards at different intervals. This shows the flaws of using variables: for every timer you need a new set of variables and you need to update the values independently.

```lua
function love.load()
  counter = 0
  seconds = 0
  interval = 1

  -- count at twice the speed
  counter2 = 0
  seconds2 = 0
  interval2 = 0.5
end

function love.update(dt)
  counter = counter + dt
  if counter > interval then
    counter = counter % interval
    seconds = seconds + interval
  end

  -- count at twice the speed
  counter2 = counter2 + dt
  if counter2 > interval2 then
    counter2 = counter2 % interval2
    seconds2 = seconds2 + 1
  end
end
```
