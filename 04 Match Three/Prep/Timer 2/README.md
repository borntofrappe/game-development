The script sets up a timer with a library. For the library, refer to _timer.lua_ in the `knife` modules.

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

Once set up, `every` will run the function at the prescribed interval. `after` would otherwise run the function after the decided delay.

## Interval(s)

To illustrate the library, here's how you set up a single interval.

```lua
function love.load()
  seconds = 0
  Timer.every(
    1,
    function()
      seconds = seconds + 1
    end
  )
end

function love.update(dt)
  Timer.update(dt)
end

function love.render()
  printf(
    seconds,
    --...
  )
end
```

Ultimately, the update scales this approach to consider multiple intervals, with a table storing the intervals and one the number of seconds.

```lua
intervals = {1, 0.5, 4, 3}
seconds = {0, 0, 0, 0}

for i, interval in ipairs(intervals) do
  Timer.every(
    interval,
    function()
      seconds[i] = seconds[i] + 1
    end
  )
end
```

In the `update(dt)` function, `Timer.update(dt)` is enough to update every single instance.

```lua
function love.update(dt)
  Timer.update(dt)
end
```

Adding an interval, then, is a matter of including one more value in the `intervals` and `seconds` table.

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
