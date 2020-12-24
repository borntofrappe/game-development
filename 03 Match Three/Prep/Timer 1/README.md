The goal is to here consider multiple timers, counting upwards at different intervals. This shows the flaws of using variables: for every time you need a new set of variables, `timer2` and `seconds2`, and you need to update the variables independently.

```lua
function love.load()
  timer = 0
  seconds = 0

  -- count at twice the speed
  timer2 = 0
  seconds2 = 0
end

function love.update(dt)
  timer = timer + dt
  if timer > 1 then
    timer = timer % 1
    seconds = seconds + 1
  end

  timer2 = timer2 + dt
  if timer2 > 0.5 then
    timer2 = timer2 % 0.5
    seconds2 = seconds2 + 1
  end
end
```
