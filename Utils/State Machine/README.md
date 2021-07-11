# State Machine

The concept of a state machine is introduced in the context of the game <i>Flappy Bird</i>, and is one of the key elements used extensively in the course. The idea is to delegate the logic of the project into different `.lua` files, each responsible for its own set of variables and functions.

## State

The logic in the `load`, `update`, `render` function is moved from `main.lua` to the different states. In `main.lua` then, you reference the states through the state machine.

## StateMachine

The state machine is initialized with a table describing the states.

```lua
StateMachine = {}

function StateMachine:new(states)
end
```

In the body of the `new` function, you then set three fields:

- `empty`, detailing the initial, unset state

- `states`, using the input value or an empty table if the class is called without one

- `current`, referencing the current state

```lua
local empty = {
  ["enter"] = function() end,
  ["exit"] = function() end,
  ["update"] = function() end,
  ["render"] = function() end,
}

local this = {
  ["empty"] = empty,
  ["states"] = states or {},
  ["current"] = empty
}
```

Notice `empty` in particular. The table includes empty functions for each of the four key. The keys describe the phases through which a state goes, so that the functions describes what the state needs to accomplish in the state's lifetime. For instance and in the `render` field, you could instruct the state to render the necessary assets.

Past the initialization function, the state machine includes a few more functions:

- `:change`

- `:update(dt)` and `render()`

### change

For each state, the idea is to go through different stages:

- initialize the necessary variables

- update the game and render the assets for the specific state

- clean up the variables before moving on to the next state

`:change` consider these stages when going from one state to another. Immediately, the function raises an error if the state machine does not include the input state. This is achieved with the `assert` function.

```lua
assert(self.states[stateName], "Invalid state name: " .. stateName)
```

Past the assertion, the function exits the current state by calling the `exit` function

```lua
self.current:exit()
```

The idea is to then modify `self.current` to describe the new state.

```lua
self.current = self.states[stateName]()
```

`self.states[stateName]` describes a function, which will make sense as the state machine is initialized. Here consider that `states` is a table of functions, each describing the different states.

Finally, the function introduces the new state with the `enter` function, passing the values received in the second argument.

```lua
self.current:enter(enterParams)
```

### update and render

While `self.current` includes the logic for the update and rendering phase, it is necessary to call the functions to actually update and render the game.

This is exactly what the `:update` and `:render` function achieve.

```lua
function StateMachine:update(dt)
  self.current:update(dt)
end

function StateMachine:render()
  self.current:render()
end
```

## States

The states are described by `*State.lua` files. Each of these files inherits from `BaseState.lua`, to make sure that the functions called from the state machine exist, even if not specified in the individual states.

```lua
BaseState = Class{}

function BaseState:new()
  -- oop
end

function BaseState:enter() end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end
```

It is up to the states to then override the functions with their own bespoke logic.

## Main

The project highlights the state machine with a trivial demo, but it is important to conside how `main.lua` sets up the state machine in the first place.

First, you import the necessary assets: the state machine, the base state and the individual states.

```lua
require 'StateMachine'

require 'states/BaseState'
require 'states/TitleScreenState'
require 'states/PlayState'
```

In `love.load`, you initialize the state machine with a table of functions.

```lua
gStateMachine =
  StateMachine:new(
  {
    ["start"] = function()
      return StartState:new()
    end,
    ["end"] = function()
      return EndState:new()
    end
  }
)
```

Notice how each key describes a function, which returns the matching state. This explains the previous snippet and why `StateMachine:change()` calls a function when setting a new state.

```lua
function StateMachine:change(stateName, enterParams)
  self.current = self.states[stateName]()
end
```

Always in `love.load`, you change the state to refer to the title screen.

```lua
gStateMachine:change('title')
```

Instead of then updating and rendering the different parts of the game in `love.update` and `love.draw`, you directly call `gStateMachine:update()` and `gStateMachine:enter()`

```lua
function love.update(dt)
    gStateMachine:update(dt)
end

function love.render()
    gStateMachine:render()
end
```
