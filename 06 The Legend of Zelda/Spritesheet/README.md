# Spritesheet

Similar to previous projects, the game makes use of a large image, a texture which is sectioned in quads. The folders here explore the functions ultimately incorporated in `Utils.lua`, to render the characters, entities, and rooms.

## Entities

_Please note_: the `GenerateQuadsEntities` function is considerably different from the one introduced by the lecturer, and it was first created in the context of _08 Pokemon_.

`entities.png` provides a spritesheet for eight entities, each with four possible directions and each direction with three possible frames; these last frames are used to animate the movement of the entities. Considering this structure, the goal of `GenerateQuadsEntities` is to build a data structure similar to the following (and for each entity):

```lua
entity
  \_ direction
      \_ frame
      \_ frame
      \_ frame
  \_ direction
      \_ frame
      \_ frame
      \_ frame
  \_ direction
      \_ frame
      \_ frame
      \_ frame
  \_ direction
      \_ frame
      \_ frame
      \_ frame
```

With this structure, it is possible to render a specific sprite by choosing a specific combination:

```lua
gFrames[entity][direction][frame]
```

The code is legible enough to understand the function's logic, but for the sake of documentation, it is worth mentioning tgat `entity` and `frame` describe an integer value, while `direction` is set to match the arrow keys.

The demo creates the quads and proceeds to render a specific entity/direction/frame combination. By pressing a series of keys then, the idea is to show different frames with the following logic:

- by pressing `tab` or `r`, pick a different entity

- by pressing an arrow key, consider the previous direction. If this direction matches the key, increment the frame to show the character's movement; else, change the direction altogether
