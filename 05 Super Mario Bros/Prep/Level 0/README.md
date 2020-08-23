Generate a level with varying features.

## Utils

Before diving in how to generate different elvels every time the game is launched, it's necessary to build a table with the quads necessary to render different tiles and tiles' tops. To this end, refer to "tiles.png" and "tiles_tops.png"; each variant occupies a space of 80x64 pixels, with each graphic subsequently sized 16x16. This includes empty tiles, used to render nothing and show the background through.

> _Please note_: I've modified "tiles.png" to fix an error from the original codebase. This error relates to having the marron variant in the sixth row, first column already equipped with a tile top.

## Procedural generation

The idea is to loop through the level column by column and, depending on the value of a flag, include a specific set of tiles. For instance:

- generate a chasm by rendering empty tiles

- generate pillars by rendering more bricks than usual
