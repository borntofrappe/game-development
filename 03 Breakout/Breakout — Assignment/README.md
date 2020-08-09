[The assignment](https://docs.cs50.net/ocw/games/assignments/2/assignment2.html) has the following objectives:

- [x] add a powerup to the game that spawns two extra `Ball`s

- [x] grow and shrink the `Paddle` when the player gains enough points or loses a life

- [ ] add a locked `Brick` that will only open when the player collects a second new powerup, a key, which should only spawn when such a `Brick` exist and randomly as per the `Ball` powerup

## Powerup

The powerups are included in _breakout.png_ and in the last row of the image. In terms of coordinates, they begin at the point (0, 192) and continue with squares with a 16x16 size.

### Quads

For the quads relative to the powerups, the `GenerateQuads*` function is similar to that onr introduced for the hearts.

```lua
x = 0
y = 192

local quads = {}

for i = 1, 10 do
  quads[i] = love.graphics.newQuad(x, y, 16, 16, atlas:getDimensions())
  x = x + 16
end
```

I start the loop at `1`, in trying to keep the lua convention of being a one-based index language. In a future update, I might revisit the codebase to make sure every loop starts with the `1` instead of `0`.

In `main.lua`, include the quads in the `gFrames` global variable.

```lua
gFrames = {
  -- previous quads,
  ["powerups"] = GenerateQuadsPowerups(gTextures["breakout"])
}
```

### Class

To get started, initialize a powerup class to simply render one of the quads.

```lua
Powerup = Class {}

function Powerup:init()
  self.x = VIRTUAL_WIDTH / 2
  self.y = VIRTUAL_HEIGHT / 2
  self.powerup = 9
end

function Powerup:render()
  love.graphics.draw(gTextures["breakout"], gFrames["powerups"][self.powerup], self.x, self.y)
end
```

In the start state, you can then experiment by showing a specific sprite.

```lua
function StartState:init()
  self.powerup = Powerup()
end

function StartState:render()
  self.powerup:render()
end
```

I chose the start state to immediately show the image, as the game launches. That being said, the sprite is meant to appear in the play state. I also chose the ninth powerup since it seems appropriate for the feature being developed.

**Just remember** to include the script in the dependencies used by the game.

### Logic

With the class able to render the powerup, a word on how the sprite is ultimately shown and updated. The idea is to have a table in which to store the powerups.

```lua
function PlayState:init()
  self.powerups = {}
end
```

And then include an instance of the `Powerup` class when a brick is destroyed — and with a certain probability.

```lua
powerupFlag = math.random(5) == 1
if brick.tier == 1 and brick.color == 1 and powerupFlag then
  powerup = Powerup(brick.x + brick.width / 2, brick.y + brick.height / 2)
  table.insert(self.powerups, powerup)
end
```

Finally, loop through the table to update and render the class with the matching function.

```lua
function PlayState:update(dt)
  for k, powerup in pairs(self.powerups) do
    powerup:update(dt)
  end
end

function PlayState:render()
  for k, powerup in pairs(self.powerups) do
    powerup:render()
  end
end
```

For the update function, the powerup is instructed to continuously move downwards.

> This `Powerup` should spawn randomly, be it on a timer or when the Ball hits a `Block` enough times, and gradually descend toward the player.

### Collision

Once the powerups are included, it's necessary to detect a collision between the powerups and the paddle. Instead of repeating the logic of the `Ball:collides()` function, I decided to add a global function in _main.lua_.

```lua
function testAABB(box1, box2)
  if box1.x + box1.width < box2.x or box1.x > box2.x + box2.width then
    return false
  end

  if box1.y + box1.height < box2.y or box1.y > box2.y + box2.height then
    return false
  end

  return true
end
```

With this function, `Ball:collides()` becomes redundant, and the script can use `testAABB()` for the possible collisions:

- paddle and powerups

- paddle and ball

### Balls

The collision between paddle and ball becomes paddle and _balls_, once a powerup is actually collected. To this end, the script is updated to have the balls in a table.

```lua
function PlayState:init()
  self.balls = {}
end
```

Once a collision with the powerup is registered, the idea is to then include a ball in the table.

```lua
function PlayState:update(dt)
  if testAABB(powerup, self.paddle) then
    table.insert(self.balls, Ball(powerup.x, powerup.y))
  end
end
```

The extra complication comes from having to loop through the table. Instead of using `self.ball`, it's necessary to refer to every instance stored in `self.balls`.

```diff
function PlayState:render()
-  self.ball:render()
+  for k, ball in pairs(self.balls) do
+    ball:render()
+  end
end
```

The same for the `update(dt)` function.

## Paddle size

The assignment instructs that the paddle should:

- shrink if the player loses a heart (but no smaller of course than the smallest paddle size)

- grow if the player exceeds a certain amount of score (but no larger than the largest Paddle)

### Quads

The quads for the different sizes and colors are already included in `gFrames['paddles']`. The size is also and already considered in the `love.draw` function.

```lua
function Paddle:render()
  love.graphics.draw(gTextures["breakout"], gFrames["paddles"][self.size + 4 * (self.color - 1)], self.x, self.y)
end
```

This means the script needs to just change the variable `size` to have the game render a different version.

### Changes

Changing the variale `size` works to render a different sprite, but the game needs to update the `width` of the paddle as well. This value is used throughout the game to determine the behavior of the paddle, for instance to detect a collision between paddle and ball, and a fixed value of `64` contrasts with a visual which now changes in width.

I also decided to update `x`, so to have the paddle change in size, but stay centered in its current position.

Finally, I decided to specify how the paddle changes through two methods of the `Paddle` class itself.

- `shrink` reduces the size when the size exceeds the smallest value

  ```lua
  function Paddle:shrink()
    if self.size > 1 then
      self.size = self.size - 1
      self.width = self.size * 32
      self.x = self.x + 16
    end
  end
  ```

- `grow` achieves the opposite and increases the size when this is less than the greatest measure

  ```lua
  function Paddle:grow()
    if self.size < 4 then
      self.size = self.size + 1
      self.width = self.size * 32
      self.x = self.x - 16
    end
  end
  ```

### Gameplay

The final step is to resize the paddle when instructed:

- when the health is reduced

  ```lua
  self.health = self.health - 1
  self.paddle:shrink()
  ```

- when scoring an arbitrary amount of points. To this end I included an additional variable, `threshold`.

  In the serve state. This value is initialized at `1000`.

  ```lua
  function ServeState:enter(params)
    self.threshold = params.threshold or 1000
  end
  ```

  Every time the score surpasses this value, it is then multiplied by a hard-coded measure.

  ```lua
  if self.score > self.threshold then
    self.paddle:grow()
    self.threshold = self.threshold * 2.5
  end
  ```

### Bug

In the _Utils_ function `GenerateQuadsPaddles` I found a mistake in the way the third size is included.

```diff
-quads[counter] = love.graphics.newQuad(x + 96, y, 32, 16, atlas:getDimensions())
+quads[counter] = love.graphics.newQuad(x + 96, y, 96, 16, atlas:getDimensions())
```

Considering the quad with a width of `32` has the effect of cropping the shape to a third of its actual size.
