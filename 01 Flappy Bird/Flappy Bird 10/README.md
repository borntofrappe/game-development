Play after a countdown.

> assumes a _res_ folder with the necessary dependencies and assets

## States

The game introduces yet another state, this time before the game moves to the `PlayState`.

```text
                enter key       3, 2, 1
TitleScreenState -→ CountdownState -→  PlayState
                                ↑       |
                      enter key |       | lose
                                |       ↓
                                ScoreState
```

As with the score state, it is first necessary to require and include the new state in the state machine.

```lua
require 'states/CountdownState'

function love.load()
  gStateMachine = StateMachine({
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    })
end
```

## Countdown

For the countdown, the script repeats much of the logic including the pipes at an interval. This time however, the script moves to the play state when the countdown hits `0`.

```lua
function CountdownState:init()
    self.timer = 0
    self.threshold = 0.5
    self.countdown = 3
end

function CountdownState:update(dt)
    self.timer = self.timer + dt
    if self.timer > self.threshold then
        self.countdown = self.countdown - 1
        self.timer = self.timer % self.threshold

        if self.countdown == 0 then
            gStateMachine:change('play')
        end
    end
end
```

`threshold` is initialized to `0.5` to have the countdown proceed at twice the speed (half a second).

In the `render` function then, display the counter with an arbitrary font.
