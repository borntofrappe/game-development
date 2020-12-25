# Spritesheet

Similar to previous projects, the game makes use of a large image, a texture which is sectioned in quads. The folders here explore the functions ultimately incorporated in `Utils.lua`, to render the characters, entities, and rooms.

## Entities

_Please note_: the `GenerateQuadsEntities` function is considerably different from the one introduced by the lecturer, and it was first created in the context of _08 Pokemon_.

`entities.png` provides a spritesheet for eight entities, each with four possible directions and each direction with three possible frames; these last frames are used to animate the movement of the entities. Considering this structure, the goal of `GenerateQuadsEntities` is to build a data structure similar to the following (and for each entity):

```text
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

## Character

_Please note_: the image `character.png` has been modified to follow the same scheme set up in `entities.png`, and specifically regarding the order of the directions.

`character.png` describes the characters with in different directions/frames, but also specific modes (walking, picking up a pot, walking with a pot) and different sizes (using the sword). `GenerateQuadsCharacter` needs to therefore account for all possible scenarios.

Starting with the desired data structure, it is possible to sketch a table similar to the one designed for the entities.

```text
mode
  \_ direction (n times)
      \_ frame (m times)
```

The first three modes are separated horizontally by `16` pixels, but all share the same surface of `16x32`. The last mode, however, covers an area of `32x32`. This means that ultimately, and in order to avoid a shift in the position of the sprite, the render function needs to compensate the different width.

## Room

Considering `tilesheet.png`, the `GenerateQuads` function is able to divvy up the larger texture in quads of `16x16` size. This is more immediate than the previous demos, but additional work is required to actually draw the room in `main.lua`. This is because specific quads are positioned in a specific configuration.

`ROOM_IDS` is initialized as a reference table, describing the number of particular tiles. The `newRoom` function proceeds to then create a two-dimensional table consisting of the room's corner, sides and terrain. Please note that these are nested one level in the table to accommodate for the doors, which themselves occupy an area of `2x2` each. A tile, labeled "empty" is used in the edges to compensate for this offset.

## Others

The game makes use of two additional quads, for the hearts and switch. Their structure is however exceedingly straightforward, as the frames are laid horizontally in rectangles of `16x16` and `16x18` respectively.
