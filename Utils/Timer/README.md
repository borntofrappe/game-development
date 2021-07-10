# Timer

The course introduces the timer module from the [knife](https://github.com/airstruck/knife) library to manage intervals, delays, tween animations. The goal of this folder is to try and replace the library with my own code.

Each sub-folder implements one of the three time-related features with a small demo:

- `Delay/main.lua` registers user input in the form of the coordinate of the mouse cursor. Only after a brief delay it uses the coordinates to include a point in the window

## Delay

`Timer:after` receives two arguments: the number of seconds for the delay and a callback function,

```lua
Timer:after(seconds, callback)
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
