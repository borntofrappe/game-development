# Angry Birds 1

## Dynamic bodies

To have the body subject to the world physics, the first step is to specify a type of `dynamic`.

```lua
body = love.physics.newBody(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, "dynamic")
```

## Update logic

On its own, the `dynamic` type is not enough to have the body react to the world's gravity and forces. It is here necessary to update the world itself, and this is achieved through the `update()` function on the instance of the world.

```lua
function love.update(dt)
  world:update(dt)
end
```

## Ground

_Be warned_: I renamed the variables describing the previous object to distinguish the the rectangle from the ground.

Ground is included through he `newEdgeShape` function, as a line fixed at the bottom of the window.

```lua
ground = {}
ground.body = love.physics.newBody(world, 0, WINDOW_HEIGHT - 5, "static")
ground.shape = love.physics.newEdgeShape(0, 0, WINDOW_WIDTH, 0)
ground.fixture = love.physics.newFixture(ground.body, ground.shape)
```

It's worth noting that the rectangle reacts to solid ground from the very moment in which the body is included in the world. A line is drawn just to provide a visual.

```lua
love.graphics.line(ground.body:getWorldPoints(ground.shape:getPoints()))
```

## Restitution

As it stands, the rectangle falls to solid ground, and stops on collision. Restitution is but one way to change this default behavior, allowing the box to bounce with a fraction of the speed gained.

```lya
box.fixture:setRestitution(0.9)
```

Note how the restitution is set on the fixture.
