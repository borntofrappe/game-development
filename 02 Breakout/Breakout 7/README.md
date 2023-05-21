# Breakout 7

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Breakout — Final`.

_Please note:_ the `ServeState` initializes the level at 12 to show more elaborate bricks.

```lua
function ServeState:init()
  self.level = 12

  -- other variables
end
```

Try a different value to see how the colors and tiers are progressively included in greater number.

## Brick

Update the class so that the tier and color are defined as the brick is initialized.

```lua
function Brick:init(x, y, tier, color)
  -- ...

  self.tier = tier
  self.color = color
end
```

## LevelMaker

The idea is to pass an integer to the `LevelMaker` function, and have this level influence the structure of the table.

```lua
self.bricks = LevelMaker.createMap(self.level)
```

As to refine the layout of the bricks, the function includes a series of flags:

- with `skipFlag` decide if the row should include bricks everywhere, or every other column

  Pick which column to skip with `skipOddsOrEven`

  ```lua
  local skipFlag = math.random(1, 5) == 1
  local skipOddsOrEven = math.random(2) == 1 and 1 or 0
  ```

- with `alternateFlag` decide whether or not to alternate between two colors.

  `colors` is defined as a table to hold two colors, and `colorsIndex` is initialized to 1 to refer to a specific hue

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

The color and tier are picked from a limited set, capped with `maxColor` and `maxTier`. The two are chosen on the basis of the level to progressively add more variety.

```lua
local maxColor = math.min(5, math.ceil(level / 2))
local maxTier = math.min(4, math.floor(level / 3))
```

There are 5 colors and 4 tiers, explaining the upper thresholds.
