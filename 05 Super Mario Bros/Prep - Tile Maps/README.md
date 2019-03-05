# Tile Maps

The 2D platformer manifests itself through a world made up of tiles.

## Update 0 - tile.lua

The goal with the first update is create a panel of tiles, positioned in the bottom half of the screen. To achieve this, we use **tiles.png** as follows:

- create quads for the different types of tiles. Here we create two quads, one for the visible square and the other for the adjacent, transparent cell. The idea is to use the first to describe the ground and the second the sky (as it is transparent, the sky is whatever is placed on the background);

- populate the screen with the quads, making use of constant variables identifying the type of tiles. The idea is to ultimately have an array of integers describing the world through different tiles.

The code expressed in `tile.lua` is quite straightforward after the necessary functions and resources are put into place: describe the quads through the `GenerateQuads()` function, as made available in `Util.lua` and include the quads through `love.graphics.draw()`.

To include the quads, it is helpful to reiterate the arguments accepted by the function.

- the texture, or image from which the quads are created;

- the actual quad responsible for the subsection of the image;

- the horizontal coordinate describing where the quad should be included;

- the vertical coordinate describing where the quad should be included;

- rotation;

- horizontal scale;

- vertical scale.

For the tiles the last three arguments are currently unnecessary, but for the background, they are used to have the quad scaled up to cover the entirety of the width and height of the screen.
