# Breakout 1 - Quads

In the graphics folder, it is possible to find several images making up the sprite sheets. These are structured as to contain multiple elements of the game, like bricks of different colors, power ups, and paddles. The idea is to section each image and dictate through code which pixel area to show.

We talk here of **quads**, rectangles with specified coordinate and sizes.

Essential functions are:

- `love.graphics,newQuad()`. Taking as argument `x`, `y`, `width`, `height` of the rectangles, as well as a `dimension`, an object returned from the image we want to section. This object is specifically returned with `xìimage:getDimensions`.

- `love.graphics,draw()`. Previously, this was used to draw images, but it can be used also in the context of sprite sheets. Taking as argument `texture`, `quad` and `x` and `y` coordinates. The function knows to draw only the rectangle specified in the quad.

## Util.lua

This file is created as a utility, to achieve the following daunting tasks:

- create quads (read: rectangles) out of a sprite image;

- retrieve a specific quad.

This to allow a render, or otherwise draw function to depict the specific element. The code is not that easy to approach, but I beliece it is worth to parse through the text.

The file itself is made up of three functions.

### GenerateQuads()

This function is created to divide the sprite image into quads.

Takes as arguments:

- `atlas`, the image to be 'quadded', so to speak;

- `tileWidth`, the unit of measure detailing the smallest measure in which the image can be sectioned;

- `tileHeight`, the same of `tileWidth`, but with respect to the height.

Based on this argument the function creates an empty table and fills it with sections of the image. This by looping through the tiles vertically and horizontally:

```lua
-- retrieve the number of tiles to be created horizontally
local sheetWidth = atlas:getWidth() / tileWidth
-- retrieve the number of tiles to be created vertically
local sheetHeight = atlas:getHeight() / tileHeight

-- initialize a counter variable used for the field of each quad
local sheetCounter = 1
-- initialize an empty table in which to insert each quad
local spritesheet = {}

-- loop through the tiles of the image
for y = 0, sheetHeight - 1 do
  for x = 0, sheetWidth - 1 do
    -- add to the table and in the field specified by sheetCounter the quad matching the coordinates specified by x and y
    spritesheet[sheetCounter] = love.graphics.newQuad(
      -- the quads have all the same height and width, but differ in the coordinate as to describe progressively the following rectangles
      x * tileWidth,
      y * tileHeight,
      tileWidth,
      tileHeight,
      atlas:getDimension() -- object returned from the image to-be-sectioned
    )

    -- increment the counter to target the following rectangle
    sheetCounter = sheetCounter + 1

  end
end

--[[
  return the spritesheet, which is now a table structured like so

  {
    [1] = quad for the first rectangle in the top left corner
    [2] = quad right next to the top left corner
    and so forth ond so on, one row at a time
  }

]]
return spritesheet
```

### table.slice()

This function is created to identify a sub-section of the sprite image.

Takes as argument:

- `table`, the spreadsheet table to-be-divided;

- `first`, `last` and `step`, This to slice the table from a certain point to another specified point, and at a described interval.

Default values and lua-specific syntax warrant a bit more attention

