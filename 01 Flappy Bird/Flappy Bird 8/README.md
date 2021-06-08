# Flappy Bird 8

_Please note:_ `main.lua` depends on a few assets in the `res` folder:

- `push.lua` and `class.lua` in `res/lib`

- a series of images in `res/graphics`

- `font.ttf` in `res/fonts`

## State

The course introduces the concept of a state machine, in order to manage the transition between states in a more expressive fashion. The idea is to literally delegate the logic of the game to different states:

- the title screen state

- the playing state

The logic in the `init`, `update`, `render` function is moved from `main.lua` in each dedicated state. In `main.lua` then, you reference the different states through the state machine.

## StateMachine.lua

The state machine is initialized as a class, receiving the states as input.

```lua
StateMachine = Class{}

function StateMachine:init(states)
end
```

In the body of the `init` function, you then set three fields:

- `empty`, detailing the initial, unset state

- `states`, using the input value or an empty table if the class is called without one

- `current`, referencing the current state

```lua
StateMachine = Class{}

function StateMachine:init(states)
    self.empty = {
        render = function() end,
        update = function() end,
        enter = function() end,
        exit = function() end
    }

    self.states = states or {}
    self.current = self.empty
end
```

Notice `self.empty` in particular. The table describes four keys with a value of empty functions. These four keys describe the phases through which a state goes. Within these keys you detail what a state needs to accomplish. For instance and in the `render` field, you include the function(s) to render the necessary assets.

Past this initialization function, the state machine includes a few more functions:

- `:change`

- `:update(dt)` and `render()`

### change

For each state, the idea is to go through different stages:

- initialize the necessary variables

- update the game and render the assets for the specific state

- clean up the variables before moving on to the next state

`:change` is responsible for this shift.

The course introduces an assertion to raise an error if the state machine does not include the input state.

```lua
function StateMachine:change(stateName, enterParams)
    assert(self.states[stateName], 'Invalid state: ' .. stateName)
end
```

