Recreate the gameplay of the popular game _Space Invaders_ with basic shapes.

## Shapes

As the title implies, the game is centered on basic shapes. Instead of aliens, include regular polygons, like squares, equilateral triangles, circles. For the player, draw a more complex shape with a polygon, or overlapping rectangles. Between the aliens and the player, include blocks to defend the player. These blocks are meant to provide a rudimentary shield, and are meant to be destroyed on contact.

## Gameplay

The idea is to populate the game window with rows and columns of shapes. The shapes are then moved horizontally until they hit the left or right edge, at which point they move downwards and reverse their movement.

At a random interval, the shapes in the bottom row fire projectiles toward the bottom. Following a key press instead, a projectile is fired from the player and toward the top. A collision results in the destruction of the player/alien, and for the blocks, in a portion of the shield.
