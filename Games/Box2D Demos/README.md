# Box2D Demos

The goal of this folder is to re-introduce the physics library Box2D, as first seen in the game `07 Angry Birds`. The library is used in the context of the Love2D game engine, and specifically looking at the code behind the `love.physics` module.

## Dynamic particles

With this first demo, the idea is to generate a world, and later populate this world as the mouse is pressed in the window.

### Physics-less circles

Without the use of `love.physics`, the demo first renders a series of circles as the mouse is pressed. This is useful to show the contribution of `love.physics` and how the simulation changes the code.

The idea is to have a table in which to store the information to draw the circles.

```lua
function love.load()
  circles = {}
end
```

`love.graphics.circle` function draws a circle using three pieces of information: the horizontal and vertical coordinates, and the radius.

```lua
love.graphics.circle("fill", cx, cy, r)
```

This means that all is necessary to have a circle drawn where the game registers a mouse click is a table with these values.

```lua
function love.mousepressed(x, y)
  table.insert(
    circles,
    {
      ["cx"] = x,
      ["cy"] = y,
      ["r"] = RADIUS
    }
  )
end
```

`love.mousepressed` provides the coordinates through the first and second arguments, while the radius is stored in a constant at the top of the script.

_Please note_: circles are added to the table also in `love.update`, as the game registers that the mouse is being pressed.

## Resources

- [Love2D physics](https://love2d.org/wiki/love.physics). The wiki describes in detail how the module works.

- [Box2D Physics](https://www.youtube.com/playlist?list=PLRqwX-V7Uu6Zy4FyZtCHsZc_K0BrXzxfE). The playlist from [TheCodingTrain Youtube channel](https://www.youtube.com/c/TheCodingTrain) illustrates the ideas reproduced in the folder. It provides more of inspiration than actual code, as the physics engine is introduced in the context of Processing (java).
