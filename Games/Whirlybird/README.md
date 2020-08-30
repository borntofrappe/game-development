Recreate the pixelated game made playable from the "Play Games" application developed by Google.

## Updates

- style: design helper graphics to illustrate how to play

- style: redesign platforms to be less wide

- feature: scroll vertically with the player. Above as it bounces on the platforms, below as it falls

- style: design falling animation

- style: redesign the hat to have multiple versions with different colors

- feature: animate gameover state with player jumping on a solid v. crumbling platform

## Design

The font is the same font introduced in _Pong_.

For the spritesheet, refer to the following table.

| Visual      | x   | y   | width | height |
| ----------- | --- | --- | ----- | ------ |
| Player      | 0   | 0   | 39    | 33     |
| Hat         | 42  | 0   | 21    | 12     |
| Platform(s) | 0   | 33  | 63    | 24     |

The platforms have a different height, but are all designed in a box 63 wide by 24 tall. Since the player can only bounce on the top of a platform, having a transparent section at the bottom does not influence the gameplay; this simplifies the way the quads are created from the spritesheet.

For the color palette, refer to the following table.

| Color      | r   | g   | b   |
| ---------- | --- | --- | --- |
| background | 255 | 255 | 255 |
| grey       | 91  | 96  | 99  |
| blue       | 69  | 141 | 241 |
| green      | 42  | 173 | 83  |
| yellow     | 239 | 190 | 52  |
| red        | 238 | 61  | 73  |

Remember that love2d accepts color values in the [0, 1] range, as opposed to the [0, 255] range.
