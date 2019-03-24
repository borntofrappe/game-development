# Match Three

For the fourth installment in the introduction to game development @cs50, the game is **Match Three**. The dynamic behind the game may appear basic in nature (clear blocks when three of the same color as side by side), but the project promises plenty of challenges.

## Topics

The lecture promises to delve in the following topics:

- anonymous functions, essential part of the language;

- tweening, interpolating between two values, for instance to animate objects;

- timers, using a library to more efficiently tackle time-based events;

- clearing matches, concerning the actual dynamic of the game;

- procedural grids, regarding the creation of levels;

- sprite art and palettes, creating the actual assets.

## Goal

The game is structured as follows:

- title screen, introducing the game through an animated visual;

- level screen, transitioning the game from the title to the play screen, again with an animated visual;

- play screen, where the game actually unfolds.

The idea in the play screen is to have a timer and a goal. Clear the goal before the timer reache zero and you are prompted with a new level. Let the timer hit zero and the game is over.

## Project Structure

The game isn't developed in the same manner as Pong, Flappy Bird or Breakout. Instead of developing the game continuously, one step at a time, the video proceeds by introducing the different concepts behind the game, such as the timer or tweening, and only later develop the actual game. In light of this change, the organization of the repository is also modified: you find the concepts into their own folder and later you find the game with the same naming convention used for the first three games (you will therefore find folders labeled 'Timer', 'Tweening', and only later 'Match Three 0', 'Match Three 1' and so forth and so on).

Small update: I decided to label the folders describing the founding concept with the **Prep** prefix. Following up from the code developed in each one of them, the game is developed in increments following the mentioned convention.

## Assignment

