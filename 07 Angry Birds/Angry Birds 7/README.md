Recreate the start state, with a bold title and a world based on the ball pit demo.

## StartState

The idea is to include a simulation in which a world with low gravity is populated with a series of aliens. The code is similar to that designing the ball pit demo:

- initialize a table

- loop as if creating a series of columns

- loop as if creating a series of rows

- initialize a body, shape and fixture in the makeshift grid

The only complexity is that the columns/rows are based on a fraction of the available width/height.

```lua
for i = 1, math.floor(VIRTUAL_WIDTH / 1.5 / ALIEN_WIDTH) do
    for j = 1, math.floor(VIRTUAL_HEIGHT / 2 / ALIEN_HEIGHT) do
      -- initialize alien
  end
end
```

In order to have the aliens centered in the width/height provided by `VIRTUAL_WIDTH` and `VIRTUAL_HEIGHT` respectively, the `x` and `y` coordinate of the body are therefore slightly unorthodox.

```lua
body = love.physics.newBody(
  self.world,
  VIRTUAL_WIDTH / 6 + (i - 1) * ALIEN_WIDTH + ALIEN_WIDTH / 2,
  VIRTUAL_HEIGHT / 4 + (j - 1) * ALIEN_HEIGHT + ALIEN_HEIGHT / 2,
  "dynamic"
),
```

The addition of half the alien width and height is justified to consider the offset of each body, and since `love.physics.newBody` describes the center of the shape.

Comment out the line updating the world to see the structure before it is updated by the simulation.

```lua
function StartState:update(dt)
  -- self.world:update(dt)
end
```

## Physics

The idea is to modify the gravity of the world, the linear velocity and restitution of the bodies to have the world in constant flux.

The world is attributed a low, vertical gravity.

```lua
self.world = love.physics.newWorld(0, 10)
```

The bodies are then modified to move horizontally and vertically, through the `setLinearVelocity` function.

```lua
self.aliens[alienCounter].body:setLinearVelocity(math.random(-180, 180), math.random(-180, 180))
```

The restitution is also modified to have a collision result in the bodies produce a small bounce.

```lua
self.aliens[alienCounter].fixture:setRestitution(0.6)
```

This works to immediately have the aliens scatter in the window. To add more variety to the start state, however, I also decided to have the bodies move at a regular interval.

```lua
function StartState:init()
  self.interval = 5
  self.timer = 0
end

function StartState:update(dt)
  self.timer = self.timer + dt
  if self.timer > self.interval then
    self.timer = self.timer % self.interval
    -- update bodies
  end
end
```

At an interval, each body is set moving once more by modifying the linear velocity. In both dimensions.

```lua
alien.body:setLinearVelocity(math.random(-180, 180), math.random(-180, 100))
```

## Rotation

The rotation can be set on individual bodies, but is also modified as a result of the simulation itself. All that is necessary to have the aliens rotate is to use the angle in the fourth argument of `love.draw`.

```lua
love.graphics.draw(
  -- texture, quads and position
  alien.body:getAngle(),
  -- scale and offset
)
```

Both `love.draw` and `body:getAngle` work with radians.
