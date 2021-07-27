# Whirlybird

Recreate the pixelated game available in the "Play Games" application developed by Google.

## Resources

The font is the same font introduced in `00 Pong`.

In terms of graphics, `spritesheet.png` introduces the player and the different game objects.

| Visual                               | x   | y   | width | height |
| ------------------------------------ | --- | --- | ----- | ------ |
| Player                               | 0   | 0   | 39    | 33     |
| Player Flying                        | 39  | 0   | 36    | 42     |
| Player Falling                       | 147 | 0   | 39    | 45     |
| Player Particles                     | 198 | 45  | 27    | 27     |
| Hat                                  | 0   | 42  | 21    | 18     |
| Solid platform                       | 0   | 60  | 39    | 9      |
| Fading platform                      | 0   | 69  | 39    | 9      |
| Crumbling and moving platform, cloud | 0   | 78  | 39    | 15     |
| Trampoline and spikes                | 0   | 123 | 39    | 21     |
| Enemy                                | 0   | 165 | 39    | 39     |

For the gameover state, additional visuals are designed in `spritesheet-gameover.png`

| Visual                  | x   | y   | width | height |
| ----------------------- | --- | --- | ----- | ------ |
| Jumping, falling player | 0   | 0   | 45    | 48     |
| Check, exclamation mark | 0   | 96  | 30    | 24     |
| Play again              | 0   | 120 | 66    | 50     |
