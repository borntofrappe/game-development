Create play and dialogue state. Update the stack to move between the individual states.

## constants

Each tile is a 16x16 square. In order to have a width and height which are both divisble by this measure, I decided to update the variables making up the screen.

```lua
VIRTUAL_WIDTH = 400
VIRTUAL_HEIGHT = 224
```

This means the window has effectively 25 rows and 14 columns. To avoid black bars on the sides of the window, the non-virtual variables are also updated. This to keep the same ratio (scaling up with a factor of 3).

```lua
WINDOW_WIDTH = 1200
WINDOW_HEIGHT = 672
```

## PlayState

The play state builds a table with a series of tiles. These are identified by row, column and an ID. The row and column are used to position the tile.

```lua
love.graphics.draw(
  -- texture and frame
  (self.column - 1) * TILE_SIZE,
  (self.row - 1) * TILE_SIZE
)
```

The ID, on the other hand, is hand-picked to describe the background or grass variant.

```lua
TILE_BACKGROUND = 46
TILE_GRASS = 42
```

`Utils.lua` builds a table of quads matching the numbers highlighted in `sheet_numbered`.

```lua
love.graphics.draw(
  gTextures["sheet"],
  gFrames["sheet"][self.id],
  -- x and y
)
```

_Please note_: the logic behind the tile is moved to a `Tile` class.

## Dialogue

The dialogue state is used to display a short message above a solid overlay.

## Stack

### StartState

The game moves to the play state by pressing enter. In terms of the stack, the script removes the start state before pushing both the play and dialog counterparts.

```lua
if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
  gStateStack:pop()
  gStateStack:push(PlayState())
  gStateStack:push(DialogueState())
end
```

This allows to show the tiles of the play state, the ovrlay of dialogue. Only the update logic of the dialogue is however considered.

**Important**: remember to remove the animation set up with the `Timer` object. This is achieved by assigning a label to the interval.

```lua
self.tween = Timer.every()
```

The interval is then removed using the `:remove` function.

```lua
self.tween:remove()
```

This is useful since the timer logic is no longer useful. Moreover, once the game returns to the start state, it is essential to avoid duplicating the timer logic.

### DialogueState

The state dismisses the dialogue by pressing enter, or again the escape key.

```lua
if love.keyboard.wasPressed("escape") or love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
  gStateStack:pop()
end
```

### PlayState

The state moves to the start state by pressing enter.

```lua
if love.keyboard.wasPressed("escape") then
  gStateStack:pop()
  gStateStack:push(StartState())
end
```

Out of convenience, it also shows the dialogue once more, and by pressing the `d` key.

```lua
if love.keyboard.wasPressed("d") or love.keyboard.wasPressed("D") then
  gStateStack:push(DialogueState())
end
```
