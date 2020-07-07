# Pong 3

## Code

This update sets out to make the game interactive, in so far as it allows to manouver the paddles vertically, and through the use of the keyboard. This using the `w` and `s` keys as well as the `up` and `down` keys, for the left and right paddle respectively.

From the code:

- the application shows two strings of text, adding a new string for the score. This uses a larger font, and Love2D apparently requires a new declaration. Every font you need in the project needs to go through the following procedure:

  - create an instance of the font, and the font at a specified size;

    ```lua
    newFont = love.graphics.newFont('path/name.ttf', 8)
    otherFont = love.graphics.newFont('path/name.ttf', 32)
    ```

  - set the font **before** you need to actually use it. In the project for instance, the fonts are set before the `print` functions actually using them.

    ```lua
    love.graphics.setFont(newFont)
    love.graphics.printf()

    love.graphics.setFont(otherFont)
    love.graphics.printf()
    ```

  In the project, one of the fonts is also and immediately set in the load function. I assume this is to give a default value for the entire application.

  What happens if you set a default value and change it only when needed? Well, apparently once the text is changed, it changes for the entire application. Just try and remove the first `setFont` method and `otherFont` will be applied to the first strin as well.

  This is more of a personal note, but it fits with the subject at hand. The fonts are declared in the `load()` function, and they are later accessed in the `draw()` function. There doesn't seem to be any conflict with the scope of the variables. I wonder if this is more about the Love2D framework or the lua programming language.

  That aside, the score is now shown through two string values, which is reasonable as these need to show the score of the individual players. The `printf` function however doesn't use hard-coded text, but the value held a variable, which brings me to the next point.

- the game begins to store certain values in variables, like the constant `PADDLE_SPEED`, the individual score values `player1Score`, `player2Score`, as well as the vertical position of the paddles, in `player1Y` an `player2Y`. These help structure the code and most importantly allow the program to be easily updated.

  I am still uncertain with regards to the scope though. The constant is declared outside of any function while the others are in the `load` function. I assume this is because the variables referring to the players are tihgtly connected to the paddles, and it makes sense to see them together.

  In any case, variables are declared like so:

  ```lua
  variableName = value
  ```

  They can be accessed directly using their name, and they are later updated like so:

  ```lua
  variableName = newValue
  ```

- to include the value of the variables as text, the project makes use of a `print` function, and includes the variables themselves through the `tostring` method.

  ```lua
  love.graphics.print(
    tostring(player1Score),
    VIRTUAL_WIDTH * 3 / 8,
    VIRTUAL_HEIGHT / 4
  )
  ```

  This function doesn't seem to accept the same number of arguments as `printf`, which means that more research on alignment is warranted.

  Immediately, I can safely use `printf` instead, and this works perfectly fine with the new variables and the desired alignment.

  ```lua
  love.graphics.printf(
      tostring(player1Score),
      0,
      VIRTUAL_HEIGHT / 4,
      VIRTUAL_WIDTH / 2,
      'center'
    )

  love.graphics.printf(
    tostring(player2Score),
    VIRTUAL_WIDTH / 2,
    VIRTUAL_HEIGHT / 4,
    VIRTUAL_WIDTH / 2,
    'center'
  )
  ```

  Just need a bit of adjustment as it relates to the second and fourth arguments (from where, centered with respect to what).

- to move the paddles, the code leverages a third fundamental function of Love2D, in `love.update`. This was introduced earlier, but never actually implemented. It is a function running every frame, and a function which can be used to update the game as per the game loop. `load` sets up the scenes, `draw` paints the canvas, `update` changes the settings.

  `love.update` can leverage the passage of time through an argument labeled `dt`. This refers to delta time and is likely how much time has passed in each frame. To maintain uniform speed in the paddles' movememnt, this value is used in conjunction with the constant `PADDLE_SPEED`. A variable which refers to the space traveled per frame (like meter per second, but here pixel per frame per second).

  ```lua
  function love.update(dt)
    -- following a key press on specific keys, update the vertical position of the paddles
    if love.keyboard.isDown('w') then
      player1Y = player1Y - PADDLE_SPEED * dt
    end
  end
  ```

  Notice the use of the `love.keyboard.isDown` function, which allows to listen for a continuous key press and returns a boolean. Notice again the structure of the `if... then` conditional statement. Here, the code actually uses an `if... then` `elseif ...then` conditional, which is structured simply as follows:

  ```lua
  if condition then
    -- do something
  elseif anothercondition then
    -- do something else
  end
  ```

  It is rather straightforward. Just remember to use the `end` keyword where appropriate. At the end of conditional statements and at the end of functions.

  Finally, notice how the position is updated according to the passage of time and the global variable describing the speed.

  For the opposite direction and the other paddle, it is a simple matter of reacting to the selected key being pressed.
