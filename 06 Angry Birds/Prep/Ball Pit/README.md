# Ball Pit

The project sets out to replicate the demo showcased in the course following the update `Angry Birds 2` and the description of kinematic objects. I decided to include it in a separate folder since it is connected to the `love.physics` module more than to the Angry Birds game.

## Pit

The contours of the pit are included with four edge shapes. These are initialized in a table in `love.load`. For instance and for the segment tracing the left side of the window:

```lua
pit = {}
pit[1] = {
  body = love.physics.newBody(world, 0, 0, "static"),
  shape = love.physics.newEdgeShape(0, 0, 0, WINDOW_HEIGHT)
}
pit[1].fixture = love.physics.newFixture(pit[1].body, pit[1].shape)
```

The bodies are included in the world through the `newBody` function, but not rendered in `love.draw`. This is to show how the lines are but a visual aid. The boundaries are already set on the world.

## Balls

Balls are included as a set of dynamic objects, with circular shapes and occupying the available width. The table describing each ball is also given a distinct color with a random value for the rgb components.

```lua
local color = {
  ["r"] = math.random(),
  ["g"] = math.random(),
  ["b"] = math.random()
}
```

## Box

The box is included with a rectangle shape, but most importantly, as an object with larger size and more density.

```lua
boxShape = love.physics.newRectangleShape(40, 40)
boxFixture = love.physics.newFixture(boxBody, boxShape, 15)
```

## Reposition

When pressing the `r` or `space` key, the idea is to reposition the box above the ball pit.

```lua
boxBody:setPosition(math.random(50, WINDOW_WIDTH - 50), WINDOW_HEIGHT / 4)
```
