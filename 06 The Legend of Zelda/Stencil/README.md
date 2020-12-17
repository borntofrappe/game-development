# Stencil

The lecturer introduces a stencil through the `love.graphics.stencil`, `love.graphics.setStencilTest` functions. Through a couple of demos, I try to explain the concept by hiding/showing parts of a window.

## Show

A stencil is set up in two steps:

- include a stencil with `love.graphics.stencil`

  ```lua
  love.graphics.stencil(stencilFunction, "replace", 1)
  ```

  The function accepts three arguments: a function which itself describes the shape of the stencil, as well as a mode and pixel value. `replace` and `1` means that pixel values `1` will be replaced in the stencil area

  This is important: `stencilFunction` works similarly to `love.draw`, by listing a series of shapes

  ```lua
  local function stencilFunction()
    love.graphics.circle("fill", spotlight.x, spotlight.y, spotlight.r)
  end
  ```

  It does not however render the specific shape. In the demo, this is supplemented by drawing a circle before the stencil.

- describe which elements are impacted by the stencil in between two calls to the `love.graphics.setStencilTest` function

  The first function describes the type of drawing allowed by the stencil.

  ```lua
  love.graphics.setStencilTest("greater", 0)
  ```

  The mode of `greater` and the pixel value of `0` make possible that pixel values greater than `0` are shown in the stencil area.

  The second function wraps the stencil so that later shapes aren't affected.

  ```lua
  love.graphics.setStencilTest()
  ```
