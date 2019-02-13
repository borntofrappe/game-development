# Breakout 0

With the first update the lecturer introduces a more structured approach to the files, with better organization (libraries, fonts, graphics each stored in their own folder) and also modular code (in which files fulfill each a clear purpose).

## main.lua

In `main.lua` we see this new structure affecting also the way fonts and graphics are introduced. Each in a global variable referencing a table.

To refresh how the lua language leverages table, remember to:

- wrap fiel-value pairs in `{` curly brackets `}`

- introduce fields in between `[` square brackets `]` and wrapped in `'` quotes `'`

- after assigning a value, separate succeeding fields with a `,` comma

```lua
gFonts = {
 ['fieldname'] = fieldValue,
 ['fieldname'] = fieldValue,
 ['fieldname'] = fieldValue
}

-- graphics
gTextures = {
 -- same organization
}
```

These values are defined in the `load` function and for the graphics in particular, refer to:

- background, the image behind every other asset;

- main, the sprite file with the bricks, paddles;

- arrows, the paddles;

- hearts, for the health;

- particle, the texture for the particle animation when a brick is hit.

Following this new organization, which is also repeated for sound files, the `push` library leverages constant values in `VIRTUAL_WIDTH`, `VIRTUAL_HEIGHT` and the sizes of the window, retrieving these properties from a separate file. This `constant.lua` file is separated in an `src` folder which contains all dependencies as well as the different states held by the application.

Finally in the `load` function, the state machine is set up like in Flappy bird and the state is initiated to `start`. The function also includes a `love.keyboard.keysPressed` empty table, presumably to replicate the feature introduced with Flappy bird which allows to keep track of the keys being pressed.

Following up `love.load()` update 0 continues with the following logic:

- `love.resize()` allows to resize the window through the `push` library;

- `love.update(dt)` updates the state through the state machine and resets the table of keys being pressed;

- `love.keypressed(key)` updates the key pressed table to set the key being pressed to a field with a true value;

- `love.keyboard.wasPressed(key)` returns a boolean describing whether the key passed as argument is present in the table just described;

- `love.draw()` sets up the virtualiaztion and in between the `push` functions draws the background, before rendering the application through the state machine. The function also includes a call to a function rendering the frame per seconds in the top left corner, and similarly to Pong, but it is the background that perhaps warrants a specified mention. The background is drawn through the `draw` function and the image is stretched to cover the entirety of the screen by scaling the width and the height up:

  ```lua
  love.graphics.draw(
    gTextures['background'],
    0,
    0,
    VIRTUAL_WIDTH / backgroundWidth -- retrieved through the :getWidth() function,
    VIRTUAL_HEIGHT / backgroundHeight -- retrieved through the :getHeight() function
  )
  ```

## Dependencies.lua

In the `src` folder, right next to the states, state machine and constant file, `Dependencies.lua` is created to implement the mentioned modularization. This has all the logic necessary to `require`, import other files and variables, and replaces the `require` statements atop `main.lua`.

## States

States are included in a separate folder, and currently present only `BaseState`, base file on which all state classes are based, and `StartState`, which is responsible to render the introductory screen.

Specifically, it shows the title and two additional strings in `Start` and `High Score`. The idea is to allow the player to select between the two, and as these are not actual buttons, the selection is 'faked' by introducing an integer identifying either screen and reacting to mouse events to change its value. Based on this value then, the specified string is changed in color through the `love.graphics.setColor` function. Just remember to reset the color after using it.
