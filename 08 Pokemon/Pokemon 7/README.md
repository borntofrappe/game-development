Incremental updates:

- add a pokemon class

- add a level class

- consider grass tiles in the walking state

## Pokemon

The class is used to initialize a pokemon, so that ultimately the game renders a creature with `player:render()`.

It is initialized with a table, describing the following fields:

- name, the name of the creature, also used in the textures's table

- type, front or back to describe which sprite to actually use

- x and y, coordinates describing the pokemon position

Based on this value, `Player:render` uses the graphics module as previously done in the start state, and in the battle state, and anywhere else the game would need to render the pokemon.

```lua
function Pokemon:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(gTextures["pokemon"][self.name][self.type], self.x, self.y)
end
```

`setColor(1, 1, 1)` is necessary since the color used on other game elements might influence the color of the texture.

### Default values

Out of convenience, the class provides fallback values for the fields of the pokemon. The idea is to provide a random pokemon in the center of the screen, with the front variant if no input is passed when creating an instance.

```lua
function Pokemon:init(def)
  local def = def or {}
  self.name = def.name or POKEDEX[math.random(#POKEDEX)]
  -- other attributes
end
```

_Nifty_: the first line in the body of the function allows to accommodate for a situation in which the instance is created without a table.

```lua
pokemon = Pokemon()
```

Without that precaution, accessing `def.name` would result in an error, as `def` would be `nil`.

## Level

The level class initializes the world, and in particular the tiles populating the game in the play state. It does this by creating two separate tables, one for the base layer, and one for the tall grass.

```lua
self.baseTiles = {}
self.tallGrassTiles = {}
```

The idea is to ultimately have the player look at the tall grass variant and the id of the tile at the matching column and row. If this tile describes tall grass, then go ahead and trigger an encounter (with given odds).

In order to create a grid of tiles, the two tables are populated by columns and rows.

```lua
for column = 1, self.columns do
  -- add table for the column
  for row = 1, self.rows do
    -- add table for the cell
  end
end
```

The base layer is populated with tiles using the background's ID.

```lua
self.baseTiles[column][row] = Tile(column, row, TILE_IDS["background"])
```

The tall grass layer, however, is populated with tiles using the tall grass's ID only at the prescribed coordinates. Else, the game uses an ID describing an empty tile (consider the numbered tiles between 101 and 104).

```lua
if row > self.tallGrassRows then
  self.tallGrassTiles[column][row] = Tile(column, row, TILE_IDS["tall-grass"])
else
  self.tallGrassTiles[column][row] = Tile(column, row, TILE_IDS["empty"])
end
```
