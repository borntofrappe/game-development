# Breakout 6 - Pretty Colors

The update changes the way levels are created, as to include bricks of different tiers and colors.

The idea is to alter the level created through `LevelMaker.lua`, in such a way that patterns of bricks are randomly created.

The lecturer introduces two flags:

- `skipFlag`

- `alternateFlag`.

The idea is to have these flags randomly be set to either true or false, and then alter the way bricks are created. In the first instance, bricks are skipped, in the latter, a different color is introduced.

Remember, the bricks have different tiers and colors. The `gFrames['bricks']` table ought to have 21 bricks, with four tiers and five colors, plus an extra brick style.

You can use this number to have the alternate flag go and reach for a brick at random.

In addition to this logic, the `createMap` function leverages an argument in `level`. The idea is to here use the current level of the game, a value which gets incremented each time the screen is cleared of all bricks, to influence the variety of brick. As bricks decrease in color and tier whenever they are hit (until blue, when the brick is made to disappear entirely), a higher level should provide higher tier and color vallues.

## Brick.lua

I decided to have the color and tier included in the instance of the `Brick` class, changing the `init` function to accept such values.

## LevelMaker.lua

Instead of using an alternate flag, I decided to create a variable for the highest tier and highest color which can be included in the level. These values are influenced by the level itself, with higher levels granting higher variety.

The tier and color are then decided at random, between 1 and this upper bound value, and are included in the instance of the brick class.

## StartState.lua

The `LevelMaker` leverages a level, so the start state needs to pass an integer describing the current level.
