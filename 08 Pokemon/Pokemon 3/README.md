Render an entity in the `PlayState`.

## Entities

`entities.png` contains a series of sprites for the player, as well as other creatures. The spritesheet is structured in a rather fixed way, where each entity has 12 different states. In light of this, `GenerateQuadsEntities` builds a multidimensonal table in which entity is described by:

- direction: `down`, `left`, `right`, `up`

- variant: `1`, `2`, `3`

The goal is to ulimately have the game pick an entity:

    ```lua
    -- first female character
    gFrames["entities"][1]
    ```

Pick a direction:

    ```lua
    -- looking down
    gFrames["entities"][1]["down"]
    ```

Pick one of the available three variants:

    ```lua
    -- standing still
    gFrames["entities"][1]["down"][2]
    ```

## PlayState

The update focuses on the `gFrames["entities"]` table, but in the play state, the game modifies the code to show an item in this table. By pressing `r`, the idea is to pick an entity at random, while by pressing the arrow keys or the first three numbers, the idea is to modify the direction and variant of the chosen sprite.
