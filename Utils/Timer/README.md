# Timer

[CS50's Intro to Game Development](https://www.youtube.com/playlist?list=PLWKjhJtqVAbluXJKKbCIb4xd7fcRkpzoz) introduces a library to manage time-related events. The goal of this folder is to try and replace the library with my own code.

Each sub-folder implements one of the three time-related features with a small demo:

- `Delay/main.lua` registers user input in the form of the coordinate of the mouse cursor. Only after a brief delay it uses these coordinates to include a point in the window

- `Interval/main.lua` adds a particle at an interval. By pressing the letter `t` or the left button of the mouse cursor, the demo shows how to remove the interval with a label

- `Tween/main.lua` expands the demo created for delays by progressively reducing the radius of the points

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

As the counter variable exceeds the prescribed threshold the function does not remove the item from the table, but resets the counter variable instead.

```lua
if interval.timer >= interval.dt then
  interval.callback()
  interval.timer = interval.timer % interval.dt
end
```

### label

When setting up an interval, it is useful to associate a label to the table.

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

## Tween

A tween operation is set up as follows:

```lua
Timer:tween(1, {
  [circle] = {
    ["r"] = 20 -- animate the radius to 20 in 1 second
   }
})
```

The idea is to provide delta time, describing how long the tween operation should take, as well as a table describing which tables and which tables' properties need to update.

The structure ultimately allows for multiple operations to take place at the same time. For instance, updating the position and radius of two circles.

```lua
Timer:tween(1, {
  [circle1] = {
    ["cx"] = 0,
    ["cy"] = WINDOW_HEIGHT
    ["r"] = 20
  },
  [circle2] = {
    ["cx"] = WINDOW_WIDTH,
    ["cy"] = 0
    ["r"] = 20
  }
})
```

This means the `Timer.tween` function needs to consider multiple layers, looping through the table to consider the tables first and the key-value pairs afterwards.

In `Timer.lua`, I developed the feature as follows.

### tween

`tween` describes a table with a series of fields pertinent to the entire tween. Here you find the timer, the input delta time, but also the (optional) `label`.

```lua
local tween = {
  ["timer"] = 0,
  ["dt"] = dt,
  ["label"] = label
}
```

Most importantly, you also find `def`, a table collecting the pertinent information.

```lua
local tween = {
  -- other fields
  ["def"] = {}
}
```

### definition

`definition` is designed to be a table collecting a reference for the values which need to be updated. For every pair of the input definition:

```lua
for ref, keyValuePairs in pairs(def) do
  local definition = {}
end
```

The idea is to stores a reference to the input table (consider `circle` or `circle1` from the snippets above), as well as another table, `keyValuePairs`.

```lua
local definition = {
  ["ref"] = ref,
  ["keyValuePairs"] = {}
}
```

By accessing the `ref` field, the timer is ultimately able to modify the original value.

### keyValuePair

`keyValuePair` stores the individual fields which need to be modified. For every set of key-value pairs initialize a table.

```lua
for key, value in pairs(keyValuePairs) do
  local keyValuePair = {}
end
```

In the table describe the field, the desired value, as well as the change which needs to be applied in the update function.

```lua
local keyValuePair = {
  ["key"] = key,
  ["value"] = value,
  ["change"] = ???
}
```

The change is computed as the final value, minus the original measure divided by the input delta time.

```lua
["change"] = (value - ref[key]) / dt
```

### update

In the logic of the `update` function, the timer library needs to:

- loop through the exis tweens to update the connected timers

  ```lua
  for i, tween in ipairs(self.tweens) do
    twee.timer = tween.timer + dt
  end
  ```

- loop through the tweens' definitions

  ```lua
  for j, definition in ipairs(tween.def) do
  end
  ```

- loop through the tweens' definitions' key value pairs

  ```lua
  for k, keyValuePair in ipairs(definition.keyValuePairs) do
  end
  ```

- access the original value and modify the value with `change`

  ```lua
  definition.ref[keyValuePair.key] = definition.ref[keyValuePair.key] + keyValuePair.change * dt
  ```

Finally, and outside of the nested structure, the library checks if the timer reaches the prescribed delta time, and if so removes the tween from the parent table `self.tweens`.

```lua
if tween.timer >= tween.dt then
  table.remove(self.tweens, i)
end
```

_Please note_: before removing the tween I've decided to loop one last time through the input arguments, in order to have the variables match the final value exactly. This works to avoid the inconsistencies created by `dt`.

```lua
for j, definition in ipairs(tween.def) do
  for k, keyValuePair in ipairs(definition.keyValuePairs) do
    definition.ref[keyValuePair.key] = keyValuePair.value
  end
end
-- remove tween
```

## Updates

- `Timer:tween()` is updated to receive a callback function

  ```diff
  function Timer:tween(dt, def, label)
  +function Timer:tween(dt, def, callback, label)
  ```

  The idea is to execute the code as the animation is completed, and before removing the individual tween.

  ```lua
  if tween.callback then
    tween.callback()
  end
  ```
