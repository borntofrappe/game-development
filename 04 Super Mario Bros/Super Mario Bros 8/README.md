# Super Mario Bros 8

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Super Mario Bros — Final`.

_Please note_: the movement of the creatures is the subject of the next update. This increment populates the game with creatures, and has the player reacts a collision with their static version.

## Utils

`creatures.png` is modified to have every creature in three variants. The first two show the "alive" states, and are alternated as the creature moves. The latter shows the "hit" state, and is perhaps meant to be shown right before the game removes the entity.

The `GenerateQuadsCreatures` function is specified to build a 2D table, where each nested table describes a creature through its different states. This means the `render` function is inherently different from that of the player — a class in which the sprites are provided in a one dimensional table.

## Creature

The class is initialized to inherit from `Entity`. This means the creature is described by its position, movement, texture, much similarly to the player. To access the sprite of a creature however, an additional attribute is specified in the type of the creature.

```lua
function Creature:init(def)
  Entity.init(self, def)
  self.type = def.type
end
```

In this fashion, the `render` function is allowed to consider the specific sprite in the aforementioned 2D table.

```lua
function Creature:render()
  love.graphics.draw(
    gTextures[self.texture],
    gFrames[self.texture][self.type][1],
    -- position
  )
end
```

It's worth noting that the `Creature:render()` function repeats much of the logic described by `Entity:render()`.

```lua
function Creature:render()
  love.graphics.draw(
    gTextures[self.texture],
    gFrames[self.texture][self.type][1],
    self.direction == "right" and math.floor(self.x) or math.floor(self.x + self.width),
    math.floor(self.y),
    0,
    self.direction == "right" and 1 or -1,
    1
  )
end
```

It is however necessary to override the `:render()` functionality to consider the nested nature of `gFrames["creatures"]`.

## LevelMaker

While the lecturer includes a function to spawn entities, the `LevelMaker.generate()` function and `GameLevel` class are more than equipped to consider entities. The idea is to:

- populate a `entities` table alongside the `tiles` and `objects` ones

  ````lua
  function LevelMaker.generate(width, height)
    -- map and objects
    local entities = {}
  ```lua

  ````

- incorporate the entities in the `level` provided by `GameLevel`

  ```lua
  function GameLevel:init(def)
    -- map and objects

    self.entities = def.entities
  end
  ```

- render the entities much similarly to the objects

  ```lua
  function GameLevel:render()
    -- map and objects

    for k, entity in pairs(self.entities) do
      entity:render()
    end
  end
  ```

In `LevelMaker`, and in more details, a creature is spawned with certain odds when the game specifies solid ground, but not a pillar.

```lua
local isChasm = math.random(8) == 1
if isChasm then
  --
else
  local isPillar = math.random(8) == 1
  if isPillar then
    --
  else
    local hasCreature = math.random(8) == 1
    if hasCreature then
      -- spawn creature
    end
  end
end
```

For the specific update, I decided to use a creature from the first 6 variants, have the creature spawn above solid ground looking toward the player.

```lua
local type = math.random(6)
local creature = Creature(
{
  x = (x - 1) * TILE_SIZE,
  y = (rows_sky - 1 - 1) * TILE_SIZE,
  width = TILE_SIZE,
  height = TILE_SIZE,
  texture = "creatures",
  direction = "left",
  type = type
}
```

Mindful of adding the creature to the `entities` table.

```lua
table.insert(entities, creature)
```

## Collision

To check for a collision with an entity, the `Entity` class is updated to include a `collides` function. This works similarly to `GameObject:collides()`, but the AABB test works by comparing the coordinates directly.

```lua
function Entity:collides(target)
  if target.x + target.width < self.x or target.x > self.x + self.width then
    return false
  end

  if target.y + target.height < self.y or target.y > self.y + self.height then
    return false
  end

  return true
end
```

This is because the player and creatures share the same coordinate system, unlike the game objects which are positioned on the basis of the level's grid.

From this starting point, the idea is to consider entities in the different states of the player. Depending on the state, the behavior is indeed different:

- in the falling state, remove the entity — and award an arbitrary amount of points

  ```lua
  for k, entity in pairs(self.player.level.entities) do
    if entity:collides(self.player) then
      self.player.score = self.player.score + 100
      table.remove(self.player.level.entities, k)
    end
  end
  ```

- in the walking state, but the same holds true in the jumping state, go to the start state. This is an immediate way to produce a gameover

  ```lua
  for k, entity in pairs(self.player.level.entities) do
    if entity:collides(self.player) then
      gStateMachine:change("start")
    end
  end
  ```
