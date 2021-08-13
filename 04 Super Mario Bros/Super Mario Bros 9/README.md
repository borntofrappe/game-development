# Super Mario Bros 9

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Super Mario Bros — Final`.

## Creature look

Following the example of the player, I've rendered the sprite for the creature with the same logic of position and scale.

```lua
function Creature:render()
  love.graphics.draw(
    -- texture,
    self.direction == "right" and math.floor(self.x) or math.floor(self.x + self.width),
    math.floor(self.y),
    0,
    self.direction == "right" and 1 or -1,
    1
  )
end
```

The issue is that, by default, the sprites for the creatures look to the left. This means the negative scale is necessary when moving to the right.

```lua
function Creature:render()
  love.graphics.draw(
    -- texture,
    self.direction == "left" and math.floor(self.x) or math.floor(self.x + self.width),
    math.floor(self.y),
    0,
    self.direction == "left" and 1 or -1,
    1
  )
end
```

The class is also updated to use a frame from the current animation.

```lua
love.graphics.draw(
    gTextures[self.texture],
    gFrames[self.texture][self.type][self.currentAnimation:getCurrentFrame()],
    -- scale
)
```

And since this animation is set only at a later stage, a default value is initialized in the `init` function.

```lua
function Creature:init(def)
  self.currentAnimation =
    Animation(
    {
      frames = {1},
      interval = 1
    }
  )
end
```

## Creature states

The creatures are scheduled to have three states: idle, moving, and chasing. By default, they are meant to be idle, to stand still. Only when visible then, they are meant to move. Finally, and only when the player is within reach, they are meant to chase.

The three states share a few commonalities. In the way they are first initialized, all consider the following arguments:

- tileMap, to have the creature react to the surrounding tiles — for instance by changing direction when finding a chasm or a pillar

- player, to consider the distance between creature and the player itself

- creature, to change the state and the animation of the individual creature. This is similar to the player's own states

Every instance also defines an animation, and this is exactly the same as with the player. Keep in mind that the creatures are rendered with a table of three sprites, the first two of which show the creature moving.

## Idle

This is the default state of the creature, and shows the creature in its static version. The idea is to have the creatures move when they are shown in the same window as the player, and this is achieved by looking at the player's coordinates.

```lua
function CreatureIdleState:update(dt)
  if math.abs(self.player.x - self.creature.x) < VIRTUAL_WIDTH then
    self.creature:changeState("moving")
  end
end
```

`VIRTUAL_WIDTH` is actually more than necessary, and strictly speaking, the creatures are in the same space as the player considering half the game's width, the player's and creature's widths. This simpler measure is however preferable to have the creatures move with more leniency.

_Update_: the idle state doesn't need a reference to the tileMap table. It's entirely possible to define the state without it.

## Moving and chasing

The remaining two states share much of the logic in the `:update` function. This is because in both instances the snail moves by changing the `self.x` coordinate and following the direction described by `self.direction`. The only difference is that the direction is initialized with a random value in the moving state, and considering the position of the player in the chasing state.

Both state also share the same animation, alternating between the two sprites of the creature's table.

```lua
self.animation =
  Animation(
  {
    frames = {1, 2},
    interval = 0.5
  }
)
```

### Moving

As mentioned, initialize the direction to left or right, picking a value at random.

```lua
self.direction = math.random(2) == 1 and "right" or "left"
```

Be sure to also modify the direction of the creature, to have the two match. This is something to consider every time the direction changes.

```lua
self.creature.direction = self.direction
```

In the update function then, modify the `x` coordinate according to the direction.

```lua
if self.direction == "right" then
  self.creature.x = self.creature.x + CREATURE_MOVE_SPEED * dt
else
  self.creature.x = self.creature.x - CREATURE_MOVE_SPEED * dt
end
```

This works to move the creature, but it's necessary to consider the movement with respect to the tileMap and with respect to the player.

For the player, the idea is to move to the chasing state when the player is closer than a fixed range, or to the idle state when the distance is larger than the prescribed `VIRTUAL_WIDTH`.

```lua
if math.abs(self.player.x - self.creature.x) < CREATURE_CHASING_RANGE then
  self.creature:changeState("chasing")
end

if math.abs(self.player.x - self.creature.x) > VIRTUAL_WIDTH then
  self.creature:changeState("idle")
end
```

For the tileMap, the idea is to instead consider the tiles to the left or to the right of the creature, and flip the direction if necessary:

- when the tiles describe a pillar

- when the tiles describe a chasm

Given the movement and structure of the creature, it's possible to simplify the logic by checking the tile on the side of the creature for the pillar, and the tile one pixel below the creature for the chasm.

When the creature moves to the right, for instance:

- consider the two tiles on the right side

```lua
local tileTopRight = self.tileMap:pointToTile(self.creature.x + self.creature.width, self.creature.y)

local tileBottomRight = self.tileMap:pointToTile(self.creature.x + self.creature.width, self.creature.y + self.creature.height + 1)
```

Check the `id` of the two tiles, to find if the creature is next to a pillar or chasm.

```lua
if tileTopRight.id == TILE_GROUND or tileBottomRight.id == TILE_SKY then
end
```

Flip the direction, once again updating the direction of the creature as well.

```lua
self.creature.x = (tileBottomRight.x - 1) * TILE_SIZE - self.creature.width
self.direction = "left"
self.creature.direction = self.direction
```

`self.creature.x` is updated to ensure that the creature starts from the very edge describing the tile.

## Chasing

As mentioned, initialize a direction, but looking at the position of the creature vis-a-vis the position of the player.

```lua
self.direction = self.player.x > self.creature.x + self.creature.width
self.creature.direction = self.direction
```

In the `update` function then, continue checking the difference to update the direction as the player and the creature move.

```lua
if self.player.x > self.creature.x + self.creature.width then
  -- move to the right
elseif self.player.x < self.creature.x then
  -- move to the left
end
```

In terms of movement, the logic is the same described for the move state:

- update `self.direction`

- update `self.creature.x` considering the arbitrary speed

- consider the tiles on the side of the creature

There is a small difference with respect to the tiles however. When the creature finds a pillar or a chasm, the idea is to fix the position of the creature, instead of changing its movement toward the opposite side. This is a bit of a judgment call, but is motivated by the fact that the creature should keep its direction toward the chased player.

## PlayState

It is not possible to initialize the state machine in the `LevelMaker` class, since in the level maker the creatures don't have access to the tileMap, nor the player. This is why the play state is updated in the `PlayState:init` function. The idea is to here add a function to add the aforementioned state machine and to every creature stored in the `entities` table.

- loop through the table

  ```lua
  function PlayState:addCreaturesState()
    for k, entity in pairs(self.level.entities) do
    end
  end
  ```

- initialize an instance of the `StateMachine` class for every entity

  ```lua
  entity.stateMachine =
    StateMachine(
    {
      ["idle"] = function()
        return CreatureIdleState(self.player, entity)
      end,
      -- other states
  )
  ```

- immediately set the `idle` state

  ```lua
  entity:changeState("idle")
  ```

## GameLevel

While the entities are able to move, it is finally necessary to call the `:update` function for each entity. This is included in the `GameLevel` class, the helpful container detailing tileMap, objects and entities.

```lua
function GameLevel:update(dt)
  for k, entity in pairs(self.entities) do
    entity:update(dt)
  end
end
```

The function is ultimately called on the instance of the level in the `PlayState`.

```lua
function PlayState:update(dt)
  self.level:update(dt)
end
```
