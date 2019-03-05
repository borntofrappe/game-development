# Tile Maps

The 2D platformer manifests itself through a world made up of tiles. The idea is to use such images as available in the graphics folder under **tiles.png** and as follows:

- create quads for the different types of tiles. Here we create two quads, one for the visible square and the other for the adjacent, transparent cell. The idea is to use the first to describe the ground and the second the sky (as it is transparent, the sky is whatever is placed on the background);

- assign to each quad an index which describes its nature. In this instance this index is an integer describing the ground (1) or the sky (2);

- populate the screen with the quads, making use of the precise tile as needed. Always in the instance of this update, this means populating the bottom half of the screen with _ground_ tiles and the top half with _sky_ tiles.
