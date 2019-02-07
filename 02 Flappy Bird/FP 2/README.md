# Flappy Bird 2 - Bird Class

The update brings back the `class.lua` file to work with classes. The bird introduced in the game is initialized with a class.

## Creating a Class

In a separate file, a bird class is created with the following fields:

- `image`, referencing the graphic through the `love.graphics.newImage()` function;

- `width`, referencing a value which can be natively retrieved from the image, through the `:getWidth()` function. This is a function available on the image class.

- `height`, which mirrors the consideration for the width, but appropriately using `:getHeight()`;

- `x` and `y`, centering the asset in the screen

Just remember to use the `self` keyword in the `:init()` function, and to offset the `x` and `y` coordinates by the size of the image (always considering the top down, left to right coordinate system).

`love.graphics.newImage()` creates the asset. To ultimately draw the image on the screen however, it is necessary to use the `love.graphics.draw()` function. Just like a paddle in pong, include such a statement in a `:render()` function.

## Using a Class

In `main.lua`, using a class means 'importing' it atop the file, accessing its values through `.` dot or `[]` square bracket notation and use its functions through following a `:` colon after the class's name.
