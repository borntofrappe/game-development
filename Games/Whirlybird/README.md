Recreate the pixelated game made playable from the "Play Games" application developed by Google.

## Updates

- bug: scroll the window to have the player at most half of the window's height

- feature: change the jumping behavior based on the type of the interactable

  - 3: break the platform

  - 5: jump through — add cloud to quads table

  - 6: jump higher

  - 7: game over

  - 8: game over, only with the third variety

- feature: animate interactables looping through the different varieties. Move the fourth and eight types horizontally.

- feature: allow to fall for a brief period before triggering the gameover. Use falling animation

- style: design sprites for a collision with the seventh and eight type of interactable

- style: design helper graphics to illustrate how to play

- feature: animate gameover state with player jumping on a solid v. crumbling platform

## Design

The font is the same font introduced in _Pong_.

For the spritesheet, the player and platforms are designed with different sizes.

| Visual                              | x   | y   | width | height |
| ----------------------------------- | --- | --- | ----- | ------ |
| Player                              | 0   | 0   | 39    | 33     |
| Player Flying                       | 39  | 0   | 36    | 42     |
| Player Falling                      | 147 | 0   | 39    | 45     |
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
