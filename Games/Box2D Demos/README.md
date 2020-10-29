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

## Static shapes

The demo buids from the progress achieved with the previous section (see [_Dynamic particles_](#dynamic-particles)) to include two static objects.

The difference with respect to the previous objects, is that the body are initialized with a static type.

```lua
love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT * 3 / 4, "static")
```

_Please note_: if the type is not specified, the engine defaults to `static`, so that it is equivalent to avoid describing the additional argument.

```lua
love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT * 3 / 4)
```

Beyond the different type, the demo also introduces two additional functions to describe additional shapes.

- `love.physics.newPolygonShape` to draw a platforms

  ```lua
  love.physics.newPolygonShape(
    -WINDOW_WIDTH / 6,
    -8,
    WINDOW_WIDTH / 6,
    -8,
    WINDOW_WIDTH / 6,
    8,
    -WINDOW_WIDTH / 6,
    8
  )
  ```

  _Please note_: Love2D offers `newRectangleShape` as a shorthand to create rectangles.

  ```lua
  love.physics.newRectangleShape(WINDOW_WIDTH / 3, 20)
  ```

- `love.physics.newChainShape` to draw a jagged terrain

  ```lua
  love.physics.newChainShape(
    false,
    -WINDOW_WIDTH / 2,
    -WINDOW_HEIGHT,
    -WINDOW_WIDTH / 2,
    -50,
    0,
    0,
    WINDOW_WIDTH / 2,
    -100,
    WINDOW_WIDTH / 2,
    -WINDOW_HEIGHT
  )
  ```

  The first argument describes whether the shape should loop back to the first point or not.

Finally, to draw the new features, the demo uses `love.graphics.polygon`. This function is especially suited for polygons, rectangles, or again chains, as it allows to draw the shapes based on their points. `getPoints` is available on the mentioned shapes.

```lua
love.graphics.polygon("fill", platform.shape:getPoints())
```

One important addition, however: `Body:getWorldPoints` is necessary to have the game convert between the units in the game and those in the world. Between pixels and meters.

```lua
love.graphics.polygon("fill", platform.body:getWorldPoints(platform.shape:getPoints()))
```

## Complex shapes

Instead of drawing circles as in the previous sections (see [_Dynamic particles_](#dynamic-particles) and [_Static shapes_](#static-shapes)), the demo adds objects in the form of complex shapes. The idea is to create objects in the form of two circles connected by a rectangle, as in the following rough ASCII representation.

```text
o--o
```

To create the complex shape, the idea is to create multiple shapes, and attach them to the same body. Two circles:

```lua
local shape1 = love.physics.newCircleShape(RADIUS)
local shape2 = love.physics.newCircleShape(RADIUS)
```

One rectangle:

```lua
local shape3 = love.physics.newRectangleShape(RADIUS * 4, RADIUS)
```

And the respective fixtures:

```lua
local fixture1 = love.physics.newFixture(body, shape1)
local fixture2 = love.physics.newFixture(body, shape2)
local fixture3 = love.physics.newFixture(body, shape3)
```

This works to create the three shapes. However, the shapes are created from the same point of origin. The center described by the body's position. To have the circles on either side, it's necessary to describe an offset. `newCircleShape` allows to describe such an offset in the `x` and `y` coordinate by specifying two additional arguments.

```lua
-- x, y, radius
love.physics.newCircleShape(RADIUS * 1.5, 0, RADIUS)
```

This is enough to build, in the world, the desired `o--o` structure. It is finally necessary to draw in `love.draw` a figure matching the object. This is done again through `love.graphics.circle` and `love.graphics.polygon`, with one considerable difference: the circles cannot use the body's position to describe the center of the shape, remember `body:getX()` and `body:getY()`. This is because the shapes are offset from the body's center. It is therefore necessary to access the coordinates of the matching shape.

```lua
local cx1, cy1 = object.body:getWorldPoints(object.shapes[1]:getPoint())
```

`CircleShape:getPoint()` provides the center of the circle, while `Body:getWorldPoints` converts the units to the world measure.

_Please note_: the code producing the desired complex shape is moved into a function, to avoid repeating the instruction in `love.mousepressed` and `love.update(dt)`.

```lua
function love.mousepressed(x, y)
  addObject(x, y)
end

function love.update(dt)
  if love.mouse.isDown(1) then
    local x, y = love.mouse:getPosition()
    addObject(x, y)
  end
end
```

_Please note_: the radius of the circles is reduced to reduce the impact of each individual body.

## Distance joint

The demo creates a bridge with a series of connected circles. The goal is to use a distance joint to bind the circles together, and have the first and last element fixed, static so that the structure oscillates in the lower porition of the window.

_Please note_: the platform and terrain introduced in the previous demo are removed to focus on the bridge.

To create the bridge, the code first produces a series of objects in the form of circles, spanning the entirety of the window's width.

```lua
objectsBridge = {}
objectsBridgeNumber = math.floor(WINDOW_WIDTH / (RADIUS_BRIDGE * 2)) + 1

for i = 1, objectsBridgeNumber do

end
```

The objects are created with an increasing `x` coordinate, so to have the circles side by side.

```lua
local x = (i - 1) * RADIUS_BRIDGE * 2
```

Moreover, the first and last object are made `static`, so that the connected structure doesn't fall due to gravity.

```lua
local type = i == 1 or i == objectsBridgeNumber and "static" or "dynamic"
```

Creating the body is enough to produce the components making up the bridge, and you can attest so by commenting out the line updating the world.

```lua
function love.update(dt)
  -- world:update(dt)
end
```

For the joint however, it is necessary to use the `love.physics.newDistanceJoint` function. This one accepts multiple arguments, for the bodies involved in the joint and the position of the anchor points.

```lua
love.physics.newDistanceJoint(body1, body2, x1, y1, x2, y2)
```

In the demo, such a function is used looping through the `objectsBridge` table, from the first up to the penultimate object. This to connect the current body with the one which follows.

```lua
for i = 1, objectsBridgeNumber - 1 do

end
```

The bodies are collected from the mentioned table.

```lua
local body1 = objectsBridge[i].body
local body2 = objectsBridge[i + 1].body
```

The anchor points consider the center of each shape.

```lua
local x1 = body1:getX()
local y1 = body1:getY()

local x2 = body2:getX()
local y2 = body2:getY()
```

The values are then used in the joint.

```lua
love.physics.newDistanceJoint(body1, body2, x1, y1, x2, y2)
```

This is enough to have the objects connected to one another. To finally show such a connection, `love.draw` renders a line using the bodies' coordinates.

_Please note_: `newDistanceJoint` accepts an additional argument, to specify whether or not the connected bodies should collide.

## Resources

- [Love2D physics](https://love2d.org/wiki/love.physics). The wiki describes in detail how the module works.

- [Box2D Physics](https://www.youtube.com/playlist?list=PLRqwX-V7Uu6Zy4FyZtCHsZc_K0BrXzxfE). The playlist from [TheCodingTrain Youtube channel](https://www.youtube.com/c/TheCodingTrain) illustrates the ideas reproduced in the folder. It provides more of inspiration than actual code, as the physics engine is introduced in the context of Processing (java).