```lua

function table.slice(tbl, first, last, step)
  -- initialize a variable in which to describe the sub section of the table
  local sliced = {}

  --[[
    loop from first to last, at an interval described by step, with the following default values

    first: 1
    last: length of the table
    step: 1

    the length of a table is found by prefacing the name with a `#` pound sign

    #tablename

    a default value can be dictated through the `or` keyword
  ]]
  for i = first or 1, last or #tbl, step or 1 do
    -- add to the sliced table the specified quad
    -- each expanding the sliced table by targeting the index following its length
    sliced[#sliced+1] = tbl[i]
  end

  -- return the subset of the table, identifying the necessary quads
  return sliced
end
```

### GenerateQuandsPaddles()

The function is created to use the `newQuad` function and to specifically identify the paddles.

It takes as argument `atlasΣ, the sprite image being pieced and returns the quads corresponding to the rectangle describing the blue paddle.

```lua
function GenerateQuadsPaddles(atlas)
  -- describe the starting coordinates of the paddle
  local x = 0
  local y = 64

  -- initialize a counter variable to identify as many paddles as there are in the sprite image
  local counter = 1
  -- initialize a table in which to describe the quads (much alike GenerateQuads)
  local quads = {}

  -- repeat the logic as there are paddles (four different color)
  for i = 0, 3 do
    -- for each counter variable add a field in the quads describing each paddle (four sizes for the different four colors)
    -- small
    quads[counter] = love.graphics.newQuad(x, y, 32, 16, atlas:getDimensions())
    counter = counter + 1

    -- each time add to the x or y coordinate to identify the different sprites
    -- medium
    quads[counter] = love.graphics.newQuad(x + 32, y, 64, 16, atlas:getDimensions())
    counter = counter + 1

    -- 96 as 32 + 64 (where the previous paddle ends)
    -- large
    quads[counter] = love.graphics.newQuad(x + 96, y, 32, 16, atlas:getDimensions())
    counter = counter + 1

    -- the largest paddle being in a new row
    -- huge
    quads[counter] = love.graphics.newQuad(x, y + 16, 128, 16, atlas:getDimensions())
    counter = counter + 1

    -- reset x to start from the left
    x = 0
    -- set y to find the new row
    y = y + 32
  end

  -- return the table of paddles (16 paddles total, for the paddle of solid blue, gree, red, purple)
  return quads

end
```

This is a rather unintuitive function, due to the hard coded values, but once you start to see the purpose of the counter loop and the for loop, and the goal of the function as a whole to create rectangles for 16 paddles of 4 different colors and different sizes, it becomes much clearer.

### main.lua

In `main.lua` add the different sprites in yet another global variable, using the graphics and the function to section out the desired area. For the paddles for instance, the `'paddles'` field is assigned the return value of the `GenerateQuadsPaddles()` function, to which the texture displaying the paddles is passed as argument.

```lua
gFrames = {
  ['paddles'] = GenerateQuadsPaddles(gTextures['breakout'])
}
```

To allow the state machine to transition between start and play state, remember to also update the matching global variable to refer to the `PlayState`.

```lua
gStateMachine = StateMachine {
  ['start'] = function() return StartState() end,
  ['play'] = function() return PlayState() end
}
```

Allowing to have the `gStateMachine:change()` function to refer to the new state.

### Paddle.lua

Just like in Pong, the paddle for Breakout is separated into its own class. This time around though, the movement is exclusively horizontal and the graphic being used is found in the `gFrames['paddles']` table.

- in the `init()` function set up the paddle with its `x` and `y` coordinates, the horizontal movement in `dx` and the size in `width` and `height`.

  Use here the pixel values replicating the size of the sheet, to maintain its ratio (64 width, 16 height).

  In addition to these values, which don't distance themselves from the Pong paddle, include `skin` and `size`. These are two different integer values which allow to target paddles of different colors and sizes. Remember that the table `gFrame['paddles']` includes paddles ordered in sizes and then colors, so that the first item is blue and small, the second blue and medium and so forth. By leveraging the skin and the size it is possible to find the specific paddle.

  ```text
  paddle = self.size + 4 * (self.skin - 1)
  ```

  This works cognizant of the fact that there are four sizes and that paddles start from the field `1`, as in `gFrame['paddles'][1]`

  For the large purple paddle for instance:

  ```text
  paddle = 3 + 4 * (4 - 1) <--- 15
  ```

- in the `update(dt)` function specify the movement of the paddle as a result of the left or right key being pressed. Alter here the `dx` field and just like for pong clamp the moevement to the edges of the window. This time around referring to the width and instead of the height though.

  This is important: using the `love.keyboard.wasPressed()` function works, but considers only a single key press. To continuously check for the key bring pressed, use the love2d native `love.keyboard.isDown()` function. The two accept the same argument.

- in the `render()` function, use `love.graphics.draw` passing as argument, and as mentioned:

  - the texture;

  - the frame to be drawn from the texture, using the size and skin values;

  - the coordinate.

### PlayState.lua

Starting out, `PlayState` is used to display the paddle as identified from the utility function `GenerateQuadsPaddles`, and specifically the second paddle, as set by default in the `Paddle` class.

- in the `init()` function initialize an instance of the `Paddle` class;

- in the `update(dt)` function update the position of the paddles through the `paddle:update(dt)` function. Listen also for the escape character being pressed, at which point quit the game. Scratch that. At which point call the start state, turning back to the introductory screen.

- in the `render()` function, render the paddle.

In addition to this the project starts to implement a pause feature. This is still ongoing, but the idea is to include a specific string of text if the game is paused, and have the play state refer to a `self.paused` boolean which gets toggled at the press of a button. Given I was able to entertain such a state in flappy bird, I might go ahead with update 1+ and include the feature.

### Dependencies.lua

Remember here to add the `lua` files to be used throughout the application.

```lua
require 'src/Util

require 'src/states/PlayState'
```

## Update 1+ - Pause

As I mentioned, the lecturer hints at a pause screen, and specifies logic in the `PlayState` to accommodate for such a feat. The feature is never actually implemented, but for practice with creating a state and interacting with the keyboard, I decided to develop it on my own.

### Add PauseState

This means:

- include a file in the `state` folder;

- reference the value in the `Dependencies.lua` file;

- add the state to the instance of the state machine.

### Transition to PauseState

Pause state is added as a possibility from the play state, and opportunity is given to reach the pause state and leave it only in connection to the play state.

From the play state, the state is introduced by pressing the `enter` key.

From the pause state, this is left once more by pressing the pause key.

### Maintain State

To have some values persist in the play state (currently for the horizontal position only, but later for the score and brick structure), the `:enter()` function available on every state instance can be used.

- when moving toward the pause state specify the `x` coordinate in the enter parameters;

- when entering into the pause state, define a field storing this value;

- when reverting back to the play state, re-send the value in the play state, which needs to be equipped as to receive it, in its own `:enter()` function.
