Add a series of kinematic bodies.

## Kinematic

Kinematic bodies are not impacted by the world forces, like gravity. They are however bodies with a fixture, and bodies with which dynamic entities can collide/interact.

They are initialized like the static and dynamic counterpart. Just with a different `type` argument.

```lua
kinematicBody = love.physics.newBody(world, x, y, "kinematic")
```

Just like the static and dynamic variant then, they depend on a shape and a fixture to be actually visible.

In the code introduced with the update, kinematic objects are added to a table, and all share a common shape.

```lua
kinematicShape = love.physics.newRectangleShape(30, 30)
```

The different copies of the shape have however a different body, which allows to position the rectangles in different locations, and different fixtures.

```lua
kinematicObjects = {}
kinematicObjects[1].shape = shape

kinematicObjects[1].body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2 + 150, "kinematic")

kinematicObjects[1].fixture = love.physics.newFixture(kinematicObjects[1].body, kinematicObjects[1].shape)
```

_Be warned_: the snippet shows how to define one of the kinematic objects, but the code uses a for loop to automate the inclusion of multiple copies.

## Angular velocity

To add more variety to the demo, the kinematic objects are also modified to rotate indefinitely. This is achieved by adding an _angular velocity_ to the body.

```lua
kinematicObjects[1].body:setAngularVelocity(math.pi)
```

The relevant function is here [`setAngularVelocity`](https://love2d.org/wiki/Body:setAngularVelocity), and specifies how the angle changes over a second. This using a value expressed in radians.

## Minor touches

By pressing the `r` key, the idea is to reset the position of the box in the center of the window. It is here necessary to also reset its angle and angular velocity to avoid using the values acquired in the simulation.

```lua
boxBody:setAngle(0)
boxBody:setAngularVelocity(0)
```
