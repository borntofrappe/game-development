# Angry Birds 6

## Aliens

For the player, the idea is to use a sprite with a circular shape. This means the player always uses the second variety, regardless of color.

```lua
self.player = {
  color = math.random(#gFrames["aliens"]),
  variety = 2
}
```

For the target/opponent, on the other hand, the idea is to use a rectangle, and the remeaining two varieties.

```lua
self.target = {
  color = math.random(#gFrames["aliens"]),
  variety = math.random(2) == 1 and 1 or 3
}
```

The distinction is relevant since the graphics are mapped to different shapes in the world. In the first instance, the player is uses the `newCircleShape` function, while in the second instance, the target depends on the `newRectangleShape` function.

## World

The idea is to include two dynamic bodies, in the form of one player and one target. To constrain the bodies however, the world initializes four edge shapes as well.

### Edges

The idea is to first describe the coordinates describing the edges, right in `constants.lua`.

```lua
EDGES = {
  ["top"] = {
    x1 = 0,
    y1 = 0,
    x2 = VIRTUAL_WIDTH,
    y2 = 0
  },
  -- other edges
}
```

The way the edges are structured however is in conflict with the ways bodies and shapes are set up. `newBody` describes where to position the body, but then `newEdgeShape` describes the coordinates from the original position.

```lua
love.physics.newBody(self.world, edge.x1, edge.y1, "static")
love.physics.newEdgeShape(0, 0, edge.x2 - edge.x1, edge.y2 - edge.y1)
```

_This is important_: it is enough to initialize the body, shape and fixture to have the edges be part of the body. It is superfluous to draw the edges in `love.draw`.

### Bodies

As mentioned earlier, the update shows one circle for the player, and one rectangle for a target/opponent.

The shapes use `newCircleShape` and `newRectangleShape` respectively, similar to updates up to "Angry Bird 5". Unlike these previous updates however, the bodies are then mapped to quads from the `gFrames["aliens"]` table.

The idea is to here use the quads in conjunction with the coordinates provided by `body:getX()` and `body:getY()`.

```lua
love.graphics.draw(
  gTextures["aliens"],
  gFrames["aliens"][self.player.color][self.player.variety],
  math.floor(self.player.body:getX()),
  math.floor(self.player.body:getY()),
)
```

It is however necessary to offset the shapes so that the graphic is centered on what the body describes as the center of the shape. For the circle, this means using the player radius.

```lua
love.graphics.draw(
  -- previous attributes
  0, -- rotation
  1, -- scale x
  1, -- scale y
  math.floor(PLAYER_RADIUS), -- offset x
  math.floor(PLAYER_RADIUS) -- offset y
)
```

For the rectangle, this means using half the target's width and height.

```lua
love.graphics.setColor(1, 1, 1)
love.graphics.draw(
  gTextures["aliens"],
  gFrames["aliens"][self.target.color][self.target.variety],
  math.floor(self.target.body:getX()),
  math.floor(self.target.body:getY()),
  0,
  1,
  1,
  math.floor(ALIEN_WIDTH / 2),
  math.floor(ALIEN_HEIGHT / 2)
)
```

## Visual debugging

In the update, you find a few lines of code commented out in `love.draw`. These are instructions to show the edges, and also the center of the two bodies. They are helpful to assess the correct position and offset specified in the rest of the code.
