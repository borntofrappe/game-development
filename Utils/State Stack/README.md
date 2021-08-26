# State Stack

The concept of a state stack is introduced in the context of the game <i>Pokemon</i>, as an approach to manage state different from the one allowed by a state machine. The difference boils down to how the states are managed:

- in a state machine there exist only one state at a time. The machine is responsible for updating the state's logic and rendering the necessary visuals

- in a state stack it is possible to maintain multiple states. You push and pop states to the stack, which renders the visual of every state, but updates the logic of only the topmost level

With this folder I replicate the example highlighted in `07 Pokemon/State Stack`, without relying on a class library. The notes are adapted to this change.

## Notes

A state stack has several layers of states.

```text
 ---------
|dialogue |
 ---------
 ---------
|playstate|
 ---------
```

You _push_ (add) and _pop_ (remove) a state on the stack as needed, for instance to show or dismiss the dialogue following a specific event.

### Initialize

Tthe `StateStack` class is initialized with a table of states.

```lua
function StateStack:new(states)
  local states = states or {}
end
```

The empty table `{}` is used as a precaution, in the moment the stack is initialized without arguments.

### Update

In the `update` function, the stack updates the topmost state.

```lua
function StateStack:update(dt)
  self.states[#self.states]:update(dt)
end
```

### Render

In the `render` logic then, the stack renders every single state.

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

An additional method clears the stack of any state.

```lua
function StateStack:clear()
  self.states = {}
end
```

The function might be useful in the moment the game is initialized anew.

## Object-oriented Programming

_Please note:_ this section might change as I improve the way I manage object-oriented programming, and specifically inheritance, with Lua.

The individual states inherit from a base state, so that it is possible to later define only the necessary functions.

```lua
PlayState = BaseState:init()
```

I've decided to use `init` for the base state so that it is later possible to expand the states with a different initialization function: `:new`.

```lua
function PlayState:new()
  -- initialize play state
end
```

This allows the states to have the methods of the base state, and then implement their own, bespoke logic.

The solution works, at the price of setting the meta table in both initializations. In the base state and the inidividual state.

```lua
self.__index = self
setmetatable(this, self)
```

## Demo

`main.lua` highlights a state stack with two layered states: play and dialogue. The idea is to show how the two coexist in terms of visual, and also how the stack updates the state at the top of the stack.

`main.lua` sets up the instance of the `StateStack` class.

```lua
gStateStack =
  StateStack:new(
  {
    PlayState:new()
  }
)
```

It is here equivalent to initialize the stack without passing any arguments, and then push the state afterwards.

```lua
gStateStack = StateStack:new()
gStateStack:push(PlayState:new())
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
