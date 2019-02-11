# Flappy Bird 10 - Countdown

To show once more how to work through the state machine class, and also to highlight how reasonable it becomes to develop separate features of the game, update 10 introduces a new state in `CountdownState`. This refers to a screen shown before the `PlayState` is actually introduced, so after the `TitleScreenState` and every time a new game is played following the `ScoreState`. Refer to the previous diagram to see where it fits

```text
title ---- → countdown --- → play
                ↑             ↓
                 -------- score
```

## main.lua

Just like for the score state, to implement a new state class you need to:

- require the class;

```lua
require 'states/CountdownState'
```

- include the possible state in the state machine instance;

```lua
gStateMachine = StateMachine {
  ['title'] = function() return TitleScreenState() end,
  ['play'] = function() return PlayState() end,
  ['score'] = function() return ScoreState() end,
  ['countdown'] = function() return CountdownState() end -- new state class
}
```

## CountdownState.lua

This file is where the logic of the countdown is included, and is responsible for the rendering of the actual countdown (3, 2, 1). It will display the decreasing integers and then proceed automatically to the play state.

In the specific instance of the project, the lecturer introduces `COUNTDOWN_TIME` as a constant variable used to update the countdown every so often. Instead of using a second, the project uses 0.75s to make the countdown feel snappier.

Once set up, the logic of the countdown is as follows:

- keep track of delta time;

- once the sum of delta time values goes past the `COUNTDOWN_TIME` value, progressively show the countdown numbers until you hit 0;

- call the state machine instance and move the game toward the playing state.

Diving into the code, `CountdownState` is initiated with two values, in `count` and `timer`. The former to describe the number from which to count (down) and the latter to keep track of the time passing by.

In the `update(dt)` function, these variables are used as follows:

- increase `timer` by the value of delta time;

  ```lua
  self.timer = self.timer + dt
  ```

- check when the timer goes past the constant value;

```lua
if self.timer > COUNTDOWN_TIME then

end
```

- decrease the `count` value and reset timer to 0;

  ```lua
  if self.timer > COUNTDOWN_TIME then
    self.timer = 0
    self.count = self.count - 1
  end
  ```

  The lecturer actually uses the modulo operator, which might be actually better (setting it straight back to 0 might ignore a few fractions of a second, which are instead considered through the remainder operator).

  ```lua
  self.timer = self.timer % COUNTDOWN_TIME
  ```

- check if `count` has reached 0, and if so prop the play state;

  ```lua
  if self.count = 0 then
    gStateMachine:change('play')
  end
  ```

  Inclued this condition right inside the previous conditional statement, to call the play state immediately as `count` reaches 0.

Once implemented, the logic needs to be displayed, and this is where the `render` function comes into play.

Inclued a string showing the countdown through the `print` or `printf` function.

## TitleScreenState and ScoreState

Update both files as to prop not the play state, but the countdown state just created. Thus concluding the flow described above.

```lua
function TitleScreenState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('countdown') -- updated from 'play'
  end
end
```

```lua
function ScoreState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('countdown')
  end
end
```
