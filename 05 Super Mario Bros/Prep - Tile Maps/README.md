# Tilemaps

The 2D platformer manifests itself through a world made up of tiles.

## Update 0 - tile.lua

The goal of the first update is create a panel of tiles, positioned in the bottom half of the screen. To achieve this, we use **tiles.png** as follows:

- create quads for the different types of tiles. Here we create two quads, one for the visible square and the other for the adjacent, transparent cell. The idea is to use the first to describe the ground and the second the sky (as it is transparent, the sky is whatever is placed on the background);

- populate the screen with the quads, making use of constant variables identifying the type of tiles. The idea is to ultimately have an array of integers describing the world through different codes.

The code expressed in `tile.lua` is quite straightforward after the necessary functions and resources are put into place: describe the quads through the `GenerateQuads()` function and include them through `love.graphics.draw()`.

To include the quads, it is helpful to reiterate the arguments accepted by the function.

- texture, the image from which the quads are created;

- quad, the actual quad responsible for the subsection of the image;

- x, the horizontal coordinate describing where the quad should be included;

- y, the vertical coordinate describing where the quad should be included;

- r, the rotation of the quad;

- xScale, the horizontal scale;

- yScale, vertical scale.

For the tiles making up the cells the last three arguments are currently unnecessary. For the background however, they are used to have the quad scaled up to cover the entirety of the width and height of the screen.
