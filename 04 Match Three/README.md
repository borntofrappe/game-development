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

- [ ] _Create random shiny versions of blocks that will destroy an entire row on match, granting points for each block in the row_

- [ ] _Only allow swapping when it results in a match_

  - [ ] _If there are no matches available to perform, reset the board_

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
