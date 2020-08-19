Recreate the popular game _Space Invaders_, taking inspiration from the art style of the super game boy variant.

## Design

For the font, I decided to use [DM Mono](https://fonts.google.com/specimen/DM+Mono?sort=popularity&category=Monospace&preview.text=10+POINTS&preview.text_type=custom).

For the graphics, you find in the _res_ folder a couple of images created with [GIMP](https://www.gimp.org/) to try and emulate the look and feel of the game.

The following color palette is used for the title in _title.png_:

- rgb(36, 191, 97)

- rgb(252, 197, 34)

- rgb(230, 126, 0)

Consider using the same colors throughout the game.

The following table works as a reference for the size of the individual quads in _shape-invaders.png_

| Visual      | Width | Height |
| ----------- | ----- | ------ |
| Alien       | 8     | 7      |
| Bonus Alien | 13    | 6      |
| Player      | 9     | 7      |
| Projectile  | 1     | 6      |

## Update 0 — title

Render a screen with the title, above a basic instruction on how to proceed. Use the `timer` module from the **knife** library, to animate the scene.
