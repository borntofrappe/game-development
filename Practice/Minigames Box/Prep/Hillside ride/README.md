# Hillside ride

The goal is to have a closed environment in which a complex shape describing a car, a stylized vehicle moves on top of wavy-like terrain.

## Edges

The wiki for love2d suggets using [edge shapes](https://love2d.org/wiki/EdgeShape) for the window's border. To this end, the game creates the borders with four lines.

## Terrain

The wavy-like terrain is obtained by building a table of points, incrementing the `x` coordinate and modifying the `y` coordinate using the sine function `math.sin`.

A chain shape is allowed to receive a table for the points, so that, once the table is built, it's enough to include the data structure directly.

```lua
terrain.shape = love.physics.newChainShape(false, points)
```

## Car

The car is made of three objects:

- a rectangle making up the body of the car

- two circles for the left and right wheel

The wheels are connected to the body with a revolute joint each. For instance and for the left wheel.

```lua
revoluteJointLeft =
  love.physics.newRevoluteJoint(car.body, wheelLeft.body, wheelLeft.body:getX(), wheelLeft.body:getY())
revoluteJointLeft:setMotorSpeed(math.pi * 10 * car.direction)
revoluteJointLeft:setMaxMotorTorque(500)
revoluteJointLeft:setMotorEnabled(true)
```

The speed, torque, and other physics-based parameter is the fruit of experimentation, but note in particular the friction attributed to the wheel.

```lua
wheelLeft.fixture:setFriction(1)
```

A lower friction value means the circle's impact on the terrain is reduced, reducing the effect of the rotation.

## Collision and player interaction

As the car collides with the edges, the idea is to flip the direction of the car, by modigying the motor speed.

```lua
car.direction = dir or car.direction * -1
revoluteJointLeft:setMotorSpeed(math.pi * 10 * car.direction)
```

The car flips its direction also as the left and right keys are pressed, so that the feature is centralized in a function.

On top of the change in direction, the car increases in speed by applying a force to every body making up the figure.

```lua
car.body:applyForce(700 * car.direction, 0)
wheelLeft.body:applyForce(500 * car.direction, 0)
wheelRight.body:applyForce(500 * car.direction, 0)
```

This action follows a change in direction, and is also conditioned to the space key being pressed.
