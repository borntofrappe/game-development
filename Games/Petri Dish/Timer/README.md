# Timer

In the projects introduced in the CS50 course, the lecturer introduces the `timer` module from the `knife` library, to manage delays, intervals, and tween animations. Here, I try to recreate the functionality with a series of dedicated functions.

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

## Tween

Inspired by the `knife` library, a tween operation is set up as follows:

```lua
Timer:tween(1, {
  [circle] = {
    ["r"] = 20
   }
})
```

The idea is to provide delta time, describing how long the tween operation should take, as well as a table describing which tables and which tables properties need to be updated.

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

This means the `Timer.tween` function needs to consider multiple layers, looping through the table to consider the tables first and the key-value pairs afterwards. In `Timer.lua`, I landed on the following structure.

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

`definition` is designed to be a table collecting a reference for the values which need to be updated. For every pair of the input definition

```lua
for ref, keyValuePairs in pairs(def) do
  local definition = {}
end
```

It stores a reference to the input table (consider `circle` or `circle1` from the snippets above), as well as another table, `keyValuePairs`.

```lua
local definition = {
  ["ref"] = ref,
  ["keyValuePairs"] = {}
}
```

By accessing the `ref` field, the timer is ultimately able to modify the original value.

### keyValuePair

`keyValuePair` stores the individual fields which need to be modified. For every set of key-value pairs.

```lua
for key, value in pairs(keyValuePairs) do
  local keyValuePair = {}
end
```

Itself, it describes the field, the desired value, as well as the change which needs to be applied in the update function.

```lua
local keyValuePair = {
  ["key"] = key,
  ["value"] = value,
  ["change"] = ???
}
```

The change is computed as the final value, minus the original measure. All divided by the input delta time.

```lua
["change"] = (value - ref[key]) / dt
```

### update

In the logic of the `update` function, the timer library needs to:

- loop through the available tweens, and in so doing update the connected timers

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

_Please note_: before removing the tween I've decided to loop one last time through the input arguments, in order to have the variables match the final value exactly. This works to avoid minor inconsistencies created by `dt`

```lua
for j, definition in ipairs(tween.def) do
  for k, keyValuePair in ipairs(definition.keyValuePairs) do
    definition.ref[keyValuePair.key] = keyValuePair.value
  end
end
-- remove tween
```
