# Breakout 7

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Breakout — Final`.

_Please note:_ the `ServeState` initializes a level of `12` to show a more elaborate level.

```lua
function ServeState:init()
  self.level = 12

  -- other variables
end
```

Try different value to see how the colors and tiers are progressively included in greater number.

## LevelMaker

The idea is to pass the level to the `LevelMaker` function, and have this integer influence the structure of the table.

`skipFlag` is useful to decide if a row includes bricks everywhere, or every other column.

```lua
for row = 1, rows do
  local skipFlag = math.random(1, 5) == 1

end
```

`skipOddsOrEven` is then used to either skip the odds or even numbers.

```lua
for row = 1, rows do
  local skipFlag = math.random(1, 5) == 1
  local skipOddsOrEven = math.random(2) == 1 and 1 or 0
end
```

`alternateFlag` is instead useful to alternate between two colors.

```lua
for row = 1, rows do
 local alternateFlag = math.random(1, 5) == 1
end
```

`colors` is defined as a table to hold two colors, and `colorsIndex` is initialized to `1` to refer to a specific hue.

```lua
local colors = {math.random(1, maxColor), math.random(1, maxColor)}
local colorIndex = 1
```

If the flag is then set to `true`, the idea is to update `colorsIndex` to refer to the other pick.

```lua
if alternateFlag then
  colorIndex = colorIndex == 1 and 2 or 1
end
```

## Colors and tiers

Bricks come in five colors and four tiers. Beside the mentioned flags, the idea is to use the level to limit the variety of colors and tiers.

```lua
local maxColor = math.min(5, math.ceil(level / 2))
local maxTier = math.min(4, math.floor(level / 3))
```
