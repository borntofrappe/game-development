# Breakout 0

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Breakout — Final`.

## Project structure

The game is more structured than previous demos, and the organization reflects this complexity:

- `main.lua` works as the entry point of the game

- the `res` folder includes the various resources: fonts, graphics, libraries, and sounds

- the `src` folder contains the `.lua` files in which the game is broken down

## main.lua

The entry point defines a few global variables used throughout the game: `gFonts`, `gTextures`, and `gSounds`.

The state machine is exactly the same state machine introduced in `02 Flappy Bird`, so I won't repeat the notes included in that project. For the current update, there's only one state, `StartState`, in which to show the game title and first menu.

Aside from these elements, the script defines basic state machine and includes a table in `love.keyboard` to keep track of the keys being pressed. This is similarly to `01 Flappy Bird`.

In `love.draw`, beside rendering the contents of the game through the state machine, the script shows the background image and displays the frames per seconds through the `displayFPS` function.

## Dependencies.lua

Instead of importing the different libraries in `main.lua`, the necessary modules are required in `Dependencies.lua`.

```lua
push = require 'res/lib/push'
Class = require 'res/lib/class'

require 'src/constants'

require 'src/StateMachine'

require 'src/states/BaseState'
require 'src/states/StartState'
```

The idea is to then require everything by referencing `Dependencies.lua` itself.

```lua
require 'src/Dependencies'
```

Pay attention to the the path of the libraries. Since `Dependencies.lua` is imported and runs in `main.lua`, the path is relative to the root level.

```diff
require "constants"
+require "src/constants"
```

## Constants

`constants.lua` includes constants used throughout the game. Similarly to the dependencies, the idea is to move the variables to a dedicated script instead of adding the values at the top of `main.lua`

```lua
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--[[ ... other constants ]]
```

## State

The update introduces a state machine with a single state, highlighting the title screen and a rudimentary menu to choose between one of two options. To control the selected option, `self.choice` is defined as an integer.

```lua
function StartState:init()
  self.choice = 1
end
```

In the `update()` function, the integer is modified by pressing the top or down arrow keys.

```lua
function StartState:update(dt)
  if love.keyboard.waspressed('up') or love.keyboard.waspressed('down') then
    self.choice = self.choice == 1 and 2 or 1
    gSounds['paddle_hit']:play()
  end
end
```

In the `render` function then, the integer is included to style the matching option with a different hue.

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

Just remember that `love.graphics.setColor` sets the color for every asset which follows, and it is therefore necessary to reset the value to the hue chosen for the unselected text.

## Sounds

Unlike previous projects, sound is included from the very first update. Aside from sound bytes for the menu, take notice of the music included as a soundtrack.

```lua
gSounds["music"]:setLooping(true)
gSounds["music"]:play()
```

The track is set to loop continuously to create the illusion of a continuous track.

## Background size

The texture used in the background is scaled according to the size of the virtual window and the dimensions of the actual image. This scaling is made possible thanks to the syntax of the `love.graphics.draw` function.

```lua
love.graphics.draw(
  drawable,
  x,
  y,
  rotation,
  scaleX,
  scaleY
)
```
