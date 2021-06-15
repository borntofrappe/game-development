# Breakout — Assignment

[The assignment](https://docs.cs50.net/ocw/games/assignments/2/assignment2.html) has the following objectives:

- [x] add a powerup to the game that spawns two extra `Ball`s

- [x] grow and shrink the `Paddle` when the player gains enough points or loses a life

- [x] add a locked `Brick` that will only open when the player collects a second new powerup, a key, which should only spawn when such a `Brick` exist and randomly as per the `Ball` powerup

## Powerup

The powerups are included in `breakout.png` and in the last row of the image. In terms of coordinates, they begin at the point (0, 192) and continue with squares with a 16x16 size.

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

Once the powerups are included, it's necessary to detect a collision between the powerups and the paddle. Instead of repeating the logic of the `Ball:collides()` function, I decided to add a global function in `main.lua`.

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

In the function `GenerateQuadsPaddles` I found a mistake in the way the third size is included.

```diff
-quads[counter] = love.graphics.newQuad(x + 96, y, 32, 16, atlas:getDimensions())
+quads[counter] = love.graphics.newQuad(x + 96, y, 96, 16, atlas:getDimensions())
```

Considering the quad with a width of `32` has the effect of cropping the shape to a third of its actual size.

## Powerup revisited

Considering the way the key powerup is included, I realized that the previous approach for the powerup is insufficient. Instead of having a separate table for the powerups, I feel it is better to have the powerups as fields, as attributes of the `Brick` class. With this approach, unlocking a brick is a matter of picking up the key powerup for the same brick. This revision requires a few changes, but I think it's worth the effort.

As mentioned, the `self.powerups` table becomes redundant, so any use of the variable is removed from the codebase.

To determine if a brick has a powerup, add another flag in the `LevelMaker` function.

```lua
powerupFlag = math.random(1, 5) == 2
brick = Brick((col - 1) * 32 + (VIRTUAL_WIDTH - cols * 32) / 2, row * 16, tier, color, powerupFlag)
```

Then, modify the `Brick` class to add a powerup, and update/render the sprite when the brick is destroyed.

I made the decision of always including a powerup, but show the asset only if the flag resolves to `true`

```lua
function Brick:init(x, y, tier, color, hasPowerup)
  self.hasPowerup = hasPowerup
  self.powerup = Powerup(self.x + self.width / 2, self.y + self.height / 2)
end
```

With this basic structure:

- introduce the powerup when the brick is destroyed

  ```lua
  function Brick:hit()
    self.inPlay = false
    if self.hasPowerup and not self.powerup.inPlay then
      self.powerup.inPlay = true
    end
  end
  ```

- update and render the powerup only when the boolean instructs so

  ```lua
  function Brick:update(dt)
    if self.hasPowerup and self.powerup.inPlay then
      self.powerup:update(dt)
    end
  end

  function Brick:render()
    if self.hasPowerup and self.powerup.inPlay then
      self.powerup:render()
    end
  end
  ```

The play state requires a few adjustment as well. These are however centered on the fact that you do not consider a collision between the paddle and the powerups in the `self.powerups` table — which no longer exist — but between the paddle and the possible powerup of the brick.

```lua
for k, brick in pairs(self.bricks) do
  if brick.hasPowerup and brick.powerup.inPlay and testAABB(self.paddle, brick.powerup) then
    brick.powerup.inPlay = false
    table.insert(self.balls, Ball(brick.powerup.x, brick.powerup.y))
  end
end
```

In the previous snippet, a collision with the paddle results in a ball being included in the `self.balls` table, but ultimately, that happes only if the powerup matches the desired sprite.

```lua
if brick.powerup.powerup == 9 then
  table.insert(self.balls, Ball(brick.powerup.x, brick.powerup.y))
end
```

This is important in the moment the game contemplates more types of powerup, like the one for the key.

## Locks and keys

The third section of the assignment requires the use of two particular sprites. These are included in the quads for the bricks table, looking for specific coordinates.

For the "unlocked" brick, it is a matter of extending the `GenerateQuads` function to consider one additional rectangle.

```diff
-quads = table.slice(GenerateQuads(atlas, 32, 16), 1, 20)
+quads = table.slice(GenerateQuads(atlas, 32, 16), 1, 21)
```

For the locked version, it is however necessary to extract the 32x16 shape at the end of the row. The sprite is added as the last element of the table using the `#` length character, but the `table.insert` method would equally work.

```lua
quads[#quads + 1] = love.graphics.newQuad(160, 48, 32, 16, atlas:getDimensions())
```

With the updated table, the two specific brick are rendered through `gFrames[22]` and `gFrames[21]` respectively. For instance and for the locked brick.

```lua
love.graphics.draw(gTextures["breakout"], gFrames["bricks"][22], self.x, self.y)
```

### Bug

In the level maker, I made the mistake of using `4` as the maximum number for both the tier and color value. However, there are actually five color varieties.

```diff
-maxColor = math.min(4, math.ceil(level / 4))
+maxColor = math.min(5, math.ceil(level / 4))
```

### LockedBrick

Instead of developing the feature in the `Brick` class, which would require several more conditionals, I decided to create a new class in `LockedBrick`. This one inherits from `Brick`, but ultimately overrides most of its methods.

On top of the boolean `inPlay`, the class specifies a boolean `isLocked`.

```lua
function LockedBrick:init(x, y)
  self.isLocked = true
end
```

It also describes a specific powerup, number 10, to show the key.

```lua
function LockedBrick:init(x, y)
  self.hasPowerup = true
  self.powerup = Powerup(self.x + self.width / 2, self.y + self.height / 2, 10)
end
```

With this structure, the idea is to modify the `hit` function to remove the brick only if the brick is unlocked. Otherwise, spawn the key powerup.

In the render function finally, show either sprite based on the `boolean`.

```lua
if self.isLocked then
  love.graphics.draw(gTextures["breakout"], gFrames["bricks"][22], self.x, self.y)
else
  love.graphics.draw(gTextures["breakout"], gFrames["bricks"][21], self.x, self.y)
end
```

### Level maker, play state and powerup

The inclusion of a new class requires a few changes to the codebase. FIrst off, it is necessary to included an instance of the locked version, following a certain probability.

```lua
lockFlag = math.random(1, 10) == 2
if lockFlag then
  brick = LockedBrick(...)
  table.insert(bricks, brick)
else
  -- include normal bricks
end
```

In the play state, it's necessary to consider the powerup, to "unlock" the connected brick.

```lua
if brick.isLocked and brick.powerup.powerup == 10 then
  brick.isLocked = false
end
```

It is also necessary to consider the locked version when updating the score.

```lua
if brick.tier and brick.color then
  self.score = self.score + 50 * brick.tier + 200 * (brick.color - 1)
elseif not brick.isLocked then
  self.score = self.score + 1000
end
```

Finally, and in the powerup class, it's necessary to make sure that the powerup returns to its original `y` coordinate if it doesn't hit the paddle and goes past the bottom of the game window.

```lua
function Powerup:init(x, y, isKey)
  self.startingY = self.y
end

function Powerup:update(dt)
  if self.y > VIRTUAL_HEIGHT then
    self.inPlay = false
    self.y = self.startingY
  end
end
```

It is unnecessary for regular powerups, but for the key, it is essential. Without this fix, there is a possibility that the paddle doesn't collect the powerup and the brick remains locked without end.
