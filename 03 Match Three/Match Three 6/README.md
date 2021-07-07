# Match Three 6

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Match Three — Final`.

## Title screen

In the title screen, the string <i>Match 3</i> is boldly included above a basic menu with two options: start and quit game. Selecting the first option moves the game to the play state, while selecting the second option closes the window altogether.

On top of these visuals, the title screen showcases a static version of the board. This is included in the background, and darkened through a semi-transparent black overlay. The idea is to have the menu pop in contrast to the darker visual.

## Board

To showcase a static version of the board, it is necessary to change the `Board` class. This is to avoid showing a selected tile, and also prevent the board from immediately updating. To this end, the class is initialized with a boolean, `isPlaying`. Only when this boolean is true, in the play state, the board can be updated.

```lua
function Board:init(isPlaying)
  if isPlaying then
    self.selectedTile = {
      x = math.random(self.columns),
      y = math.random(self.rows)
    }
    self:updateBoard()
  end
end
```

With this in mind, the static version is initialized in `TitleScreenState:init()` and rendered in `TitleScreenState:render()`.

```lua
function TitleScreenState:init()
  self.board = Board(false)
end

function TitleScreenState:render()
  self.board:render()
end
```

As the board is meant to be static, there's no need to call the matching `update(dt)` function.

## Translation

Instead of moving the board from the stateful scripts, I've decided to specify two additional arguments in the `init` function: `centerX` and `centerY`.

```lua
function Board:init(isPlaying, centerX, centerY)
end
```

These describe where the board should be centered. To reset the translation lean on the `love.graphics.push` and `love.graphics.pop` functions.

```lua
function Board:render()
  love.graphics.push()
  love.graphics.translate(self.centerX - COLUMNS * TILE_WIDTH / 2, self.centerY - ROWS * TILE_HEIGHT / 2)

  -- render

  love.graphics.pop()
end
```
