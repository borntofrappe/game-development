# State stack

Unlike a state machine, a state stack allows to move from state to state _without_ creating new instances. Consider how in previous games the `gStateMachine:change()` function essentially destroyed a state before moving on to the new one.

## Notes

With a state stack it is possible to render multiple states, which makes it possible to render panels and textbox above the scenery.

### Stack

Taking inspiration from the data structure of a stack, a state stack has several layers of states.

```text
 ---------
|dialogue |
 ---------
 ---------
|playstate|
 ---------
```

You _push_ (add) and _pop_ (remove) a state on the stack as needed, for instance to show or dismiss the dialogue following a specific event. You update the topmost state.

### Initialize

Dissecting the code, the `StateStack` class is initialized with a table of states.

```lua
function StateStack:init(states)
  self.states = states or {}
end
```

The empty table `{}` is used as a precaution, in the moment the stack is initialized without arguments.

### Update

In the `update` function, the class updates the topmost state.

```lua
function StateStack:update(dt)
  self.states[#self.states]:update(dt)
end
```

### Render

In the `render` logic then, the class renders _every_ state in the stack. This is fundamentally different from a state machine, devoted to update _and_ render only the current state.

```lua
function StateStack:render()
  for i, state in ipairs(self.states) do
    state:render()
  end
end
```

Notice how the code uses `ipairs`, to guarantee the order described in the stack.

### Push and pop

To add and remove states from the stack, the class defines two additional functions:

1. `:push(state)` adds the input state as the last element of the stack

2. `:pop()` removes the last element from the states' table

Beyond adding or removing a state, the functions are also responsible to call the functions describing the lifecycle of individual states. Consider how the individual states go through a series of phases:

- init

- enter

- update

- exit

In light of this structure, the push operation needs to introduce the new state through its `enter` method.

```lua
function StateStack:push(state)
  table.insert(self.states, state)
  state:enter()
end
```

The pop operation needs to then exit the state through the `exit` function. Notice that the function is called before the state is actually removed.

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

## Demo

`main.lua` highlights the state stack with two layered states: play and dialogue. The idea is to show how the two coexist in terms of visual, and also how the stack updates the state at the top of the stack.

`main.lua` sets up the instance of the `StateStack` class.

```lua
gStateStack =
  StateStack(
  {
    PlayState(),
  }
)
```

It is here equivalent to initialize the stack without passing any arguments, and then push the state afterwards.

```lua
gStateStack = StateStack()
gStateStack:push(PlayState())
```

In the update and draw functions then, the stack calls the matching functions.

```lua
function love.update(dt)
  gStateStack:update(dt)
end

function love.draw()
  gStateStack:render()
end
```

The individual states show the layered structure by moving the player in the play state and highlight a message in the dialogue state. Notice that the player is allowed to move only in the play state.
