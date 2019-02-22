# Tweening

Tweening boils down to how we change from one value to another.

## Old approach - previous.lua

One approach used so far is to change a value in the `update()` function, leveraging the `dt` argument. For instance and to move a shape from left to right, over a set period of time, this approach materializes itself as follows:

- define a variable to keep track of the passing of time, as well as a variable describing the coordinate of the shape;

- in the `update(dt)` function, increment the timer variable by `dt` and increase the horizontal coordinate to progressively move the shape;

- in the `render()` function use the (changing) horizontal coordinate to define the position of the shape.