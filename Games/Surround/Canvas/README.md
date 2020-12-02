# Canvas

The [wiki page](https://love2d.org/wiki/Canvas) introduces the canvas as a way to render elements which do not change frequently, with the idea of reducing the number of drawing operations. In the final game, this is not actually why the canvas is used, but to get started, it is useful to create a demo showcasing the more "static" usefulness.

## Static

The demo illustrates how to initialize, set up and ultimately draw a checkered pattern. To a smaller degree, it is also useful to demonstrate how transparency values are affected by the blend mode.

In `love.load`:

- initialize a canvas with `love.graphics.newCanvas`

- set up the current canvas with `love.graphics.setCanvas`, passing as input the newly initialized object

- describe what to draw in the canvas

- stop the scope of the current canvas calling again `love.graphics.setCanvas`, this time without arguments

Finally in `love.draw`:

- reset the color value with `love.graphics.setColor(1, 1, 1, 1)`

- (optional) set a blend mode with `love.graphics.setBlendMode`

- draw the actual canvas passing the object to the `love.graphics.draw` function

## Dynamic

The demo sets up two canvases to show a different perspective of the same world. It is important to note that both canvases render the same visuals, the same rectangle.

```lua
love.graphics.rectangle("fill", rectangle.x, rectangle.y, CELL_SIZE, CELL_SIZE)
```

What changes is the translation applied before this drawing operation.

It is also important to stress how the `love.draw` function draws a canvas through `love.graphics.draw`, and it is necessary to update the canvas itself in order to see the changes take place.