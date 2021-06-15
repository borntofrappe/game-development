# Breakout 7

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Breakout — Final`.

## Skip

The idea is to pass the level to the `LevelMaker` function, and have this integer influence the structure of the table. With a higher level, for instance, you can include more bricks, or bricks of a different color, appearance.

The idea is to include bricks in rows and columns, but skip cells with a definite probability.

```lua
for row = 1, rows do
  for col = 1, cols do
    skipFlag = math.random(1, 3) == 2 and true or false

    if not skipFlag then
      -- create and add brick
    end
  end
end
```

In this instance, a brick is created two out of three times.

## Colors and tiers

Bricks come in four colors and four tiers. The idea is to here set a maximum value, based on the level and capped at most at four, and then use `math.random` to specify the tier and color of the individual brick

```lua
maxTier = math.min(4, math.floor(level / 3))
maxColor = math.min(4, math.floor(level / 4))
tier = math.random(1, maxTier)
color = math.random(1, maxColor)
```

The way I use the level is tentative, but does the trick to provide more tiers and colors with a higher level.

**Please note** the `ServeState` initializes a level of `12` to show the different tiers.
