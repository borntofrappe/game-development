# Super Mario Bros 2

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Super Mario Bros — Final`.

## Tile

The class is responsible for initializing and rendering individual tiles.

Picking up from the previous update, it works by initializing a few variables to set its position and appearance.

```lua
function Tile:init(x, y, id, isTopper, tileset, topperset)
end
```

`isTopper` is used to add an additional sprite in the form of the topper graphic. `tileset` and `topperset` describe the specific sprite from the respective table of quads.

Most prominently, `id` describes the nature of tile — think sky or ground. On the basis of this identifier, the game is able to ultimately determine the gameplay — say having the enemy fall when the tiles below describe the sky.

It's important to note that `x` and `y` describe the position in the grid making up the level, not the actual coordinates in the game window. In the `render` function, it's therefore necessary to use the tile size to position the individual asset.

```lua
function Tile:render()
  love.graphics.draw(
    gTextures['tiles'],
    gFrames['tiles'][self.tileset][self.id],
    (self.x - 1) * TILE_SIZE,
    (self.y - 1) * TILE_SIZE
  )
end
```

### Tile:collidable

The function compares the `id` with the values collected in a constant to describe if the tile is collidable — can be collided with. This is included in a future update when I actually describe tile collision.

### def

Similarly to the way the player and entity are initialized, I decided to modify the `Tile` class to accept a table, and use the table's own values to initialize the coordinates, dimensions and so on. This makes it easier to avoid issues with the order in which the arguments are specified.

## LevelMaker

The focus is here on the way the map is built and rendered. In a future update, I will consider the procedural generation behind the lecturer's algorithm, and also the introduction of a `GameLevel` class. This last one is used to contain the map, entities, and objects of the entire game, and warrants further consideration.

`LevelMaker` builds a table with the tiles, much similarly to the previous updates. Instead of adding tables with `id`, `x` and `y` values however

```lua
local tile = {
  id = y < rows_sky and TILE_SKY or TILE_GROUND,
  topper = y == rows_sky
}
```

It injects in the table instances of the `Tile` class.

```lua
local tile =
  Tile(
  {
    x = x,
    y = y,
    id = y < rows_sky and TILE_SKY or TILE_GROUND,
    tileset = tileset,
    isTopper = y == rows_sky,
    topperset = topperset
  }
)
```

`tileset` and `topperset` are initialized at the top of the `LevelMaker` class, so to have every tile share the same aesthetic.

## TileMap

`LevelMaker` doesn't return the table of tiles, but instead a `map` created with the `TileMap` class (there is actually a wrapper class in the form of `GameLevel`, but as mentioned earlier, this will be discussed in a future update).

`TileMap` is used to take the tiles and provide two helper functions. With `render`, the game is able to render the level by using `level:render()`. With `pointToTile`, the game is further able to pinpoint a specific tile matching the input coordinates. Consider the next update for more details.

### init

The class is initialized with the `width` and `height` values describing the game.

```lua
function TileMap:init(width, height)
  self.width = width
  self.height = height
end
```

Further, the function specifies `self.tiles`, but as an empty table.

```lua
function TileMap:init(width, height)
  self.tiles = {}
end
```

This is because the tiles are defined in the `LevelMaker` class, and injected from said class.

```lua
local map = TileMap(width, height)
map.tiles = tiles
```

### render

Based on the map's own dimension, the `render` function loops through the table to render the individual tiles.

```lua
function TileMap:render()
  for x = 1, self.width do
    for y = 1, self.height do
      self.tiles[x][y]:render()
    end
  end
end
```

You can use the length to loop through the 2D table — `#tiles` and `#tiles[column]`, but having a value for the width and height simplifies the syntax. It's also useful for the `pointToTile` function introduced in the next update.
