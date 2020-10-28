# Box2D Demos

The goal of this folder is to re-introduce the physics library Box2D, as first seen in the game `07 Angry Birds`. The library is used in the context of the Love2D game engine, and specifically looking at the code behind the `love.physics` module.

## Dynamic particles

With this first demo, the idea is to generate a world, and later populate this world as the mouse is pressed in the window.

_Please note_: the folder `Dynamic particles` contains multiple files, which work to develop the demo in increments. Remember that Love2D runs the code found in a file labeled `main.lua`.

- `min.lua` details the code necessary to draw circles, without the contribution of Box2D. Refer to the section [_Physics-less circles_](#physics-less-circles).

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

### Physics-filled objects

In order to emulate physics, it is first necessary to set up a world.

```lua
world = love.physics.newWorld(0, 9.81 * METER, true)
```

`love.physics.newWorld` accepts two arguments for the horizontal and vertical gravity. Here I use `9.81`, roughly describing the Earth's gravity, alongside a scaling factor, `METER`.

```lua
METER = 80

function love.load()
  love.physics.setMeter(METER)
end
```

This scaling factor is introduced to accommodate the fact that Box2D works in meters, but the game itself reasons with pixel units.

Once initialized, all that is necessary to update the world is a call to its `update` functio.

```lua
function love.update(dt)
  world:update(dt)
end
```

The function takes care of simulating the world's physics, the position and movement of its objects and constraints. The next step is to therefore include objects to the world. This is done in three steps:

- define a body, detailing the world, its position and type

  ```lua
  love.physics.newBody(world, x, y, "dynamic")
  ```

  There are three types:

  - dynamic, subject to the world's gravity and forces

  - static, immovable objects

  - kinematic, movable objects, but not subjects to gravity

- define a shape

  ```lua
  love.physics.newCircleShape(RADIUS)
  ```

  In this instance, `newCircleShape` only requires the radius of the shape

- define a fixture, connecing the body and shape

  ```lua
  love.physics.newFixture(body, shape)
  ```

These three steps are enough to have the world populated with circles. However, even if tracked by Box2D, the shapes are not visible. To draw the objects, I use a table to store every instance.

```lua
function love.load()
  objects = {}
end

function love.mousepressed(x, y)
  -- create body, shape, fixture
  table.insert(
    objects,
    {
      ["body"] = body,
      ["shape"] = shape,
      ["fixture"] = fixture
    }
  )
end
```

In `love.draw`, each instance is finally drawn through the desired visual — in this instance circles.

```lua
for i, object in ipairs(objects) do
  love.graphics.circle("fill", object.body:getX(), object.body:getY(), object.shape:getRadius())
end
```

Notice how the coordinates and size of the circle are retrieved from the body and shape respectively. Remember how the body describes the position and type, while it is the shape responsible for the object's features and appearance.

_Please note_: similarly to the previous demo, objects are included in `love.update`, as the mouse is detected as pressed.

_Please note_: when resetting the demo's values, it's not enough to empty the `objects` table. It is first necessary to destroy the body so that the world stops tracking their movement.

```lua
for i, object in ipairs(objects) do
  object.body:destroy()
end
```

Eventually, as the table is reset so that the game can continue anew with a different set of particles.

```lua
objects = {}
```

## Resources

- [Love2D physics](https://love2d.org/wiki/love.physics). The wiki describes in detail how the module works.

- [Box2D Physics](https://www.youtube.com/playlist?list=PLRqwX-V7Uu6Zy4FyZtCHsZc_K0BrXzxfE). The playlist from [TheCodingTrain Youtube channel](https://www.youtube.com/c/TheCodingTrain) illustrates the ideas reproduced in the folder. It provides more of inspiration than actual code, as the physics engine is introduced in the context of Processing (java).