[Assignments from the lecturer](https://cs50.harvard.edu/games/2019/spring/assignments/3/):

- [x] _Implement time addition on matches, such that scoring a match extends the timer by 1 second per tile in a match_

- [x] _Ensure Level 1 starts just with simple flat blocks (the first of each color in the sprite sheet), with later levels generating the blocks with patterns on them (like the triangle, cross, etc.)_

  - [x] _These should be worth more points, at your discretion_

- [x] _Create random shiny versions of blocks that will destroy an entire row on match, granting points for each block in the row_

- [x] _Only allow swapping when it results in a match_

- [ ] _(Optional) Implement matching using the mouse_

### Time Addition

This point was already covered, but the code is nevertheless updated to suit the assignment specification. A match results in one second added for each tile.

In `PlayState.lua`.

```lua
if matches then
  gSounds['match']:play()
  -- loop through the table of matches
  for k, match in pairs(matches) do
    -- loop through the tiles of each match
    for j, tile in pairs(match) do
      -- add a second per match
      self.time = self.time + 1

      -- add fifty points per tile
      self.score = self.score + 50

      -- continue adding new tiles
    end
  end
end
```

### Flat Blocks and Levels

The logic required for the second point can be implemented similarly to breakout and its `LevelMaker` class. To fulfill the requirements, the structure of the grid is modified in the `lua` file generating the grid itself.

In `PlayState.lua`, the grid is generated with a new variable identifying the level.

```lua
function PlayState:init()
  self.level = 1
  self.score = 0
  self.goal = 1000
  self.time = 60
  self.board = Board((VIRTUAL_WIDTH - (VIRTUAL_WIDTH / 6 - VIRTUAL_WIDTH / 8) - (8*32)), (VIRTUAL_HEIGHT - (8 * 32)) / 2, self.level) -- modified

  -- rest of the init function
end
```

Additionally, the level is passed to the `removeMatches` function, as to have the board once more populated on the basis of the level.

```lua
-- when finding a match
self.board:removeMatches(self.level)
```

The `Board` class is then responsible for the actual implementation of the level logic.

The `init` function is set to accept an additional value in `level`.

```lua
function Board:init(offsetX, offsetY, level)
  self.offsetX = offsetX
  self.offsetY = offsetY
  self.level = level
  -- immediately generate the board on the basis of the level
  self.tiles = self:generateBoard(self.level)

  self.selectedTile = self.tiles[math.random(8)][math.random(8)]
  self.highlighted = false
  self.highlightedTile = self.selectedTile

  self.matches = {}
end
```

Notice how the level is imediately incorporated in the `generateBoard` function. It is also set up in `self.level` to have it ripple to the `removeMatches` function.

Based on the level, the `generateBoard` function includes tiles without any shape. As the function fundamentally receives always a value of 1 (it is only called as the game is set up), it is possible to leverage the single digit value.

```lua
-- use the current level to determine the variant of the tile
local color = math.random(8)
local shape = math.min(math.random(level), 8)
table.insert(tiles[y], Tile(x, y, self.offsetX, self.offsetY, color, shape))
```

The value is always 1, and the logic seems unnecessary, but coming an update in which the game is made to start at a later level (if that would ever happen), the function would be already equipped to handle the change.

Perhaps most conveniently, the logic can be included in the `updateBoard` function as-is, on the basis of the level received from the `removeMatches` method.

#### Small Update

The `color` variable is also updated to include a precise set of colors. Specifically, the variants on the left side of the texture describing the tiles.

```lua
local color = (math.random(8) * 2) - 1
```

This allows to pick 8 variants, all with the green/blue hues.

#### Final Setup

To remark the different shapes, the score is finally updated not only to account for the number of matches, but also the different shapes described in the tiles. The higher the shape of a tile, the higher the reward. Starting with a fixed amount, the score is augmented by an arbitrary measure.

```lua
for j, tile in pairs(match) do
  -- add a second
  self.time = self.time + 1
  --[[
    increment the score
    50 points by default
    bonus of 25 based on the tile's variety
  ]]
  local bonus = (tile.variety - 1) * 25
  self.score = self.score + 50 + bonus
end
```

Turns out the `Tile` class doesn't use `shape`, but `variant` to describe the possible colored tiles. In light of this, any reference to the local `shape` variable is updated to match.

### Shiny Versions

Shiny versions are included in the same snippet describing the different shapes portrayed by the tiles. Following a certain probability, at least an order of magnitude less than the existing odds, a flag is set up to describe a shiny tile.

```lua
local color = (math.random(8) * 2) - 1
local variety = math.min(math.random(level), 8)
local isShiny = math.random(20) == 2
local tile = Tile(x, y, self.offsetX, self.offsetY, color, variety, isShiny)
```

The flag is then included in the `init` function.

```lua
function Tile:init(gridX, gridY, offsetX, offsetY, color, variety, shiny)
  self.gridX = gridX
  self.gridY = gridY
  self.x = (gridX - 1) * 32 + offsetX
  self.y = (gridY - 1) * 32 + offsetY
  self.shiny = shiny -- new

  self.color = color
  self.variety = variety

  self.tiles = self:arrange()
end
```

Visually, it is finally used in the `render()` function to overlay a translucent rectangle on top of the tile in question.

```lua
function Tile:render()

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(gTextures['spritesheet'], self.tiles[self.color][self.variety], self.x, self.y)


  -- if shiny superimpose a translucent white overlay atop a slightly more opaque, but still white border
  if self.shiny then
    love.graphics.setColor(1, 1, 1, 0.1)
    love.graphics.rectangle('fill', self.x, self.y, 32, 32, 8)

    love.graphics.setLineWidth(4)
    love.graphics.setColor(1, 1, 1, 0.3)
    love.graphics.rectangle('line', self.x + 2, self.y + 2, 28, 28, 8)
  end
end
```

This covers displaying the shiny variant, with the mentioned rectangle and a slightly more opaque border (this is added to increase the contrast relative to normal tiles).

In terms of gameplay, which is perhaps the trickies part of the feature, the flag needs to be however used to actually update the board. If a match is found and a shiny variant is present, the entire row in which the shiny variant finds itself should cleared.

The idea, which is rather intelligent if I may add, is to have a function responsible for clearing the row. This function, instead of actually setting the values to `nil`, sets the color for every tile in the row to match.

```lua
function Board:clearRow(row, color)
  -- loop through the board
  for y = 1, 8 do
    for x = 1, 8 do
      -- for every tile in the row change the color to match the shiny variant
      if y == row then
        self.tiles[y][x].color = color
      end
    end
  end
end
```

This allows the `calculateMatches` to intervene, pick up the matches and clearing the board. All is necessary is the inclusion of the function in the play state, and logically following the removal of existing matches.

```lua
self.board:removeMatches(self.level)

-- if shiny change the color of each tile in the row to match
if tile.shiny then
  self.board:clearRow(tile.gridY, tile.color)
end
```

A better name would actually be `colorRow`. Indeed, the function is actually and indirectly clearing the row by applying the same hue and have the `calculateMatches` find the matches. In turn the matches are processed in the play state and removed through the `removeMatches` method.

### Variants Update

There are 6 variants, and not 8 in the spritesheet. This means the following line of code has the ability to break the game after level 6.

```lua
local variety = math.min(math.random(level), 8)
```

Fixing the issue is a simple matter of modifying the capping value, to 6.

```lua
local variety = math.min(math.random(level), 6)
```

### Swapping Matches

This was anticipated as the trickiest part of the assignment. While the feature is rather challenging, the game is however equipped with a function which is bound to make things easier. Indeed the `calculateMatches()` function is made to return either a table of matches or `false`, if not match at all is found.

To allow for a swap only when a match is found, the return value can be used in the logic of the `Board` class, and specifically in its `update(dt)` function. Here's the idea:

- swap the tiles in the board;

  ```lua
  -- swap the tiles in the board
  self.tiles[tile1.gridY][tile1.gridX] = tile2
  self.tiles[tile2.gridY][tile2.gridX] = tempTile
  ```

- immediately check if the board has matches, through the `calculateMatches` function;

  ```lua
  if not self:calculateMatches() then
  end
  ```

- if the function returns `false`, swap the tiles back. This change occurs in the table of tiles only, and visually it looks as if nothing has happened. As the swap never occured.

  ```lua
  if not self:calculateMatches() then
    tempTile = self.tiles[tile1.gridY][tile1.gridX]
    self.tiles[tile1.gridY][tile1.gridX] = self.tiles[tile2.gridY][tile2.gridX]
    self.tiles[tile2.gridY][tile2.gridX] = tempTile
  else
    -- match
  end
  ```

- if the function returns something different than `false` (and it does return a table of matches if such matches are found), proceed to visually swap the tiles. Retain the swapped structure in the board.

  ```lua
  if not self:calculateMatches() then
    -- no match
  else
    -- match, proceed to visually update the UI
    -- swap the tiles on the screen moving to the coordinate each tile needs to retain after the swap
    Timer.tween(0.1, {
      -- using the temporary values for the tile being modified
      [tile2] = {x = tile1.x, y = tile1.y},
      [tile1] = {x = tempX, y = tempY}
    })
    -- immediately updat gridX and gridY, as the two don't reflect on the UI
    tile2.gridX = tile1.gridX
    tile2.gridY = tile1.gridY
    tile1.gridX = tempgridX
    tile1.gridY = tempgridY
  end
  ```

Small update: when the swap is implemented, and only then, the selected tile is modified, to refer to the destination tile.

```lua
if not self:calculateMatches() then
  -- no match
else
  -- match, proceed to visually update the UI
  -- swap the tiles on the screen moving to the coordinate each tile needs to retain after the swap
  Timer.tween(0.1, {
    -- using the temporary values for the tile being modified
    [tile2] = {x = tile1.x, y = tile1.y},
    [tile1] = {x = tempX, y = tempY}
  })
  -- immediately updat gridX and gridY, as the two don't reflect on the UI
  tile2.gridX = tile1.gridX
  tile2.gridY = tile1.gridY
  tile1.gridX = tempgridX
  tile1.gridY = tempgridY

  -- change the selected tile to have the outline placed on the swapped, destination tile
  self.selectedTile = tile2
end
```

Having this line applied in both instances would result in a rather unintuitive visual when a match is not implemented and the selected tile changes.

### Drag and Swap

To implement the last part of the assignment for Match 3, it is necessary to register player input through the mouse cursor. With Flappy bird the cursor was already considered to have the critter jump upwards, as an alternative to the space bar. With match 3 the interaction is a tad more complex, but relies on the same data.

#### Mouse Pressed Refresher

In Flappy Bird the cursor was considered as follows:

- set up a table in which to keep track of the mouse's coordinates.

  ```lua
  function love.load()
    love.mouse.coor = {
      ['x'] = 0,
      ['y'] = 0
    }
  end
  ```

- with the native function `love.mousepressed(x, y)`, update the coordinates of the table. Notice how the coordinates are included through the `push:toGame()` function, available from the push library.

  ```lua
  function love.mousepressed(x, y)
    love.mouse.coor['x'], love.mouse.coor['y'] = push:toGame(x, y)
  end
  ```

  The function is equipped to handle and return two values for the horizontal and vertical coordinate of the cursor, respectively.

- in the `Bird` class, and given an overlap between the cursor and the bird, animate it to go upwards.

  ```lua
    -- check if the coordinates distilled in love.mouse.coor fall within the horizontal and vertical space occupied by the bird
    -- add a bit of leeway to make the press fall in a general area surrounding the bird
    if love.mouse.coor['x'] > self.x - 5 and love.mouse.coor['x'] < self.x + self.width + 5 then
      if love.mouse.coor['y'] > self.y - 5 and love.mouse.coor['y'] < self.y + self.height + 5 then
        -- play the matching audio
        sounds['jump']:play()
        self.dy = -7
      end
    end
  ```

This last point has very little to do with the drag feature, but completes the logic from tracking the cursor to using its coordinates. It also implements a collision test which needs to be reiterated for the tiles in the board.

#### Drag and Swap

With the explanation inclluded in the refresher, selecting a tile is a matter of keeping track of the cursor coordinates and checking an overlap between these values and the coordinates of the tile itself. However, the feature foreseen by the game is a tad more complex. Beside selecting a tile, it is indeed necessary to consider the mouse coordinates _continuously_. While the cursor is down on the screen, the coordinates of the cursor should be updated to eventually trace an overlap with _another_ tile and swap the two if they prove to be adjacent. Adjacent and resulting in a match, as per the assignment already completed, but that is a matter of gameplay which will come relevant later.

To complete this feat, a few more functions are needed. Props to [this insightful tutorial](http://ebens.me/post/mouse-dragging-in-love2d/) for providing a rather clear guidance.

- `mouse.getX()` and `mouse.getY()` allow to retrieve the mouse coordinates outside of a `love.mousepressed()` handler;

- `love.mousepressed()` allows to retrieve an additional value besided the coordinates of the mouse: the part of the mouse being clicked. Through the code `1` it is possible to identify the primary mouse button, as per [the docs](https://love2d.org/wiki/love.mousepressed).

With these new and revised functions I decided to create a separate project in which to study the drag and swap feature. Think of this as another _Prep_ folder, instrumental for the completion of the game.
