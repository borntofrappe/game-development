# Asteroids

Recreate the basic structure of the arcade game with a state machine and shapes from the `love.graphics` module.

## Dependencies and structure

The project is organized to have `main.lua` reference a series of files in the `src` and `res` folders. At the top of the script, however, the idea is to require a single file, `src/Dependencies`.

```lua
require "src/Dependencies"
```

It is up to the script to then require all necessary assets.

```lua
require "src/constants"

require "src/StateMachine"
-- ...
```

## Keypressed

Just like in `01 Flappy Bird`, the idea is to have a table store the key pressed in the previous frame. The table is added to the `love.keyboard` module.

```lua
function love.load()
  love.keyboard.keyPressed = {}
end
```

A function is included on the module to then return a boolean matching the desired key.

```lua
function love.keypressed(key)
  love.keyboard.keyPressed[key] = true
end

function love.keyboard.wasPressed(key)
  return love.keyboard.keyPressed[key]
end
```

## State

- from title to spawn by pressing enter

- from spawn to play after a predetermined countdown. The countdown happens in intervals, so that it is possible to have the `render` function draw the player intermittently

```text
title -> spawn -> play
  ^                |
  |________________|
```

## Player

Translate, rotate. This in between a push and pop.

```lua
function Player:render()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)
  love.graphics.rotate(self.angle)

  -- draw

  love.graphics.pop()
end
```

The movement itself is dictated by the angle, so it's good to start with that: andle and dangle, change and friction.

`x` and `y` are updated much similarly, but the offset is dictated by the angle itself, using sine and cosine functions.

## Asteroid

Moving at a random speed, provided an angle. Radius according to the type. The type also dictates whether, after removing the asteroid from the table, it is necessary to add two more.

When destroyed, the idea is to spawn two additional asteroids, with a minimum speed matching the destroyed asteroid own speed.

## Projectiles

dx and dy are determined by the angle of the player. Each instance has a lifespan and keeps track of the passing of time to remove the element after `x` seconds.

## Gameplay

Keep track of score, lives, record.

Global values set in `love.load`. Global functions to draw the record, score and lives consistently and from multiple states.

## States / 2

Victory, gameover.

If crashing and winning, go first to the spawn state. At the entrance of the play state check for a victory.

## Gameplay / 2

Teleport, difficulty

## Refactor and add sound

## Document and remove Games/Asteroids
