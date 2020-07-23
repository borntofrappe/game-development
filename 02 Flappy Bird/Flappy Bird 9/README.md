Keep track of the score.

> assumes a _res_ folder with the necessary dependencies and assets

## Score

The score is initialized and considered in `PlayState`

```lua
function PlayState:init()
    -- previous code
    self.score = 0
end
```

Initialized with a value of `0`, it is incremented whenever the bird is to the left of a pair of pipes. To this end, it is necessary to modify `PipePair`. Just like you describe when to remove the pair with a boolean, `remove`, you detail when a point is scored with a boolean.

```lua
function PipePair:init(y)
    -- previous code
    self.scored = false
    self.remove = false
end
```

In `PlayState.lua` then, you can check for the coordinate and use the boolean so that the score is incremented only once.

```lua
function PlayState:update(dt)
    for k, pipePair in pairs(self.pipePairs) do
        --[[update pipes]]

        if not pipePair.scored and self.bird.x > pipePair.x + pipePair.width then
            pipePair.scored = true
            self.score = self.score + 1
        end
    end
end
```

To illustrate the score, it is helpful to print a string in the `render` function.

```lua
function PlayState:render()
    --[[render pipes and bird]]

    love.graphics.print('Pipes: ' .. self.score, 10, 10)
end
```

## ScoreState

The game introduces an additional state to show the score, instead of immediately moving to the title screen.

```text
                press enter
                ----→
TitleScreenState     PlayState
                      |   ↑
                lose  |   | press enter
                      ↓   |
                    ScoreState
```

This helps to illustrate the `enter` function. It is necessary to pass the score from state to state. This is specified through the second argument of the `:change` function.

```lua
-- stateName, enterParams
gStateMachine:change('score', {
    score = self.score
})
```

In the following state then, access the score from `enterParams` and the mentioned `enter` function.

```lua
function ScoreState:enter(params)
    self.score = params.score
end
```

This covers much of the `ScoreState`. The rest relates to displaying the score, informing how to play again and reacting to a press on the enter key, to move back to `PlayState`.

## main.lua

Every time you include a state, be sure to:

- require the state at the top of the script

  ```lua
  require 'states/ScoreState'
  ```

- add the state to the state machine

  ```lua
  gStateMachine = StateMachine({
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    })
  ```
