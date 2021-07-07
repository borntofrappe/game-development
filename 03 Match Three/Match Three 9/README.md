# Match Three 9

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Match Three — Final`.

## Gameover

The idea is to move to a screen showcasing the score when the timer hits 0. In terms of structure, the gameover state is rather straightforward:

- receive the score from the play state

- show the score between a string detailing the gameover, and one detailing how to continue by pressing enter

- in the `update` function consider a key press on the enter key, to move to the title screen

## Gameplay

The gameover is rather straightforward, but the update introduces major changes to finally allow the game to:

1. count down the number of seconds

2. increase the score following a match

### Timer

Using the `Timer` object, counting down the number of seconds is a matter of setting up a `Timer.every` function.

```lua
Timer.every(
  1,
  function()
    self.timer = self.timer - 1
  end
)
```

### Clear

When you exit the play state, be it because the player moves to the title screen by pressing escape, or because the timer runs out, it is essential to clear the timer object.

```lua
function PlayState:update(dt)
  if love.keyboard.waspressed("escape") then
    Timer.clear()
    gStateMachine:change("title")
  end


  if self.timer > then
    Timer.update(dt)
  else
    Timer.clear()
    gStateMachine:change(
      "gameover",
      {
        score = self.score
      }
    )
  end
end
```

Without this extra step, even if you set a new timer, the old one would persist.

### Score

To increase the score _when_ the board registers a match, it's necessary to move the logic from the `Board` class to `PlayState`. This means the call to `board:update()` is removed and the connected logic is moved within `PlayState:update()`. This requires a few adjustments, since `self` refers to the play state instead of the initialized board.
