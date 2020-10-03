# [Tutorial:Physics](https://love2d.org/wiki/Tutorial:Physics)

[`love.physics`](https://love2d.org/wiki/love.physics) introduces the physics module as a _binding_ to Box2D, meaning the library is the cornerstone of any function which follows.

Step by step, I replicate the tutorial looking for more information in the different functions provided by love2D. Starting with solid grounds, and continuing by adding a ball and few other objects.

### load

In the `load` function, the idea is to initialize a _world_ and a series of _objects_.

The world describes the type of gravity to which the objects are subject. It is initialized through the [`newWorld`](https://love2d.org/wiki/love.physics.newWorld) function as follows.

```lua
-- horizontal gravity, vertical gravity, sleep (?)
world = love.physics.newWorld(0, 9.81 * 64, true)
```

`64` is used in the tutorial as a hard-coded measure to describe a meter.

```lua
love.physics.setMeter(64)
```

In this simulation, using `setMeter(64)` means that 64 pixels are associated with a meter. `9.81 * 64` therefore describes the subject for the meter, and for the 64 pixels.

For the objects, the idea is to create a table with a series of functions. The physics module describes these functions in details, but the idea is to:

- create a _body_ through the [`newBody` function](https://love2d.org/wiki/love.physics.newBody)

  ```lua
  -- world, x, y
  objects.ground.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT - 100 / 2)
  ```

  The function is allowed to also specify a `type`, which defaults to `static`. This will be covered later when creating objects which move in the world.

  It's worth mentioning that the `x` and `y` coordinate describe the _center_ of the body. The position where the body will be initialized. In this instance, the body will be initialized in reference to the middle of the screen, and 50pixels above the bottom of the window.

- create a shape with functions like [`newRectangleShape`](https://love2d.org/wiki/love.physics.newRectangleShape)

  ```lua
  -- width, height
  objects.ground.shape = love.physics.newRectangleShape(WINDOW_WIDTH, 100)
  ```

- set up a fixture with [`newFixture`](https://love2d.org/wiki/love.physics.newFixture)

  ```lua
  -- body, shape
  objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape)
  ```

  The function is allowed to also describe a `density`, which is again covered later in the demo.

### update

The `update(dt)` function is responsible for updating the world.

```lua
function love.update(dt)
  world:update(dt)
end
```

The effects of the function won't be clear until a dynamic body is included, but the `world` global variable takes care of modifying the position and movement of the different bodies attached to it.

### draw

Instead of drawing a rectangle with `love.graphics.rectangle`, the tutorial uses the `polygon` function. This to accommodate the coordinates retrieved from the object through two dedicated functions:

- [`body:getWorldPoints()`](https://love2d.org/wiki/Body:getWorldPoints), necessary to move from coordinates in the window to coordinates in the world

- [`shape:getPoints()`](https://love2d.org/wiki/PolygonShape:getPoints), necessary to retrieve the points of a polygon

```lua
love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints()))
```

The script should already work to draw a shape, but the static nature of the ground masks the importance of the setup included so far.

### Ball

This repeats some of the concepts included in the previous sections, but to solidify the lessons learned.

#### load

- create a table describing the ball

  ```lua
  objects.ball = {}
  ```

- create a body in the world

  ```lua
  objects.ball.body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, "dynamic")
  ```

  This time the body is initialized in the center of the window.

  Notice that the additional `type` specifies a _dynamic_ shape, meaning the shape is subject to the gravity of the world.

- create a shape

  ```lua
  objects.ball.shape = love.physics.newCircleShape(20)
  ```

  This time the circular shape benefits from [`newCircleShape`](https://love2d.org/wiki/love.physics.newCircleShape)

- create a fixture

  ```lua
  objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1)
  ```

  This time the additional argument of `1` describes the density of the body, a value which is incorporated in the simulation as the body impacts with other world elements.

#### draw

The tutorial uses here `love.graphics.circle`. To retrieve the coordinates and radius of the body however, it uses dedicated functions

- [`body:getX()`](https://love2d.org/wiki/Body:getX) and [`body:getY()`](https://love2d.org/wiki/Body:getY), return the horizonal and vertical position in _world coordinates_

- [`shape:getRadius()`](https://love2d.org/wiki/CircleShape:getRadius), returns the radius of a circle shape

#### restitution

The ball in the current rendition falls toward the ground, and then stops moving when a collision is detected. Additional functions allow to modify this behavior, for instance to have the ball bounce.

```lua
objects.ball.fixture:setRestitution(0.95)
```

The function is included in the scope of `love.load`, as the object is created. Notice that it is used on the fixture.

In the specific demo, `setRestitution(0.95)` allows to have the ball bounce with 95% of its speed. Setting a value of `1` would have the ball moving indefinitely from and to the center of the screen.

### Force

The demo includes additional objects to have the ball interact with a couple of rectangles. These are defined as rectangles similarly to the ground, but ultimately include the `dynamic` type to have the objects react to a collision with the ball. They are useful to illustrate how to apply forces to bodies in the logic of the `update(dt)` function.

The relevant function is here [`applyForce`](https://love2d.org/wiki/Body:applyForce), and it is used directly on the bodies specifying the force in the horizontal and vertical dimension.

```lua
function love.update(dt)
  world:update(dt)
  if love.keyboard.isDown("left") then
    objects.ball.body:applyForce(-150, 0)
  end
end
```

Here, as long as the player presses the left arrow key, the ball is subject to a force pushing the body to the left. The movement of the ball in the world, the collision with the eventual block is then all handled by the `world` instance and its `update` function.

### Finishing touches

Additional forces are mapped to the right and up arrow keys.

```lua
function love.update(dt)
  world:update(dt)
  if love.keyboard.isDown("left") then
    objects.ball.body:applyForce(-150, 0)
  elseif love.keyboard.isDown("right") then
    objects.ball.body:applyForce(150, 0)
  elseif love.keyboard.isDown("up") then
    objects.ball.body:applyForce(-200, 0)
  end
end
```

To avoid having to re-run the program as the ball or blocks fall below the ground, their position is also reset when pressing the `r` key.

```lua
objects.ball.body:setPosition(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
objects.block1.body:setPosition(WINDOW_WIDTH / 4, WINDOW_HEIGHT / 2)
objects.block2.body:setPosition(WINDOW_WIDTH * 3 / 4, WINDOW_HEIGHT / 2)
```

Following the suggestion in the tutorial, the speed of the objects is also modified to avoid having the previous speed impact the bodies after the reset.

```lua
objects.ball.body:setLinearVelocity(0, 0)
```
