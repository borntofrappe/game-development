# Chain 0

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Match Three — Final`.

The demo moves an image around the screen, considering each corner starting from the top left.

Without libraries, you are forced to use a set of conditionals. This approach is explained in the video starting from a table describing the four possible destination.

```lua
destinations = {
  [1] = {x = VIRTUAL_WIDTH - BIRD_WIDTH, y = 0},
  [2] = {x = VIRTUAL_WIDTH - BIRD_WIDTH, y = VIRTUAL_HEIGHT - BIRD_HEIGHT},
  [3] = {x = 0, y = VIRTUAL_HEIGHT - BIRD_HEIGHT},
  [4] = {x = 0, y = 0}
}
```

The idea is to have two variables to keep track of where the bird is coming from, `baseX` and `baseY`, and loop through the table in order and change the coordinates of the sprite one at a time.

To mark if a destination has been reached already, the script adds a boolean to the every entry in the table.

```lua
for k, destination in pairs(destinations) do
  destination.reached = false
end
```

This boolean is then used as a control value to update the `x` and `y` coordinates.

```lua
for i, destination in ipairs(destinations) do
    if not destination.reached then
      -- update x and y toward destination.x and destination.y

      break
    end
end
```

Using `ipairs` is more helpful, since the alternative `pairs` doesn't necessarily loop through the table in order.
