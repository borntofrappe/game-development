Introduce the concept of a statestack.

## Theory

Unlike a state machine, the concept of a statestack allows to move from state to state without creating new instances. Consider how in previous games the `gStateMachine:change()` function essentially destroyed the current state before moving on to the new one.

With a state stack it is possible to render multiple states, which makes it possible to render panels and textbox above the scenery.

### Stack

Taking inspiration from the data structure, a state stack has several layers of states.

```text
 ---------
|dialogue |
 ---------
 ---------
|playstate|
 ---------
```

You _push_ (add) and _pop_ (remove) a state on the stack as needed, for instance to show or dismiss the dialogue following a specific event. You update the topmost state.

### Init, update, render

Dissecting the code, the `StateStack` class is initialized with a table of states.

```lua
function StateStack:init(states)
  self.states = states or {}
end
```

The empty table `{}` is used as a precaution, in the moment the stack is initialized without arguments.

In the `update` function, the class updates the topmost state, as mentioned above.

```lua
function StateStack:update(dt)
  self.states[#self.states]:update(dt)
end
```

In the `render` logic then, it renders _every_ state in the stack. This is exactly what differentiates the concept from the state machine.

```lua
function StateStack:render()
  for i, state in ipairs(self.states) do
    state:render()
  end
end
```

Notice how the code uses `ipairs`, to guarantee the order described in the stack.

### Push, pop

To add and remove states from the stack, the class defines two additional functions:

1. `:push(state)` adds the input state as the last element of the states' table

2. `:pop()` removes the last element from the states' table

In addition to the addition/removal of a state, the functions are also responsible to call the necessary functions describing the lifecycle of individual states. Consider how the individual states go through a series of phases:

- init

- enter

- update

- exit

In light of this structure, the push operation needs to introduce the new state.

```lua
function StateStack:push(state)
  table.insert(self.states, state)
  state:enter()
end
```

The pop operation needs to then exit the state. This before the state is actually removed.

```lua
function StateStack:pop()
  self.states[#self.states]:exit()
  table.remove(self.states)
end
```

### Clear

The lecturer introduces an additional method to clear the stack of any state.

```lua
function StateStack:clear()
  self.states = {}
end
```

This might be useful in the moment the game is initialized anew.

## Practice

In the demo, the code shows the concept of a stack experimenting with two layered states: play and dialogue. The idea is to show how the two coexist in terms of visual, and also how the stack updates the state at the top of the stack.

### main.lua

`main.lua` sets up the instance of the `StateStack` class.

- initialize the state stack in `love.load()`

  ```lua
  gStateStack =
    StateStack(
    {
      PlayState(),
      DialogueState()
    }
  )
  ```

  It is here equivalent to initialize the stack without passing any arguments, and then pushing the individual states afterwards.

  ```lua
  gStateStack = StateStack()
  gStateStack:push(PlayState())
  gStateStack:push(DialogueState())
  ```

- update and render the stack in `love.update` and `love.draw` respectively.

  ```lua
  function love.update(dt)
    gStateStack:update(dt)
  end

  function love.draw()
    gStateStack:render()
  end
  ```

### Individual states

In the individual states, the push and pop operations are conditioned to a particular key press, in order to dismiss/show the dialogue state.

- in the play state, push the dialogue counterpart when pressing `enter`.

  ```lua
  function PlayState:update(dt)
    if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
      gStateStack:push(DialogueState())
    end
  end
  ```

- in the dialogue state, remove the topmost state (itself), when pressing the same key.

  ```lua
  function DialogueState:update(dt)
    if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") or love.keyboard.wasPressed("escape") then
      gStateStack:pop()
    end
  end
  ```
