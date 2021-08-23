# Excavation

## Spritesheet

The `res` folder includes supporting material, among which `spritesheet.png`. With the image I managed to create a visual for the texture, gems and tools. These assets are ultimately divvied up in quads and used in the project through `love.graphics.draw`.

### Sizes

The tiles describing the texture are 8 pixels wide and tall. The gems come in three different sizes: 16, 24 and 32 pixels. The tools finally stretch 21 pixels horizontally and 22 pixels vertically.

### Colors

The spritesheet leans on a limited color palette.

_Please note:_ colors in Love2D describe rgb components in the `[0, 1]` range.

For the textures, there are seven types of maroons and greys:

- 0.392, 0.322, 0.255

- 0.475, 0.404, 0.239

- 0.569, 0.498, 0.349

- 0.659, 0.573, 0.396

- 0.651, 0.616, 0.580

- 0.749, 0.714, 0.678

- 0.694, 0.659, 0.624

For the gems, these use the first, darkest shade of maroon for the outline — 0.392, 0.322, 0.255 — while the inner glow is pure white — 1, 1, 1. What changes is the color chosen for the different varieties.

Blue:

- 0.549, 0.620, 0.996

- 0.384, 0.522, 1

Green:

- 0.522, 0.863, 0.388

- 0.451, 0.741, 0.29

Red:

- 1, 0.565, 0.522

- 0.965, 0.384, 0.353

Rose:

- 1, 0.792, 0.792

- 1, 0.902, 0.902

For the tools, the darkest shade of maroon is repeated for the handle of the pickaxe and hammer, while pure white is re-used in the outline. The difference between the tools boils down to the colors chosen for the fill.

Blueish:

- 0.71, 0.792, 0.945

- 0.318, 0.392, 0.804

Reddish:

- 0.91, 0.361, 0.333

- 0.714, 0.443, 0.388
