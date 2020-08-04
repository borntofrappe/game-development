Set up the game and the start screen.

## Project structure

With the first update, the lecturer introduces a more structured approach to the game, a more structured organization of the project files.

- _main.lua_ works as the entry point of the game. It is the script ultimately run through love2D

- _res_ is the folder with the various resources: fonts, graphics, libraries, and sounds

- _src_ contains the `.lua` files in which the game is broken down

## main.lua

The entry point for the game sets up the necessary resources through global variables: `gFonts`, `gTextures`, and `gSounds`.

The state machine is exactly the same state machine introduced in _02 Flappy Bird_, so I won't repeat the notes included in that project. For the current update, there's only one state, `StartState`, in which to show the game title and introductory menu, more on that later.

Aside from these elements, the script creates a table in which to store the key being pressed, and renders the background with `love.graphics.draw`. Similarly to _01 Pong_, the script contains a utility function in `displayFPS()`, which shows the frames per seconds in which the game is running.

## Dependencies.lua

Instead of importing the different libraries in _main.lua_, the necessary modules are imported in _Dependencies.lua_.

```lua
push = require 'res/lib/push'
Class = require 'res/lib/class'

require 'src/constants'

require 'src/StateMachine'

require 'src/states/BaseState'
require 'src/states/StartState'
```

The idea is to fill the dedicated file as neeed, and have _main.lua_ import everything by importing _Dependencies.lua_

```lua
require 'src/Dependencies'
```

Pay attention to the the path of the libraries. Since _Dependencies.lua_ is imported and runs in _main.lua_, the path is relative to the root level.

## Constants.lua

This is a utility which works as to centralize the constant values from _main.lua_.

```lua
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--[[ ... other constants ]]
```

Finally, import the file in _main.lua_ to later use the variables.

```lua
require 'src/constants'
```

## StartState.lua

The update introduces the start state with the title of the game, but also an introductory menu. This menu allows to choose between one of two options, and the controlling variable is nothing but an integer.

```lua
function StartState:init()
  self.choice = 1
end
```

In the `update()` function modify the value following a press on the arrow keys (currently, there are only two possible values)

```lua
function StartState:update(dt)
  if love.keyboard.waspressed('up') or love.keyboard.waspressed('down') then
    self.choice = self.choice == 1 and 2 or 1
    gSounds['paddle_hit']:play()
  end
end
```

In the `render` function then use the choice to color whichever string is being selected with a different hue.

```lua
love.graphics.setColor(1, 1, 1, 1)
love.graphics.setFont(gFonts['big'])
if self.choice == 1 then
  love.graphics.setColor(0.4, 1, 1, 1)
end
love.graphics.printf(
  'START',
  0,
  VIRTUAL_HEIGHT * 3 / 4,
  VIRTUAL_WIDTH,
  'center'
)
```

Just remember to reset the color after you modify and use the specific hue.
