# Match Three 8

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Match Three — Final`.

## Tween

The animation works by rendering above every other elements a rectangle with a given color.

```lua
function TitleScreenState:init()
  self.fadeout = {
    ["r"] = 1,
    ["g"] = 1,
    ["b"] = 1,
    ["a"] = 0
  }
end

function TitleScreenState:render()
  love.graphics.setColor(self.fadeout["r"], self.fadeout["g"], self.fadeout["b"], self.fadeout["a"])
  love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end
```

From this starting point, the idea is to then animate the alpha component to completely hide the state.

```lua
Timer.tween(
  1,
  {
    [self.fadeout] = {a = 1}
  }
)
```

This is fundamentally how the animation works. Just remember to update the timer in the `update()` function.

```lua
function TitleScreenState:update()
  Timer.update(dt)
end
```

### finish

In the title screen state, the idea is to move to the play state only after the animation is complete.

```lua
Timer.tween():finish(
  function()
    gStateMachine:change("play")
  end
)
```

In the play state, instead, `finish` is used to update the board.

### isTweening

The idea is to prevent the functions and logic of the `update()`
function as long as the animation is ongoing.

```lua
function TitleScreenState:init()
  -- previous fields

  self.isTweening = false
end

function TitleScreenState:update(dt)
  if not self.isTweening then
    -- consider key presses
  end
end
```

Just remember to update the timer outside of the conditional.

```lua
function TitleScreenState:update(dt)
  if not self.isTweening then
    -- consider key presses
  end

  Timer.update(dt)
end
```

### fadein

For the play state, the animation is the same: include a table with a color value, apply the color to a rectangle stretching the width and height of the window, animate its opacity. The difference is that the given rectangle starts out fully opaque, only to then become fully transparent.

## Board

Given the transition to the play state, I've decided to modify the `Board` class to avoid using the argument `isPlaying`. Here I update the board directly from the play state, and only when the fade-in animation is complete.

```lua
Timer.tween():finish(
  function()
    self.isTweening = false
    self.board.selectedTile = {
      x = math. random(COLUMNS),
      y = math.random(ROWS)
    }

    self.board:updateBoard()
  end
)
```

Instead of using `self.rows` and `self.columns`, I've also updated the `Board` class to use the constants direclty: `ROW` and `COLUMNS`.

## Update

I revisited the update to:

- remove a bug

- add a transition to show the current level

- render the graphics connected to the animation conditional to `self.isTweening` being true. There's no purpose in having love2d drawing transparent rectangles, or drawing elements below the bottom edge of the window

- render static information regarding the level, in a panel to the left of the board
