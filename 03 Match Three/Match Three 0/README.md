# Match Three 0

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Match Three — Final`.

## main

Following the example of _Breakout_, the entry point for the game sets up global variables and the state machine. In this update, I am only interested in showing the playable board in the play state, so the state machine includes a single instance of the play state.

```lua
gStateMachine =
  StateMachine(
  {
    ["play"] = function()
      return PlayState()
    end
  }
)

gStateMachine:change("play")
```

The script also adds a table to the `love.keyboard` module, to keep track of the key being pressed. This technique was introduced in a previous project and allows to know which key was pressed outside of the `love.keypressed` function.

## Board and Tile

Instead of creating the board and tiles through global functions, I create two classes to manage the structure of the board, and the graphic of the tile.

`Board` creates the grid of tiles, and manages the selection, highlight, and swap. I considered moving the logic into the play state, but decided to use `Board:update()` instead.

```lua
function Board:update(dt)
  if love.keyboard.waspressed('right') then
    -- move the selected tile to the right
  end

  --
end
```

`Tile` renders the desired sprite at the provided coordinates.

```lua
function Tile:render()
  love.graphics.draw(
    gTextures["match3"],
    gFrames["tiles"][self.color][self.variety],
    (self.x - 1) * TILE_WIDTH,
    (self.y - 1) * TILE_HEIGHT
  )
end
```

`color` and `variety` are initialized at random and in the `:init()` function, while `x` and `y` are received from the board class.
