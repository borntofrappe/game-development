# Angry Birds 2

## Kinematic bodies

Kinematic bodies interact with other objects, but are not subject to world forces like gravity.

They are initialized like the static and dynamic counterpart. Just with a different `type` argument.

```lua
local body = love.physics.newBody(world, x, y, "kinematic")
```

Just like the static and dynamic variant then, they depend on a shape and a fixture to be actually visible.

In the code introduced with the update, kinematic objects are added to a table, and all share a common shape.

```lua
local shape = love.physics.newRectangleShape(30, 30)
```

The different copies of the shape have a different body, which allows to position the rectangles in different locations, and different fixtures to bind said bodies to the shape.

```lua
local body =
  love.physics.newBody(
  world,
  WINDOW_WIDTH / 2 + (i - (KINEMATIC_OBJECTS + 1) / 2) * 75,
  WINDOW_HEIGHT / 2 + 150,
  "kinematic"
)

-- shape

local fixture = love.physics.newFixture(body, shape)
```

## Angular velocity

To add more variety to the demo, the kinematic objects are modified to rotate indefinitely. This is achieved by adding an _angular velocity_ to the body.

```lua
body:setAngularVelocity(math.pi)
```

The relevant function is here [`setAngularVelocity`](https://love2d.org/wiki/Body:setAngularVelocity), and specifies how the angle changes over a second in radians.

## Minor touches

By pressing the `r` key, the idea is to reset the position of the box in the center of the window. It is here necessary to also reset its angle and velocity to avoid using the values acquired in the simulation.

```lua
box.body:setLinearVelocity(0, 0)
box.body:setAngle(0)
box.body:setAngularVelocity(0)
```
