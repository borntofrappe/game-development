Here you set up a custom font and draw a few shapes.

**requires push.lua and font.ttf**

## Font

The font is included through a local `.ttf` file and as follows:

- in the `load()` function include the font through the `love.graphics.newFont()` function, specifying the font and the size

  ```lua
  -- assuming the font resides in the same folder:
  font = love.graphics.newFont('font.ttf', 8)
  ```

- again in the `load` function, set the font through the `love.graphics.setFont()` method, specifying the font itself

  ```lua
  love.graphics.setFont(font)
  ```

- in the `draw()` function, include the text exactly as before. The end result is that the font set in the `load` function is used for any dispayed on the screen

## Colors and shapes

In the `draw` function, the code updates the window in its color and the shapes being rendered. Similarly to the text, these changes leverage the `love.graphics` object.

- create a solid background

  the `clear()` function function details a color through an `rgba` code, provided with comma separated values.

  ```lua
  love.graphics.clear(r, g, b, a)
  ```

  **Important**: `r`, `g`, `b` and `a` are values in the [0-1] range

- draw rectangles for the paddles and the puck

  the `rectangle()` function accepts as argument a keyword detailing the look of the shape and the coordinates/sizes of the shape itself.

  Following the coordinate system described in a previous step, it details the rectangle starting with the top left corner and drawing it left to right, top to bottom.

  ```lua
  love.graphics.rectangle(mode, x, y, width, height)
  ```

  `mode` translates to one of two values: `fill` or `line`, to respectively draw a filled shape or just the outline.

For the puck, you can very well draw a circular shape instead of a rectangle, using `love.graphics.circle()`

```lua
love.graphics.circle(mode, x, y, r)
```
