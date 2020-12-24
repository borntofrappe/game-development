Incorporate changes from the lecturer's code:

- callback functions

- gems

## Quads

In a previous update, I generated the quads for the gems in the same fashion described for the jump blocks or bushes and cacti. The graphics have however a different structures, with the gems describing different colors in different columns instead of rows.

The solution is to either define a new function, `generateQuadsGems`, to section the gems in the same order, color and variety, or update the image altogether. I decided to modify the image to follow the pattern introduced by the jump blocks.

## Callback functions

The idea is to attach anonymous functions to game objects, and fire these functions to produce the desired behavior. For instance, and for the jump blocks, the idea is to include a function to add a gem object to the `objects` table.

```lua
GameObject(
{
  -- previous attributes
  onCollide = function()

  end
}
```

The `GameObject` class is updated to incorporate the function.

```lua
function GameObject:init(def)
  -- previous attributes

  self.onCollide = def.onCollide
end
```

And the individual object fires the function when necessary — for the jump blocks in the player's jumping state.

```lua
if object.isSolid and object:collides(self.player) then
  object.onCollide()
  -- go to falling state
end
```

This pattern is repeated for other game objects, like gems:

- define callback function

- update the `GameObject` class to include the function in the class definition

- call the function

## Jump blocks

For the jump block, the `onCollide` function is defined to accept as argument an object.

```lua
onCollide = function(obj)
end
```

This object is the jump block itself, and is specified to have a gem spawn relative to the specific block.

```lua
if object.isSolid and object:collides(self.player) then
  object.onCollide(object)
end
```

In the body of the function, the logic flows as follows:

- check if the block was already hit

  ```lua
  onCollide = function(obj)
    if not obj.wasHit then
      obj.wasHit = true
    end
  end
  ```

  The idea is to spawn gems at random, and not for every jump block. `wasHit` is included as an additional attribute to ensure that if a gem doesn't spawn immediately, it never will.

- create a game object from the `gems` texture, and with certain odds

  ```lua
  local hasGem = math.random(2) == 1
  if hasGem then

  end
  ```

## Gems

Gems are included through the `GameObject` class, and similarly to jummp blocks or bushes and cacti. Using the position of the jump block, it's furthermore possible to have the gem appear above the block itself.

```lua
local gem = GameObject(
  {
    x = obj.x,
    y = obj.y - 1,
    texture = "gems"
  -- other attributes
  }

table.insert(objects, gem)
```

Finally, and with another callback function, it's possible to have the gem increase the player score. This is achieved by adding another boolean, `isConsumable`, to differentiate how the player reacts to game objects:

- if solid, consider a collision, as introduced earlier with the jump block

  ```lua
  if object.isSolid then
    object.onCollide(object)
  end
  ```

- if consumable, remove the object from the `objects` table

  ```lua
  elseif object.isConsumable then
    object.onConsume(object, self.player)
    table.remove(self.player.level.objects, k)
  end
  ```

  `self.player` is passed to the function to have the gem increase the score from the level maker.

  ```lua
  onConsume = function(obj, player)
    player.score = player.score + 100
  end
  ```

  Ultimately, this could have been included in the jump state as well, but in the level maker, it gives a clearer purpose to the game object.
