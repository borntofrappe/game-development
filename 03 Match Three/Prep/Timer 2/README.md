# Timer 2

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Match Three — Final`.

The script sets up a timer with the `knife/timer` library.

The idea is to create a global `Timer` object which manages the different intervals.

```lua
Timer = require('res/lib/knife/timer')
```

## Timer functions

The course introduces `Timer.every` and `Timer.after`. They function similarly in that they both receive two arguments: an amount of time, and a callback function.

```lua
Timer.every(interval, function()
  -- do something
end)

Timer.after(delay, function()
  -- do something
end)
```

Once set up, `every` will run the function at the prescribed interval. `after` would otherwise run the function after the arbitrary delay.

## Intervals

To illustrate the library, here's how you set up a single interval.

```lua
function love.load()
  counter = 0
  Timer.every(
    1,
    function()
      counter = counter + 1
    end
  )
end

function love.update(dt)
  Timer.update(dt)
end

function love.render()
  printf(
    counter,
    --...
  )
end
```

The demo shows how the approach scales better than the one described in `Timer 1`. A table keeps track of the time and interval values.

```lua
intervals = {1, 0.5, 4, 3}
counter = {0, 0, 0, 0}
```

An interval is set up for each interval through the `Timer` instance.

```lua
for i, interval in ipairs(intervals) do
  Timer.every(
    interval,
    function()
      counter[i] = counter[i] + 1
    end
  )
end
```

In the `update(dt)` function, `Timer.update(dt)` is then enough to update every single instance.

```lua
function love.update(dt)
  Timer.update(dt)
end
```

Adding an interval is a matter of including one more value in the `intervals` and `counter` table.

## ipairs

In the video, the timer is set up and rendered using a normal loop, iterating from `1` up to `n`, where `n` is the number of values in the two tables.

```lua
for i = 1, 4 do

end
```

You can improve this method using the actual length and with the `#` pound character.

```lua
for i = 1, #intervals do

end
```

In the script however, I decided to use `ipairs`.

```lua
for i, interval in ipairs(intervals) do

end
```

In this manner you have access to both the value of the table, and its index.
