# Flappy Bird 8 - State

With Pong, state was managed through a single variable, made to hold one of possible few values. Here, we implement state through a specific class, `StateMachine`, which itself is responsible for the transition between the possible states held by the game. This is immensely more practical as the application scales up, with more and more possible states, but does require a bit of upfront work, especially in understanding how the approach works. It is worth it though. Once implemented, adding a title screen, or a screen showing the the score separate from the game becomes a matter of adding a few lines, and you can just focus on developing the separate features.

For the application, the different states can be summed up as follows:

```text
title ---- → countdown --- → play
                ↑             ↓
                 -------- score
```

On the first play-through, the game from title to countdown to play. When losing, the game ends up in score and from there, the player can resume from the countdown screen. That is the ultimate goal for the application, but starting out easy, we can highlight how the state machine class works for the title and play state.

## main.lua

- require a class which manages the state of the application;

```lua
require 'StateMachine'
```

- require one class for each separate state, like `BaseState`, `PlayState`, `TitileScreenState`. The idea is to use the state machine to maneuver these different states of the game. Each has its own logic, its update and render logic (more on this later).

<!-- as an aside, and in the `load()` function instantiate fonts at different sizes. The lecturer introduces four different variations, changing in size and scope. Small, medium, big, title -->

- again in the `load()` function, and when using the state machine, store a reference to the state machine class in a variable which gets prefaced with a lower case `g`. This by convention signals the presence of a global variable.

```lua
gStateMachine = StateMachine {}
```

The state machine is here described through a table, in which each field represents a function firing the specific state:

```lua
gStateMachine = StateMachine {
  ['title'] = function() return TitleScreenState() end,
  ['play'] = function() return PlayState() end
}
```

The different functions are then passed to a method available on the `StateMachine` class, in `:change()`. Something akin to `gStateMachine:change('title')`.

As it stands `StateMachine` is therefore instantiated with a table and includes also a function, which is responsible for the switch to the specific state.

- in the `update(dt)` function, include the scroll of the background and of the ground only. The rest of the game is updated through the state machine, and specifically the `StateMachine:update(dt)` function.

```lua
function love.update(dt)
  -- background and ground scroll

  -- update the state included through the state machine
  gStateMachine:update(dt)

  -- reset the table of the keys being pressed
  love.keyboard.keysPressed = {}
end
```

The idea seems to keep in the update function of `main.lua` only those features which are meant to be global, applied on the application as a whole (like the scroll of the background and the ground). Delegate the rest to the state machine class.

- in the `render()` function, render the background and ground only, and delegate the rest to the `gStateMachine:render()` function.

```lua
gStateMachine:render()
```

## StateMachine.lua

This is all rather new, so I'll heavily comment what the lecturer introduces. `StateMachine` is a class which is initiated with a list of states.

```lua
function StateMachine:init(states)
end
```

A class with a table of empty functions:

```lua
function StateMachine:init(states)
  self.empty = {
    render = function() end,
    update = function() end,
    enter = function() end,
    exit = function() end
  }
end
```

And two additional fields. `self.states` which refers to the states passed through the `:init` function or an empty table (I assume this is in case nothing is passed as `states`):

```lua
self.states = states or {}
```

Additionally `self.current`, which is initialized with `self.empty`. I can see `self.current` as the state which gets called through the later reneder function, and `self.states` as likely the state included through the later change function, but enough speculation.

In the `:change` function, the class considers two arguments, in `stateName` and `enterParams`.

```lua
function StateMachine:change(stateName, enterParams)
end
```

Immediately, it uses a function called `assert()` to assess whether the state passed as argument exist in the table of states.

```lua
function StateMachine:change(stateName, enterParams)
  assert(self.states[stateName])
end
```

Then it implements a bit of logic to leave the current state and transition toward the new one.

```lua
function StateMachine:change(stateName, enterParams)
  assert(self.states[stateName])
  self.current:exit()
  self.current = self.states[stateName]()
  self.current:enter(enterParams)
end
```

It becomes essential to understand `enterParams` as well as the `:exit()` and the `enter()` functions, but the logic is understandable. `self.current` references the return value of the specific function in the `states` table. Before receiving this value, is 'exited' and later it comes back through specified parameters.

Correction: `exit()` and `enter()` are functions not made available on the `StateMachine` class, but refer to functions as stored in the state's table. You can already find them in the empty table, in `self.empty`. Each separate state class therefore defines the behavior of the state, and also how to exit and enter the state. The first one is used perhaps to de-allocate memory, and the second one to likely implement the logic and the render of the different graphics.

