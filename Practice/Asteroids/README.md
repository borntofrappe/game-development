# Asteroids

Recreate the basic structure of the arcade game with a state machine and shapes from the `love.graphics` module.

## Dependencies and structure

The project is organized to have `main.lua` lean on a series of files in the `res` and `src` folders. In the `res` folder you find static assets and external libraries, like `class.lua`. In the `src` folder you find the code developing the game, encapsulated with series of classes.

From `main.lua`, the idea is to require a single file: `src/Dependencies`.

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

The game includes a series of states. A first basic structure has the player go from the title to a spawn state, where the spaceship blinks before the play state and the actual level.

```text
title -> spawn -> play
  ^                |
  |________________|
```

This structure is however complicated to make for a more complete game:

- when the spaceship crashes against an asteroid, the game moves back to the spawn state, before returning to the full level

- when the spaceship is out of lives, the game moves to the gameover state. Here a string highlights the situation before moving to the title state

- when every asteroid is destroyed, the game moves to a victory state. Here a short jingle highlights the cleared level before initializing a new level in the play state

- when the spaceship teleports to a random spot, it is convenient to use a teleport state to continue updating the level, reposition the player and then go back to the play state

```text
  *
  |
title -> spawn <-> play  <-->  victory
  ^                 |    |-->  gameover -->*
  |_________________|    <--> teleport
```

## Player

The player is displayed with a spaceship and a triangular shape. The triangle itself is created with `love.graphics.polygon`, specifying the vertices after the desired mode.

```lua
love.graphics.polygon('line', x1, y1, x2, y2, .., xn, yn)
```

Since I want to rotate the shape from its center, it is preferable to have the vertices describe the coordinates around the center.

The `love.graphics` module then provides the `translate` function to shift the center in the page.

```lua
function Player:render()
  love.graphics.translate(self.x, self.y)

  love.graphics.polygon()
end
```

To rotate the shape, the same module provides the `rotate` function.

```lua
function Player:render()
  love.graphics.translate(self.x, self.y)
  love.graphics.rotate(self.angle)

  love.graphics.polygon()
end
```

This setup allows to position and rotate the triangle as wanted. However, the translation and rotation affect any other shape rendered after the player. This is because the transformation matrix is modified. `love.graphics.push()` and `love.graphics.pop()` allow to modify the matrix solely for the player.

```lua
function Player:render()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)
  love.graphics.rotate(self.angle)

  love.graphics.polygon()

  love.graphics.pop()
end
```

`push` saves the current transformation and `pop` reverts to the stored preference.

## Movement

The player is positioned and rotated at a given angle. To move the triangle, it is necessary to consider a bit of trigonometry to find the horizontal and vertical vector.

```lua
self.dx = math.sin(self.angle) * SPEED_CHANGE
self.dy = math.cos(self.angle) * SPEED_CHANGE * -1
```

The functions are chosen considering the fact that the triangle points upwards.

## Asteroid

Similarly to the player, the asteroids move starting from an angle.

```lua
local angle = math.rad(math.random(360))
```

By using the angle it is possible to have the shapes move in any direction.

```lua
self.speed = math.random(speed_min or SPEED_MIN, SPEED_MAX)
self.dx = math.cos(angle) * self.speed
self.dy = math.sin(angle) * self.speed
```

A `type` is included to have the asteroids spawn additional targets, as long as the type is greater than `1`. The type allows to have large asteroids spawn smaller and smaller units, until they are finally destroyed.

```lua
function Asteroid:isDestroyed()
  return self.type == 1
end
```

It is ultimately in the play state that the function is used to potentially add more asteroids.

```lua
if not asteroid:isDestroyed() then
  -- spawn new asteroids
end
```

New asteroids spawn from the location of the previous one, and with a minimum speed matching the destroyed asset.

## Projectiles

Projectiles are included from the perspective of the player, starting from its location and angle.

```lua
function Projectile:init(x, y, angle)
end
```

The angle allows to move the shapes in the direction toward which the player points.

```lua
self.dx = math.sin(angle) * SPEED
self.dy = -math.cos(angle) * SPEED
```

The code is organized so that the player class has a table storing the projectiles.

```lua
function Player:init()
  self.projectiles = {}
end
```

## Score

The score and lives are two variables included in the `Player` class.

```lua
function Player:init()
  self.points = 0
  self.lives = LIVES
end
```

`gRecord` is also included in `love.load` to keep track of the high score.

```lua
gRecord = {
  ["current"] = false,
  ["points"] = RECORD
}
```

The value is ultimately updated when the player reaches a greater number of points. The `current` field is used to have the sound byte for the record play only once, as the player reaches the high score.
