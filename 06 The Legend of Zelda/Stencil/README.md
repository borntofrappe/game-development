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

  It does not however render the specific shape. In the demo, this is supplemented by drawing a circle before the stencil

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

## Hide

In the previous demo, the stencil is introduced to show shapes in a speficic area. However, it is possible to use the stencil for the opposite reason, to hide shapes in an arbitrary surface. This is ultimately why stencils are used in the game, to hide the player in the area covered by the doors.

What matters here is the mode set by the `setStencilTest` function.

```lua
love.graphics.setStencilTest("less", 1)
```
