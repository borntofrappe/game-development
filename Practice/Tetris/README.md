# Tetris

Recreate the game Tetris considering the black and white version for the Game Boy console.

## Resources

The `res` folder includes the `push` library to scale the window while maintaining a pixelated look, the same font used in `00 Pong`, once again to establish a retro look, and `spritesheet.png`, to describe the appearance of the bricks. The first row describes 5 types of bricks, plus one for the gameover screen and one for the columns describing the border of the playing area. The second row details the color palette.

## Source

`main.lua` imports the necessary resources from the `res` folder, and with regards to the script in the `src` folder, it requires the files through `Dependencies.lua`.

```lua
require "src/Dependencies"
```
