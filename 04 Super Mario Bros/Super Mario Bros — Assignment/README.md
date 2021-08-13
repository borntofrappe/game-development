# Super Mario Bros — Assignment

Consider the [assignment for Super Mario Bros](https://docs.cs50.net/ocw/games/assignments/4/assignment4.html).

## Solid ground

> Program it such that when the player is dropped into the level, they’re always done so above solid ground

The update accomplishes the task to have the player not only on solid ground, but above solid ground as well. The idea is to have the player spawn at the very top of the level, so to avoid an immediate collision with a creature.

```lua
self.player =
  Player(
  {
    x = 0,
    y = -PLAYER_HEIGHT,
    -- other attributes
  }
)
```

Just be sure to initialize the player in its falling state, to have the sprite plummet toward the `tileMap`

```lua
self.player:changeState("falling")
```

From this starting point, finding a safe coordinate is a matter of looping through the `tileMap` object and return the coordinate for the first column providing ground tiles. This is achieved with a function, which loops through the columns, and then through the tiles.

```lua
function PlayState:getSafeTile()
  for x = 1, self.width do
    for y = 1, self.height do
      local tile = self.level.tileMap.tiles[x][y]
      if tile.id == TILE_GROUND then
        return tile
      end
    end
  end
end
```

Once the play state has access to a safe tile, the idea is to finally use the tile's coordinate to dictate the position of the player.

```lua
local tile = self:getSafeTile()

self.player =
  Player(
  {
    x = (tile.x - 1) * TILE_SIZE,
    y = -PLAYER_HEIGHT,
    -- other attributes
  }
)
```

### Bug report — safe chasm

An issue emerges when the player looks for a safe tile and finds a chasm. This is because in the `LevelMaker` class, the column describing a chasm have one ground tile still.

```lua
-- if chasm
rows_sky = height

-- set the id
id = y < rows_sky and TILE_SKY or TILE_GROUND,
```

To fix this issue end, increment the `rows_sky` variable by 1 when finding a chasm.

```diff
rows_sky = height
+rows_sky = height + 1
```

With this update, the column doesn't contain anything but sky tiles, and the `getSafeTile` function is able to move to the column which follows.

## Key and lock

> In `LevelMaker.lua`, generate a random-colored key and lock block (taken from `keys_and_locks.png` in the `graphics` folder of the distro). The key should unlock the block when the player collides with it, triggering the block to disappear

### Utils

It is first necessary to build a table for the quads describing the locks and the keys. `keys_and_locks.png` provides the keys and the locks in four colors. I've modified the original image to show the colors in rows instead of columns, so to benefit from the logic of the `GenerateQuadsObjects`. The only difference is semantic and in terms of what _varieties_ are in the resulting 2D table. For each nested table, the first variety refers to the key, while the second refers to the lock with a matching color.

```lua
gFrames["keys_and_locks"][1][1] -- yellow key
gFrames["keys_and_locks"][1][2] -- yellow lock
```

### LevelMaker — booleans

The idea is to include only one lock and key per level. This is achieved by having a boolean refer to whether or not the level already has a lock, whether or not it has a key.

```lua
local hasLock = false
local hasKey = false
```

In the loop creating the level, the idea is to position the lock and key with a certain degree of randomness. Since it is however necessary to ensure that a lock and key will be included, relying solely on `math.random()` is potentially problematic, with a level possibly spawning only one of the two assets. To this end I modified the condition to show a lock or key and tie the boolean to the level's width.

```lua
local showLock = math.random(50) == 1 or x > width * 2 / 5
local showKey = math.random(50) == 1 or x > width * 3 / 5
```

In this fashion, a lock will be spawned, at most after two fifths of the level. A key will be spawned, at most after three fifths.

### LevelMaker — GameObject

The lock is included in the `objects` table in the same fashion as jump blocks: a game object with `isSolid` and an `onCollide` function. This last one is used to simply play the empty block sound — although a different sound byte might be preferable.

```lua
onCollide = function(obj)
  gSounds["empty-block"]:play()
end
```

I've also decided to include a boolean to differentiate the lock. This is useful in the moment the player consumes a key, and the game needs to remove the specific object.

```lua
isLock = true,
onCollide = function(obj)
  gSounds["empty-block"]:play()
end
```

The key is included in the `objects` table similarly to a gem. The `onConsume` function is modified to provide a bigger number of points, but the two share much of their logic.

```lua
onConsume = function(obj, player)
  gSounds["pickup"]:play()
  player.score = player.score + 200
end
```

Once again to differentiate the object however, the object includes another boolean to describe that the object is indeed a key.

```lua
isKey = true,
onConsume = function(obj, player)
  gSounds["pickup"]:play()
  player.score = player.score + 200
end
```

In this fashion, the idea is to have the player consume the object, and remove the lock if the consumed object is a key.

### Player states

As mentioned in the previous section, the idea is to modify the logic of the different states — walking, jumping, falling — when the player consumes an object.

```lua
if object.isConsumable then
  object.onConsume(object, self.player)
end
```

Once the `onConsume` function is called, the script checks if the object is a key.

```lua
if object.isConsumable then
  object.onConsume(object, self.player)
  if object.isKey then

  end
end
```

If so, it loops once more through the objects table, in order to remove the existing lock.

```lua
for j, obj in pairs(self.player.level.objects) do
  if obj.isLock then
    table.remove(self.player.level.objects, j)
    break
  end
end
```

### GameObject

This is something that tricked me considerably. The new boolean `isLock` or `isKey` mean nothing if they are not themselves set in the definition of the game object.

```lua
function GameObject:init(def)
  self.isLock = def.isLock
  self.isKey = def.isKey
end
```

### Bonus

This is not expected from the assignment, but I've decided to experiment further with the way the key is provided to the player. Picking up from the way gems are included, by hitting a block, the idea is to have a jump block which exclusively spawns the key.

```lua
local isKeyHidden = math.random(2) == 1
if isKeyHidden then
  -- spawn a block
end
```

The difference is that the block spawns the key without any doubt.

```lua
onCollide = function(obj)
  if not obj.wasHit then
    obj.wasHit = true
    gSounds["powerup-reveal"]:play()
    local key =
      GameObject(
      {
        -- attributes
      }
    )
    table.insert(objects, key)
  else
    gSounds["empty-block"]:play()
  end
end
```

`wasHit` is still necessary to differentiate the audio played when colliding with the block.

## Goal post

> Once the lock has disappeared, trigger a goal post to spawn at the end of the level. Goal posts can be found in `flags.png`. Note that the flag and the pole are separated, so you’ll have to spawn a `GameObject` for each segment of the flag and one for the flag itself.

### Utils

`flags.png` previously described both the flags and the accompanying flag poles. I've decided to modify the raster image to reuse the logic of `GenerateQuadsObjects`, and have the flags/poles sorted in rows of different colors.

The only difference is that the poles are taller, and this is detailed by two additional constants in `constants.lua`.

```lua
POLE_WIDTH = 16
POLE_HEIGHT = 48
```

### LevelMaker

Since the goal post is shown only after the lock has disappeared, it makes sense to have the object appear exactly where the lock was. To this end, I decided to have the lock shown at ground level, instead of two rows above solid ground.

```diff
-y = rows_sky - 3,
+y = rows_sky - 1,
```

In this situation, the `onCollide` function becomes superfluous, but I decided to keep its logic. This to avoid a situation in which the function is called, but is not available.

```lua
onCollide = function() end
```

With a different anonymous function, the idea is to have the goal post spawn with two game objects.

```lua
onDisappear = function() end
```

The function is called right before the lock is removed, in the different states for the player.

```lua
obj.onDisappear(obj)
table.remove(self.player.level.objects, j)
```

The game objects pick from the `flags` and `poles` tables.

```lua
local flag = GameObject({
  texture = "flags"
})
table.insert(objects, flag)

local pole = GameObject({
  texture = "poles"
})
table.insert(objects, pole)
```

The two are positioned horizontally where the lock was, and vertically to have the pole sit on solid ground.

```lua
local pole =
  GameObject(
  {
    x = obj.x,
    y = obj.y - 2,
  }
```

For the flag however, the horizontal coordinate is incremented by half. This to have the flag centered in the pole.

```lua
local pole =
  GameObject(
  {
    x = obj.x + 0.5,
    y = obj.y - 2,
  }
```

### GameObject

Remember to add the new field `onDisappear` when defining a game object.

```lua
function GameObject:init(def)
  -- other attributes

  self.onDisappear = def.onDisappear
end
```

## New level

> When the player touches this goal post, we should regenerate the level, spawn the player at the beginning of it again (this can all be done via just reloading `PlayState`), and make it a little longer than it was before. You’ll need to introduce `params` to the `PlayState:enter` function that keeps track of the current level and persists the player’s score for this to work properly.

### isGoal

In order to create a new level, it is first necessary to establish when the player collides with the goal post. This is achieved by adding a boolean to the game object describing the pole.

```lua
local pole = GameObject(
  {
    -- other attributes
    isGoal = true,
    onCollide = function()
    end
  }
)
```

Just remember to add the boolean in the class definition.

```lua
function GameObject:init(def)
  -- other attributes
  self.isGoal = def.isGoal
end
```

### State

In the different states for the player — jumping and falling — the game is already equipped to consider a collision with solid objects. By adding an additional if statement, the idea is to use the global `gStateMachine` to create a new level by going (once more) to the `PlayState`.

```lua
if object.isSolid then
  if object.isGoal then
    gStateMachine:change("play")
  end
end
```

For the walking state, the logic is a tad different. When the player walks, it uses the `checkObjectCollision` function to avoid moving beyond solid objects. In light of this, looping through the objects in the `WalkingState` would not work, as the player would never be allowed to collide with any object.

The change in state is therefore introduced in the `checkObjectCollision` function itself.

### Params

When moving to the new state, the idea is to preserve the score and increase the length of the level. To this end, the function changing the state machine includes as a second argument a table specifying both values.

For the width, it's possible to access the value by looking at the `width` attributed to the tileMap. For the score, this is stored in the instance of the player class.

```lua
gStateMachine:change("play", {
  width = self.player.tileMap.width + 10,
  score = self.player.score
})
```

Once the function specifies the table, it is finally necessary to update the `PlayState` so that it receives the parameters in `PlayState:enter()`. The idea is to here migrate to the function the code previously described in `:init`, but now dependent on the input parameters.

```lua
function PlayState:enter(params)
  self.width = 60
  self.height = 10

  self.level = LevelMaker.generate(self.width, self.height)

  local tile = self:getSafeTile()
  self.player =
    Player(
    {
      -- other attributes
      score = 0
    }
  )

  -- .. creatures
end
```

When such parameters are provided, the idea is to then use the received values to build the level, and subsequently create the player.

```lua
function PlayState:enter(params)
  self.width = params and params.width or 60
  self.height = 10

  self.level = LevelMaker.generate(self.width, self.height)

  local tile = self:getSafeTile()
  self.player =
    Player(
    {
      -- other attributes
      score = params and params.score or 0
    }
  )

  -- .. creatures
end
```

## Additional Notes

> unscheduled updates

### table.remove

When I remove the key _and_ the accompanying lock, there is a potential issue in removing the appropriate elements from the `objects` table.

```lua
if object.isConsumable then
  if object.isKey then
    for j, obj in pairs(self.player.level.objects) do
      if obj.isLock then
        table.remove(self.player.level.objects, j)
        break
      end
    end
  end
  table.remove(self.player.level.objects, k)
end
```

In this instance, the risk is that `self.player.objects` changes by removing the `j`-th element before the `k`-th element. With this in mind, I decided to immediately remove the `k`-th element, the key, and then remove the `j`-th element, the lock, looping through the now-updated table.

```lua
if object.isConsumable then
  table.remove(self.player.level.objects, k)
  if object.isKey then
    for j, obj in pairs(self.player.level.objects) do
      if obj.isLock then
        table.remove(self.player.level.objects, j)
        break
      end
    end
  end
end
```
