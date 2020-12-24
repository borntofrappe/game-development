Incorporate changes from the lecturer's code:

- game object

- bushes and cacti

- level maker

The `GameObject` class is used to describe aesthetic objects, like bushes and cati, as well as interactable objects, like gems and jump blocks. In this specific update however, I am solely interested in the first kind, and how objects are included in the logic of the `LevelMaker` class.

## Quads

The quads for the bushes and cacti are incorporated through the `GenerateQuads` function, knowing that each asset covers a 16x16 square of the "bushes_and_cacti" texture. The same is true for the gems and jump blocks — something to consider for future updates.

```lua
gFrames = {
  ["bushes_and_cacti"] = GenerateQuads(gTextures["bushes_and_cacti"], TILE_SIZE, TILE_SIZE)
}
```

With `GenerateQuads` you obtain a one dimensional table, however. Since the visuals are created in rows of similar colors, a more refined solution is to create two dimensional table, whereby each nested table describes a set. This is ultimately what I accomplished with the `GenerateQuadsObject` function, in "Utils.lua"

```lua
function GenerateQuadsObjects(atlas, width, height)
end
```

In the function, I loop through the input image horizontally and vertically, deconstructing individual sprites under the assumption that these occupy a fixed width and height.

```lua
function GenerateQuadsObjects(atlas, width, height)
  local colors = math.floor(atlas:getHeight() / height)
  local varieties = math.floor(atlas:getWidth() / width)
end
```

## GameObject

The class works similarly to `Entity`, in that it sets its position, dimension, and texture considering as input a `def` table.

```lua
function GameObject:init(def)
  self.x = def.x
  -- ...
end
```

Moreover, it repeats the entity's logic to render the specified texture through a `:render` function.

```lua
function GameObject:render()
  love.graphics.draw(
    gTextures[self.texture]
    -- ...
  )
end
```

There are a considerable number of attributes describing objects with which the player can interacted, like `collidable` or `consumable`, but for the specific update, I am once again interested only in adding and rendering individual sprites.

## Objects

It is in the `LevelMaker` class, and the body of the `generate` function, that game objects are included. In the next update, I will cover how the tilemap, objects and entities are included in a `GameLevel` class, but here I decided to have the `generate` function return the objects alongside the tilemap.

```lua
return map, objects
```

In this manner the `PlayState` has access to the table of objects, directly from the level maker.

```lua
function PlayState:init()
  self.level, self.objects = LevelMaker.generate(self.width, self.height)
end
```

These are initialized in `PlayState:init` and rendered _after_ the tilemap.

```lua
function PlayState:render()
  -- level

  for k, object in pairs(self.objects) do
    object:render()
  end
end
```

After the tilemap to have the objects subject of the same camera scroll.

## LevelMaker

Objects are included in a table, initialized alongside the table of tiles.

```lua
function LevelMaker.generate(width, height)
  local tiles = {}
  local objects = {}
end
```

Before creating the level, the function also initializes a variable to describe which particular color to use for the bushes/cacti. In this manner the graphics use the same color set.

```lua
local colorBushesAndCacti = math.random(#gFrames["bushes_and_cacti"])
```

Later, when the loop is in the process of adding ground tiles, the idea is to initialize an object with certain odds.

```lua
if isChasm then
  -- add sky tiles
else
  -- add ground tiles

  local hasBushOrCactus = math.random(5) == 1
end
```

Within these odds, the object is initialized using the newly-minted class.

```lua
if hasBushOrCactus then
  table.insert(
    objects,
    GameObject(
      -- ...
    )
  )
end
```

Using the class with the information describing tis position, but also texture, color and variety. For this last one, the idea is to pick a variety at random from the given color set.

```lua
local variety = math.random(#gFrames["bushes_and_cacti"][colorBushesAndCacti])
```
