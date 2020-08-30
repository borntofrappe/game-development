Recreate the pixelated game made playable from the "Play Games" application developed by Google.

## Updates

- feature: design start state with an ever bouncing player

- feature: design play state with hard-coded platforms

- feature: prompt a gameover when the player crosses the bottom of the screen

- feature: scroll vertically with the player. Above as it bounces on the platforms, below as it falls (for a limited section)

- style: design falling animation

- style: redesign the hat to have multiple versions with different colors

- feature: animate gameover state with player jumping on a solid v. crumbling platform

## Design

The font is the same font introduced in _Pong_.

The spritesheet is a work-in-progress created with GIMP.

| Visual      | x   | y   | width | height |
| ----------- | --- | --- | ----- | ------ |
| Player      | 0   | 0   | 39    | 33     |
| Hat         | 42  | 0   | 21    | 12     |
| Platform(s) | 0   | 33  | 63    | 24     |

The platforms have a different height, but are all designed in a box 63 wide by 24 tall. Since the player can only bounce on the top of a platform, having a transparent section at the bottom does not influence the gameplay; this simplifies the way the quads are created from the spritesheet.