Refer to [the docs for errors in lua](https://www.lua.org/pil/8.3.html) for more information.

Past this assertion, the function exits the current state by calling the `exit` function

```lua
function StateMachine:change(stateName, enterParams)
    -- assertion

    self.current:exit()
end
```

It then proceeds to modify `current`, so to describe the new state.

```lua
function StateMachine:change(stateName, enterParams)
    -- assertion

    self.current:exit()
    self.current = self.states[stateName]()
end
```

The fact that `self.current` holds the value returned by a function will be made clear once you do initialize the state machine in `main.lua`. In this moment, consider that `states` is a table of functions, each describing the different states.

Finally, the function starts the new state with the `enter` function, passing the values received in the second argument.

```lua
function StateMachine:change(stateName, enterParams)
    -- assertion

    self.current:exit()
    self.current = self.states[stateName]()
    self.current:enter(enterParams)
end
```

### update and render

While `self.current` includes the logic for the update and rendering phase, it is necessary to call the functions to actually update/render the game.

This is exactly what the `:update` and `:render` function do.

```lua
function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end
```

## states

Each different state has its own `*State.lua` file. In this file, you describe the logic of the state through its enter/exit/update/render functions.

With this regard, the course introduces the concept of _class inheritance_. You create `BaseState.lua`, as a class with the four functions.

```lua
BaseState = Class{}

function BaseState:init() end
function BaseState:enter() end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end
```

You then create the different states inheriting this class. For instance and for the state describing the title screen, `TitleScreenState`:

```lua
TitleScreenState = Class{__includes = BaseState}
```

In this manner you can describe the functions necessary for each state, without worrying about declaring every function. If `TitleScreenState` does not specify an `enter` function, the game won't raise an error as it will refer to the one from `BaseState.lua`.

## main.lua

Before describing the different states, it makes sense to conside how the state machine works from the perspective of `main.lua`.

First, you import the necessary assets, among which, the state machine and the different states.

```lua
-- require the state machine class
require 'StateMachine'

require 'states/BaseState'
require 'states/TitleScreenState'
require 'states/PlayState'
```

In `love.load` then, you initialize the state machine.

```lua
function love.load()
    gStateMachine = StateMachine({
        title = function() return TitleScreenState() end,
        play = function() return PlayState() end
    })
end
```

See how each key describes a function, which returns the matching state. This explains why `StateMachine:change()` calls a function when setting a new state.

```lua
function StateMachine:change(stateName, enterParams)
    -- assertion

    -- exit

    self.current = self.states[stateName]()

    -- enter
end
```

Always in `love.load`, you change the state to refer to the title screen.

```lua
function love.load()
    -- gStateMachine

    gStateMachine:change('title')
end
```

Instead of then updating and rendering the different parts of the game in `love.update` and `love.render`, you directly call `gStateMachine:update()` and `gStateMachine:enter()`

```lua
function love.update(dt)
    gStateMachine:update(dt)
end

function love.render()
    gStateMachine:render()
end
```

Reacting to key presses, managing the bird, pipes, collision is literally moved from `main.lua` to each dedicated state, which makes for a much more expressive, clean approach.

### keys

This is but a minor change: when initializing the state, you can specify keys directly

```lua
table = {
    title = function() end,
    play = function() end
}
```

Alternatively, you can use square brackets to include the string.

```lua
table = {
    ['title'] = function() end,
    ['play'] = function() end
}
```

It makes no different for the current situation, but it is helpful once/if you specify complex strings, or strings which include special characters, like spaces.

## states/2

The game will increase in complexity with future updates, but to test out the state machine, the idea is to go through two states with the following logic

- start with a title screen

- move to playing the game by pressing enter

- move back to the title screen when a collision is detected

```text
                press enter
                ----→
TitleScreenState     PlayState
                ←----
                lose
```

### TitleScreenState

Here the state renders the title of the game, as well as an instruction detailing how to play the game.

```lua
function TitleScreenState:render()
    love.graphics.setFont(font_big)
    love.graphics.printf(
        'Flappy Bird',
        0,
        VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH,
        'center'
    )

    love.graphics.setFont(font_normal)
    love.graphics.printf(
        'Press enter to play',
        0,
        VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH,
        'center'
    )
end
```

In the `update()` function of the state then, you move to the `play` state if you detect a key press on the chosen key.

```lua
function TitleScreenState:update(dt)
    if love.keyboard.waspressed('enter') or love.keyboard.waspressed('return') then
        gStateMachine:change('play')
    end
end
```

The state is rather simple, but helps to explain the usefulness of the state machine. Instead of updating/rendering with a conditional

```lua
function love.update(dt)
    if gameState == 'title' then

    elseif gameState == 'play' then

    end

end

function love.render()
    if gameState == 'title' then

    elseif gameState == 'play' then

    end

end
```

You delegate the operations to dedicated files.

### PlayState

In this state you replicate much of the logic previously included in `main.lua`.

- initialize the necessary variables

  ```lua
  function PlayState:init()
      self.bird = Bird()
      self.pipePairs = {}
      self.timer = 0
      self.interval = 4

      self.y = math.random(VIRTUAL_HEIGHT / 7, VIRTUAL_HEIGHT / 7 * 6)
  end
  ```

- update the game in the body of the `update` function

  ```lua
  function PlayState:update(dt)
      --[[add pipes at an interval]]

      -- bird
      self.bird:update(dt)
      -- pipes
      for k, pipePair in pairs(self.pipePairs) do
          pipePair:update(dt)

          --[[bird collides with pipes]]
          --[[remove pipes]]
      end

      --[[bird exceeds lower edge]]
  end
  ```

- render the assets in the body of the `:render` function

  ```lua
  function PlayState:render()
      for k, pipePair in pairs(self.pipePairs) do
          pipePair:render()
      end

      self.bird:render()
  end
  ```

Once you detect a collision however, move to the `title` state. Again to illustrate how the state machine works. For instance and for when the bird exceeds the lower edge of the game window.

```lua
if self.bird.y > VIRTUAL_HEIGHT - 16 then
    gStateMachine:change('title')
end
```
