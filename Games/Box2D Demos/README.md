# Box2D Demos

The goal of this folder is to re-introduce the physics library Box2D, as first seen in the game `07 Angry Birds`. The library is used in the context of the Love2D game engine, and specifically looking at the code behind the `love.physics` module.

Most folders describe a specific concept of Box2D, and are inspired by [a playlist](https://www.youtube.com/playlist?list=PLRqwX-V7Uu6Zy4FyZtCHsZc_K0BrXzxfE) from [TheCodingTrain Youtube channel](https://www.youtube.com/c/TheCodingTrain), and are detailed in the sections which follow.

Beyond these demos, the idea is to develop more complex experiences with the semblance of a game. Consider `Hillside ride` and `Bowling lane`.

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

## Revolute joint

The idea is to bind bodies to the same anchor point, and have the bodies rotate from this shared coordinate. To show the joint, the demo first introduces a series of circles above the window, and has the objects fall down as subject to gravity. These objects are included at an interval, and to ensure that the demo doesn't slow down excessively, are removed when they exceed the window's height.

```lua
for i, object in ipairs(objects) do
  if object.body:getY() > WINDOW_HEIGHT then
    object.body:destroy()
    table.remove(objects, i)
  end
end
```

The script is however devoted to the revolute joint. Two rectangles are included to define the pieces of the joint: a platform and a rotor. The idea is to fix the platform in the lower portion of the window, by way of the `static` type. The rotor, on the other hand, specifies a `dynamic` type, so that the object is able to rotate on the connected anchor point.

```lua
platform.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT * 3 / 4)
rotor.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT * 3 / 4 - 25, "dynamic")
```

The `y` coordinate is reduced by `25` as to have the rotor anchored relative to the top of the platform.

From this setup, the revolute joint considers two bodies and the coordinates of the anchor point.

```lua
love.physics.newRevoluteJoint(platform.body, rotor.body, WINDOW_WIDTH / 2, WINDOW_HEIGHT * 3 / 4 - 25)
```

This is enough to have the rotor fixed and rotate as the circles collide with the object. To have the object actively rotate, however, it's possible to specify a motor with a series of functions:

- `setMotorSpeed` and `setMaxMotorTorque` specify the physics in terms of motor speed and torque

  ```lua
  revoluteJoint:setMotorSpeed(math.pi * 2)
  revoluteJoint:setMaxMotorTorque(10000)
  revoluteJoint:setMotorEnabled(true)
  ```

  Note that the value change considering the structure of the platform and rotor. A thinner/shorter rotor requires less torque to rotate than a thicker/taller one.

- `setMotorEnabled()` enables the rotation

  The function is also called as the mouse is pressed in the window, to toggle the rotor. `isMotorEnabled` provides a boolean so that the code is able to use the opposite of the existing value.

  ```lua
  function love.mousepressed()
    revoluteJoint:setMotorEnabled(not revoluteJoint:isMotorEnabled())
  end
  ```

_Please note_: the demo also takes advantage of the `getAnchors()` function. This one provide the coordinates of the anchor point, so that the `draw` function is able to draw a black circle where the two objects are connected.

## Mouse joint

The demo removes the progress achieved in the previous sections to focus on a single object. A rectangle shape is included in the middle of the window, while a chain shape works to define the window's edges. This allows to constrain the object to the visible area. From this setup, the mouse joint is included between the object and the mouse current position, but only if the cursor is pressed.

`mouseJoint` is initialized in `love.load` to keep track of the joint itself. A reference is useful in the moment the `draw` function needs to include a visual for the joint itself.

```lua
mouseJoint = nil
```

As the mouse is pressed, the joint is initialized by specifying a body and the coordinates of the anchor point. Think of these coordinates as the target, the point to which the object is bound.

```lua
function love.mousepressed(x, y)
  mouseJoint = love.physics.newMouseJoint(object.body, x, y)
end
```

This is already enough to have what is essentially a distance joint between shape and the mouse's position. As the mouse is released however, the idea is to remove the joint. This allows to have the shape move in the chosen direction, as the object is no longer bound to the joint. Moreover, it allows to set up a different joint as the mouse is pressed once more.

```lua
function love.mousereleased()
  mouseJoint:destroy()
end
```

As the mouse is dragged then, the joint's coordinates are updated to have the object follow the mouse's movement.

```lua
function love.update(dt)
  if love.mouse.isDown(1) then
    mouseJoint:setTarget(love.mouse.getPosition())
  end
end
```

Finally, the joint is drawn by describing the line connecting the mouse's coordinates and the body. For the actual coordinates, the `getAnchors` function provides the coordinates of the point behind the joint, while `getX` and `getY` provide the center of the body.

```lua
local x1 = object.body:getX()
local y1 = object.body:getY()

local x2, y2 = mouseJoint:getAnchors()
love.graphics.line(x1, y1, x2, y2)
```

## Body force

The demo works to introduce the concept of forces. These are applied to the world's bodies through the `applyForce` function, specifying the intensity of the force in the horizontal and vertical dimension.

```lua
body:applyForce(forceX, forceY)
```

To showcase these forces, the demo introduces a series of rectangle shapes from the top of the screen. These are included and removed in a similar manner to the circles described in the [_Revolute joint_](#revolute-joint) section.

As the mouse is being pressed, the idea is to then loop through the `objects` table to apply a force pushing the shapes toward the mouse's position.

```lua
if love.mouse.isDown(1) then
  local x1 = love.mouse:getPosition()

  for i, object in ipairs(objects) do
    local x2 = object.body:getX()
    local direction = x1 > x2 and 1 or -1
  end
end
```

Based on the direction, the force is applied on every objects stored in the table.

```lua
object.body:applyForce(50 * direction, 0)
```

_Please note_: the hard-coded value is moved into its own variable, so that the force is described at the top of the script with a constant.

```lua
FORCE = 50
```

_Please note_: the demo also introduces two platforms, on either side of the window. These are not rendered, but included in the world to see how the shapes would impact the window's edges.

## Collision events

Similarly to the demo introduced in the previous section, see [_Body force_](#body-force), the script introduces a series of rectangle shapes from the top of the window. In the lower section of the window, however, the demo adds a circular shape to represent the player. The idea is to here detect a collision between this circle and one of the falling rectangles. In such an instance, the rectangle shape is destroyed.

To complete this demo, it is first necessary to have the world listen for a collision.

```lua
function love.load()
  -- define world
  world:setCallbacks(beginContact)
end
```

`setCallbacks` described up to four functions, for different stages of a collision, but here we are interested in the start of a collision only. `beginContact` refers to a function, defined to describe what happens as a contact between two world objects begins.

```lua
function beginContact(fixture1, fixture2)
end
```

The function receives the fixtures involved in the contact. To differentiate the behavior on the basis of which fixture is actually involved (a circle, a rectangle, a platform), love2d provides the `setUserData` and `getUserData` functions. The idea is to set a label on the fixture of the player, and that of the object.

```lua
player.fixture:setUserData("Player")
```

In the body of the `beginContact` function then, the idea is to build a table describing the involved fixtures through booleans.

```lua

function beginContact(fixture1, fixture2)
  local userData = {}
  local userData1 = fixture1:getUserData()
  local userData2 = fixture2:getUserData()
  userData[userData1] = true
  userData[userData2] = true
end
```

In this manner, the function is able to check the involved fixtures regardless of the order in which they are received.

```lua
if userData["Player"] and userData["Object"] then
end
```

Here, the idea is to remove the body of the fixture describing the object.

```lua
if userData1 == "Object" then
  fixture1:getBody():destroy()
else
  fixture2:getBody():destroy()
end
```

This works, but generates an error in the moment the world tries to update a destroyed object. Ideally, the demo would consider a more refined approach, where the `beginContact` function doesn't destroy the object directly, but toggles a boolean so that `love.update` can later destroy the body. Here, it is enough to condition then update and render logic to objects not destroyed.

```lua

for i, object in ipairs(objects) do
  if not object.body:isDestroyed() then
    love.graphics.polygon("line", object.body:getWorldPoints(object.shape:getPoints()))
  end
end
```

The update function also removes the object from the `objects` table considering the boolean returned by the function `isDestroyed`.

```lua
function love.update(dt)
  for i, object in ipairs(objects) do
    if object.body:isDestroyed() then
      table.remove(objects, i)
    end
  end
end
```

_Please note_: this is not the topic of the demo, but the player is introduced as a kinematic object.

```lua
player.body = love.physics.newBody(world, x, y, "kinematic")
```

The movement of the circle is then modified through the `setLinearVelocity` function, to have the shape follow the direction instructed by the arrow keys.

## Resources

- [Love2D physics](https://love2d.org/wiki/love.physics). The wiki describes in detail how the module works.

- [Box2D Physics](https://www.youtube.com/playlist?list=PLRqwX-V7Uu6Zy4FyZtCHsZc_K0BrXzxfE). The playlist from [TheCodingTrain Youtube channel](https://www.youtube.com/c/TheCodingTrain) illustrates the ideas reproduced in the folder. It provides more of inspiration than actual code, as the physics engine is introduced in the context of Processing (java).
