Here you render the visuals in a pixellated fashion.

**requires push.lua**

## Code

### push

The code makes use of a library called `push`. It is available on github [right here](https://github.com/Ulydev/push), and it allows to achieve a resolution based on the actual/virtual dimensions defined atop the script.

Here's how to update the resolution

- require the `push` library

  ```lua
  push = require 'push'
  ```

- define two sets of variables for the actual/virtual dimensions

  ```lua
  WINDOW_WIDTH = 864
  WINDOW_HEIGHT = 486

  VIRTUAL_WIDTH = 432
  VIRTUAL_HEIGHT = 243
  ```

  `push` works by "projecting" the image comparing the actual versus virtual measures

- in the `load` function, add a line to set up a filter

  ```lua
  love.graphics.setDefaultFilter('nearest', 'nearest')
  ```

  This is used to avoid blur

- always in the `load` function, set up the resolution using `push:setupScreen`:

  ```lua
  push:setupScreen(virtualWidth, virtualHeight, width, height, options)
  ```

  The function is used instead of`setMode`, and except for the two additional arguments describing the virtual dimensions (`virtualWidth` and `virtualHeight`), the two work in the same fashion

  The colon operator `:` allows to use the `setupScreen` function from the `push` module

- in the `draw` function, draw/render the shapes in between `push:apply('start')` and `push:apply('end')`.

### keypress

In `draw`, the code introduces `love.keypressed`. This function allows to react to a key being pressed. It receives as argument the key being pressed and, in the instance of the code, terminates the program when identifying a particular key.

```lua
function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end
```

In this instance pressing the character `esc` is used as a signal to quite the window.

Refer to [KeyConstant](https://love2d.org/wiki/KeyConstant) for a list of the possible keys.
