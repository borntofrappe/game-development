# Timer

The course introduces the timer module from the [knife](https://github.com/airstruck/knife) library to manage intervals, delays, tween animations. The goal of this folder is to try and replace the library with my own code.

Each sub-folder implements one of the three time-related features with a small demo:

- `Delay/main.lua` registers user input in the form of the coordinate of the mouse cursor. Only after a brief delay it uses the coordinates to include a point in the window

- `Interval/main.lua` adds a particle every so often. By pressing the letter `t` or the left button of the mouse cursor, the demo shows how to remove the interval with a label

## Delay

`Timer:after` receives two arguments: the number of seconds for the delay and a callback function,

```lua
Timer:every(1, function()
  -- do something after a second
end)
```

`Timer` keeps track of the delay in a table initialized as the class is first created.

```lua
function Timer:new()
  local this = {
    ["delays"] = {}
  }
end
```

The delay is then included in the body of the `after` function, with a table describing three keys: `timer`, `dt` and `callback`.

```lua
function Timer:after(dt, callback)
  local delay = {
    ["timer"] = 0,
    ["dt"] = dt,
    ["callback"] = callback
  }
  table.insert(self.delays, delay)
end
```

With this setup, `Timer:update` loops through the existing delays to update each `timer` key, using the delta time value obtained through `love.update(dt)`.

```lua
Timer:update(dt)
  for k, delay in pairs(self.delays) do
    delay.timer = delay.timer + dt
  end
end
```

In the moment the variable exceeds the stored `dt`, the idea is to then execute the code stored in the callback function.

```lua
if delay.timer >= delay.dt then
  delay.callback()
end
```

Since the delay is no longer necessary, the function finally removes the instance from the table.

```lua
if delay.timer >= delay.dt then
  delay.callback()
  table.remove(self.delays, i)
end
```

## Interval

An interval works similarly to a delay, but the idea is to execute the logic of the callback function repeatedly.

```lua
Timer:every(1, function()
  -- do something every second
end)
```

With this in mind, as the `timer` field exceeds the prescribed threshold the function does not remove the item from the table, but resets the counter variable instead.

```lua
if interval.timer >= interval.dt then
  interval.callback()
  interval.timer = interval.timer % interval.dt
end
```

### label

When setting up an interval, it is useful to have a label describing the interval.

```lua
function Timer:every(dt, callback, label)
end
```

Such a referene allows to remove the logic if need be.

```lua
function Timer:remove(label)
  for k, interval in pairs(self.intervals) do
    if interval.label == label then
      return table.remove(self.intervals, i)
    end
  end
end
```

By returning the removed item it is possible to obtain the interval following the `Timer:remove()` function call, not to mention terminate the function as well.

The feature is introduced in the context of intervals, but it is actually useful for delays and tweens as well. With this in mind, the `:after` and later `:tween` functions are updated to have a similar label.
