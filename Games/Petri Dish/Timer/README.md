# Timer

In the projects introduced in the CS50 course, the lecturer uses the `timer` module from the `knife` library to manage delays, intervals, tween animations. Here, I try to recreate the functionality with a series of lua functions.

## Delay

A delay is called by specifying an amount of time and a specific action to.

```lua
Timer:after(1, function()
  -- do something after a second
end)
```

To execute the body of the function after the specified delta time, `Timer` is initialized with a table describing all possible delays.

```lua
function Timer:new()
  this = {
    ["delays"] = {}
  }
end
```

`after` works by adding a delay in the form of a table, describing the received values, but also a counter variable `timer`.

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

`Timer:update` then loops through the existing delays to update `timer`.

```lua
for i, delay in ipairs(self.delays) do
  delay.timer = delay.timer + dt
end
```

In the moment the variable exceeds delta time, it then proceeds to call the callback function, and to remove the delay from the corresponding table.

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

In the `if` statement of the `update` function then, and instead of removing the table, the idea is to reset the counter variable.

```lua
if interval.timer >= interval.dt then
  interval.timer = 0
  interval.callback()
end
```

## label and remove

A label is useful to have a reference for the delays/intervals/tweens, in order to then remove their logic if necessary. This is particularly useful in the context of intervals.

The `after` and `every` function are therefore updated to accept an additional argument.

```lua
function Timer:every(dt, callback, label)
end
```

`Timer` is then updated with a `remove` function which loops through the existing delays, through the existing intervals, to remove the event specified by the input label.

```lua
function Timer:remove(label)
  for i, interval in ipairs(self.intervals) do
    if interval.label == label then
      return table.remove(self.intervals, i)
    end
  end

  -- repeat for delays
end
```

## main

In `main.lua`, the `Timer` library is used for a few trivial examples:

- count the number of seconds, and stop the interval by pressing a specific key

- add a circle at the coordinates specified by the mouse cursor, and with a small delay
