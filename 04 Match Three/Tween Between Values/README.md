# Tweening

Tweening boils down to how we change from one value to another.

## Previous approach - previous.lua

One approach used so far is to change a value in the `update()` function, leveraging the `dt` argument. For instance and to move a shape from left to right, over a set period of time, this approach materializes itself as follows:

- define a variable to keep track of the passing of time, as well as a variable describing the coordinate of the shape;

- in the `update(dt)` function, increment the timer variable by `dt` and increase the horizontal coordinate to progressively move the shape;

- in the `draw()` function use the (changing) horizontal coordinate to define the position of the shape.

## Problems with the old approach - problematic.lua

Once again, issues arise when there are multiple assets of which to keep track. This is highlighted in `problematic.lua`, where we have a table storing a reference to multiple shapes.

- immediately give to each shape `x` and `y` field, as well as a value for `rate`;

- in the `update(dt)` function modify `x` according to the rate expressed by `rate` and the passing of time expressed by `dt`;

- in the `draw()` function render each shape the specified values.

As the number of variable grows, as the number of properties we want to change grows, the approach starts to create some friction. In light of this, the new approach using the `knife` library proves to be more efficient and declarative in nature (describe what to do instead of how to modify each value).
