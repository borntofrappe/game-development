Recreate the pixelated game made playable from the "Play Games" application developed by Google.

## Roadmap

- suggestion: refactor interactable #8 into enemy. Move horizontally and vertically

- style: design helper graphics to illustrate how to play

- style: design additional animation for gameover state

## Design

The font is the same font introduced in _Pong_.

For the spritesheet, the player and platforms are designed with different sizes.

| Visual                              | x   | y   | width | height |
| ----------------------------------- | --- | --- | ----- | ------ |
| Player                              | 0   | 0   | 39    | 33     |
| Player Flying                       | 39  | 0   | 36    | 42     |
| Player Falling                      | 147 | 0   | 39    | 45     |
| Player Particles                    | 198 | 45  | 27    | 27     |
| Hat                                 | 0   | 42  | 21    | 18     |
| Solid platform                      | 0   | 60  | 39    | 9      |
| Fading platform                     | 0   | 69  | 39    | 9      |
| Crumbling and moving platform,cloud | 0   | 78  | 39    | 15     |
| Trampoline and spikes               | 0   | 123 | 39    | 21     |
| Enemy                               | 0   | 165 | 39    | 39     |

Side by side you find different versions, to use when animating the visuals.

For the palette, the game relies on the following colors.

| Color      | r   | g   | b   |
| ---------- | --- | --- | --- |
| background | 255 | 255 | 255 |
| grey       | 91  | 96  | 99  |
| blue       | 69  | 141 | 241 |
| green      | 42  | 173 | 83  |
| yellow     | 239 | 190 | 52  |
| red        | 238 | 61  | 73  |

Remember that love2d accepts color values in the [0, 1] range, as opposed to the [0, 255] range.
