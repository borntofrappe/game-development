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

## New approach - main.lua

Here we want to change the horizontal coordinate as well as the opacity of the shapes.

The opacity is modified by `love.graphics.setColor()`, and specifically the fourth argument. Remember, anything that is drawn on page (text, but also shapes and images) gets modified by the `setColor` function, which is this instance alters the opacity.

Starting from the old(er) approach:

- include an additional field in the table, `opacity`

- update the value over time in the `update(dt)` function

- use the value in the `setColor` function when rendering the shapes.

This works, but the coordinate and the opacity are modified separately. Any additional value requires additional considerations, and this is where the new(er) approach proves its worth. Instead of having separate calls to the properties, we describe a `Timer` object with a tween. The tween is then responsible to alter the values in a much more compact manner.

- in the `load` function set up the tween:

  ```lua
  -- loop through the table
  for k, shape in pairs(shapes) do
    -- go to endX and opacity 1
    Timer.tween(shape.rate, {
      [shape] = { x = endX, opacity = 1}
    })
  end
  ```

  `Timer.tween` accepts as argument the period of time the tween should take and the final values assumed by the tween. Notice how these values are specified in a table and passed to `[shape]`, in between `[` square brackets `]`. This syntax allows to assign the `x` and `opacity` values to the fields in the `shape` table bearing the same name.

- in the `update(dt)` function update the entire thing with `Timer.update(dt)`.

You can start to see the declarative nature of the approach: 'I want you to go to these values at this rate'.
