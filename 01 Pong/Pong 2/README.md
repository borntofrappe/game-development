# Pong 2

## Code

The new update to the project includes a custom font in the application run in Love2D. Such a font is included through a local `ttf` file and as follows:

- in the `load()` function include the font through the `love.graphics.newFont()` function, specifying the font and the size (as explained in the [docs](https://love2d.org/wiki/love.graphics.newFont)).

  Assuming it resides in the same folder:

  ```lua
  newFont = love.graphics.newFont('font.ttf', 8)
  ```

- once included, set the font through the `setFont` method, available on the same object and accepting the reference to the newly minted font. This again in the `load` function.

  ```lua
  love.graphics.setFont(newFont)
  ```

- in the `draw()` function, include the text exactly as before. The end result is the font, set in the `load` function, is given to any text dispayed on the screen.

Also in the same file, and specifically in the `draw` function, the snippet provides a few visuals through the `love.graphics` object.

This object is used to:

- create a solid background, through the `clear()` function;

  This function can detail a color through an `rgba` code, provided with comma separated values.

  ```lua
  love.graphics.clear(r, g, b, a)
  ```

  **Important**: `r`, `g`, `b` and `a` need to be a value in the [0-1] range and **not** in the [0-255] range one would reasonably assume.

- draw rectangles for the paddles and the 'puck' so to speak, through the `rectangle()` function.

  This function accepts as argument a keyword detailing the look of the shape and the coordinates/sizes of the shape itself. Following the coordinate system described before, it details the rectangle starting with the top left corner and drawing it left to right, top to bottom.

  ```lua
  love.graphics.rectangle(mode, x, y, width, height)
  ```

  _mode_ is simply a filler word which actually translates to one of two values: `fill` or `line`, to respectively draw a filled shape or just the outline.

These are included, as the `printf` statement, in between the virtual resolution set up with the `push` library.
