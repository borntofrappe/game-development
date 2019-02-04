# Pong 1

Index:

- [Code](#code)

<!-- no additional notes from the video -->

Snippet:

- main.lua

## Code

This is a note more about lua than the working code, but I think it provides a glimpse into the programming language and it can ultimately improve my understanding of the code.

In lua, you create functions like so:

```lua
function something()
  -- do something
  -- just remember to indent
end
```

And call them later like so:

```lua
something()
```

In the code for **Pong 1** however, you might have noticed a `:` colon. The syntax is connected to object oriented programming and the concept of `self`. Here's the gist:

- tables (lua's counterpart to objects) can have their own operations (functions);

- the operations described in the table can reference the table itself through the `self` keyword (much alike `this` in JavaScript);

- to later use these functions you include a colon after the tables' name.

From the docs this pattern can be highlighted as follows:

```lua
-- create an 'Account' table
Account = {
  balance = 0
}
-- in this table, detail a 'withdraw' function, which references the table's property through the 'self' keyword
function Account:withdraw (value)
  self.balance = self.balance - value
end

-- create an instance of the account
accountJimmy = Account
--[[
  accountJimmy is now a table with balance = 0
  AND most importantly,
  a table with the withdraw method available following a colon
]]
accountJimmy:withdraw(100) -- accountJimmy.balance = -100
```

Again, this has more to do with the lua language and is definitely a topic which needs to be revisited.

Putting this general note aside, the code makes use of a library called **push**, on github [right here](https://github.com/Ulydev/push), to provide a pixelated, retro-looking resolution. Here's how to use it:

- require it atop the `main.lua` file

  ```lua
  push = require 'push'
  ```

  Here a reference to the library is stored in the `push` variable.

- use a filter to avoid blur.

  ```lua
  love.graphics.setDefaultFilter('nearest', 'nearest')
  ```

- set up the 'virtual resolution', using the `push:setupScreen` function instead of`setMode`. They work similarly though, with the former simply detailing two additional arguments in the virtual width and height.

  ```lua
  push:setupScreen(virtualWidth, virtualHeight, width, height, options)
  ```

- in the draw function, whenever displaying something on the screen, wrap the functions in between `push:apply('start')` and `push:apply('end')`.

The code is available in `.lua`, but for the main branch, so to speak, I might decide to revert to normal resolution values. Not a fan of this resolution.

One last concept to draw from the codebase: the `keypressed` function. This ia a function available on the `love` object and intuitively allows to react to a key being pressed. It accepts as argument the key being pressed and, in the instance of the code, it terminates the program when identifying a particular key.

```lua
-- when a press is registered for the q letter terminate the program
function love.keypressed(key)
  if key == 'q' then
    love.event.quit()
  end
end
```

`love.event.quit()` is evidently the reference to the function available on the `love` object to terminate the running application.

This particular snippet also shows how to use a conditional statement in `if ... then`. It works again through indentation. Again, it ends with the `end` keyword. It checks for a condition with two equal signs.

```text
if condition then
  do something
```