This covers the `init` and `change` function, but there also exist `:update(dt)` and `:render()` these are used to delegate the actual update and rendering to the specific class referring to the current state.

```lua
function StateMachine:update(dt)
  self.current:update(dt)
end

function StateMachine:render()
  self.current:render()
end
```

## BaseState.lua

We start to see here how the different states are implemented. As we stand, `main.lua` calls the `StateMachine` class. This instance then calls the specific states and specifically their functions: `state:exit()`, `state:enter()`.

In `BaseState`, the class includes a series of empty functions.

```lua
BaseState = Class{}

function BaseState:init() end
function BaseState:enter() end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end
```

This class doesn't actually achieve a goal other than providing an overview of what is required of each separate state class.

## TitleScreenState

The class sets up the scene immediately shown when playing the game. Its purpose is straightforward: introduce the game with a title, give the opportunity to play by pressing enter.

Instead of instantiating the class from scratch, it uses the structure of `BaseState`, inheriting its logic.

```lua
TitleScreenState = Class{__includes = BaseState}
```

This makes it so that `TitleScreenState` has the five different functions. Functions which are then only modified on a need-to-have basis. For instance, and in the `update(dt)` function, the state checks for a press on the enter (or return) key, and if so calls the state machine instance to change toward the playing state.

```lua
function TitleScreenState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('play')
  end
end
```

In the `render()` function, it includes the text to introduces the game and explain how to play it.

```lua
function TitleScreenState:render()
  love.graphics.setFont()
  love.graphics.printf() -- game title

  love.graphics.setFont()
  love.graphics.printf() -- how to play
end
```

Just fill in the functions with the font and the text you wish to display.

## PlayState.lua

Play state refers to the entire logic implemented so far, with all the update and render logic to have the bird and the pipes move. A few changes are however needed given the state structure.

Instead of creating an empty class, inherit again the structure of the `BaseState` instance.

```lua
PlayState = Class{__includes = BaseState}
```

In the `init()` function, include fields for the bird, the pairs of pipes and the timer (which is made a field instead of a global variable). The class is also made to reference the previous vertical coordinate for the pipes, in `self.lastY`.

```lua
function playState:init()
  self.bird = Bird()
  self.pipePairs = {}
  self.timer = 0

  self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end
```

In the `update(dt)` function, implement the logic for the scroll of the pipes and the gravity/jump of the bird.

```lua
function playState:update(dt)
  -- udpate logic
end
```

In the `render()` function, render the pipes and the bird.

```lua
function playState:render()
  for k, pair in pairs(self.pipePairs) do
    pair:render()
  end

  self.bird:render()
end
```

Quite a time and resource consuming update, so go through the code again if you need to grasp how the state machine is implemented.

# Flappy Bird 9 - Score

The score is not that distant from the score implemented with Pong, but there are a few changes introduced in this instance.

## main.lua

In addition to the previous states, require `ScoreState` class. This will be responsible for the screen showing the score.

```lua
require 'states/ScoreState'
```

In `:update(dt)`, complement the previous instances of the `StateMachine` class with the new value.

```lua
gStateMachine = StateMachine {
  ['title'] = function() return TitleScreenState() end,
  ['play'] = function() return PlayState() end,
  ['score'] = function() return ScoreState() end
}
```

## PipePair

In the `update()`, following the `self.remove` boolean, introduce also a flag for the score.

```lua
self.scored = false
```

The idea seems to delegate to the pipe when a point gets scored, <!-- (when the bird passes through?) --> with each pair increasing the score by one.

## PlayState

In the play state, the score is initialized in a separate field, `self.score`. Initially it is set to 0. Then, it is modified in the `update(dt)` function by looping through the pairs of pipes and adding one for each pipe with a flag of `score` set to true.

```lua
for k, pair in pairs(self.pipePairs) do
  if not pair.scored then
    if pair.x + PIPE_WIDTH < self.bird.x then
      self.score = self.score + 1
      pair.scored = true
    end
  end
end
```

The approach is rather nifty: instead of adding 1 for each pipe with a flag of scored, which would result in counting already scored pipes, over and over again, you count a point when:

- the pair does not have the `scored` boolean set to true;

- the bird is past the pair.

Only in this instance, count then point and then set the flag to true, making it so that the pair will not increase the tally more than once.

To achieve this feat, to check a condition opposite to a certain condition use `not` followed by the condition. (much alike the exclamation mark `!` in JavaScript).
