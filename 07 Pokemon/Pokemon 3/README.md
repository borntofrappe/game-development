# Pokemon 3

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Pokemon — Final`.

## Entities

`entities.png` contains a series of sprites for the player, as well as other creatures. The spritesheet is structured in a rather fixed way, where each entity has 12 different states. In light of this, `GenerateQuadsEntities` builds a multidimensonal table in which entity is described by:

- direction: `down`, `left`, `right`, `up`

- variant: `1`, `2`, `3`

The goal is to ulimately have the script pick an entity:

```lua
-- first female character
gFrames["entities"][1]
```

A direction:

```lua
-- looking down
gFrames["entities"][1]["down"]
```

One of the available three variants:

```lua
-- standing still
gFrames["entities"][1]["down"][2]
```

## PlayState

The update focuses on the `gFrames["entities"]` table, but in the play state, the game modifies the code to show an item in this table. By pressing `r`, the idea is to pick an entity at random, while by pressing the arrow keys or the first three numbers, the idea is to modify the direction and variant of the chosen sprite.
