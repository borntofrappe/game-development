# Angry Birds 0

_Be warned_: this is a theory-heavy update, introducing several concepts before the actual code.

## Theory

Love2D offers several methods in the `love.physics` module. This is however a namespace, a wrapper for the box2D library. You are essentially using box2D within the context of love2D.

### World

A world is how Love2D simulates physics. It is here where the bodies are included, and it is through the world that the bodies are updated, move and interact with each other.

The relevant function is `love.physics.newWorld(gravityX, gravityY, sleep)`.

`gravity` allows to set the horizontal and vertical push to which the bodies are subject.

`sleep` is an optional boolean which allows for sleeping, non-moving, bodies. When you have a body you don't want tracked, setting the body as sleeping allows you avoid having the world calculate its position and movement. This is ultimately a gain in performance.

### Bodies

Bodies are but abstract containers for the elements in the game. A body describes a position and a velocity, and it is only through shape and fixtures that these are mapped to actual visual elements.

The relevant function is here `love.physics.newBody(world, x, y, type)`.

- `world` so that the world and its update function contemplate the body in the simulation

- `x` and `y` to describe the position.

  It is important to note that the position describes the center of the body, and where the body will ultimately start out.

- `type` to describe the nature of the body and how it interacts with other elements.

  There are three types:

  1. static, for bodies not affected by gravity nor collision. Consider these permanent structures as the ground on which a ball bounces.

  2. dynamic, for bodies affected by gravity and collision with other objects.

  3. kinematic, for bodies that can interact with other elements, but are not subject to gravity or world forces. Consider for instance moving platforms.

### Fixtures

Fixtures are once again abstract object, which however contains instructions to fix a shape to a body. They can optionally set a density, friction, restitution, and ultimately describe how the visuals behave in the world.

The relevant function is `love.physics.newFixture(body, shape)`.

### Shapes

Shapes describe the visual, and ultimately the hitbox of the bodies.

There are several functions, each with its own set of arguments

- `newCircleShape(radius)`

- `newRectangleShape(width, height)`

- `newEdgeShape(x, y, width, height)`

- `newChainShape(loop, x1, y1, x2, ...)`

- `newPolygonShape(x1, y1, x2, y2, ...)`

## Practice

The idea is to render a static rectangle right in the middle of the window. This rectangle however, is included as a body, in a world, and with a shape and fixture.

It is worth mentioning that while the body is created as a rectangle, the render logic uses `love.graphics.polygon`, with the coordinates retrieved from the body and the associated shape.

```lua
love.graphics.polygon("fill", body:getWorldPoints(shape:getPoints()))
```
