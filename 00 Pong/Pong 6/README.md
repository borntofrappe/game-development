# Pong 6

_Please note:_ `main.lua` depends on `push.lua`, `class.lua` and `font.ttf` being available in the same folder

## Class

The project restructures the existing code through _classes_. You can think of a class as an independent entity, with its own variables and functions; consider for instance `Ball` and `Paddle`.

Classes are not a concept native to lua, nor love2D, and the course introduces here the helper library [class.lua](https://github.com/vrld/hump/blob/master/class.lua) to include the construct.

This library is used not as much in `main.lua`, but in `Paddle.lua` and `Ball.lua`. These are separate files required atop the code managing the Love2D functions and which actually describe the different classes.

Remember: Love2D reads the `main.lua` file. Libraries and other lua files can be referenced from this main script.

```lua
push = require 'push'
Class = require 'class'

require 'Paddle'
require 'Ball'
```

## Paddles

Considering the library included with `class.lua`

- create a class through the `Class{}` keyword. By convention these are capitalized.

  ```lua
  Paddle = Class{}
  ```

  A class can have variables and functions (methods), but starts out with an `init()` function.

- detail what happens whenever an instance of the class is created through the `init` function

  ```lua
  function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
  end
  ```

  Here, the class is initialized with four variables, describing the paddles coordinates and sizes. It also includes a `dy` variable, to later describe the vertical movement across the y axis.

  Whenever creating an instance of the class, be sure to include the arguments described in the `init` function. In `main.lua` for instance, the paddles are created in the `love.load` function as follows:

  ```lua
  player1 = Paddle(10, 30, 5, 20)
  ```

  They are later updated using a syntax similar to dot notation in JavaScript. In the update function for instance:

  ```lua
  player1.dy = -PADDLE_SPEED
  ```

- beside the initialization function, declare all the methods connected to the class.

  In the code, the `Paddle` class is equipped with two functions: `update(dt)` and `render()`.

  - `render` to draw the paddle through love2d and its rectangle function

  ```lua
  function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
  end
  ```

  - `update(dt)` to move the paddle according to its position, `dy` variable and the boundaries of the window

  ```lua
  function Paddle:update(dt)
    if self.dy < 0 then
      self.y = math.max(0, self.y + self.dy * dt)
    else
      self.y = math.min(VIRTUAL_HEIGHT - self.y, self.y + self.dy * dt)
    end
  end
  ```

  You are effectively moving the code from `main.lua` to `Paddle.lua`, but in so far ensuring an independent entity. If you need to change the way the paddle behaves, you do so in `Paddle.lua`. In `main.lua`, you call the functions to update the and render the shape without worrying about the implementation

  ```lua
  function love.update(dt)
    player1:update(dt)
  end

  function love.draw()
    player1:render()
  end
  ```

  This allows to later call the function in `love.update`, pass in as argument delta time and have the function manage the clamping of the paddles.

  ```lua
  function love.update(dt)
    -- change the dy value of the paddles according to the key being pressed

    -- clamp the paddles to the windows edges
    player1:update(dt)
  end
  ```

## Ball

For the `Ball` class, the code repeats much of the instructions specified for the paddles:

- initialize the ball with the variables describing its position and movement. The only difference is here that the ball moves in both the `x` and `y` dimensions, and that it uses `math.random` for both `dx` and `dy`

```lua
function Ball:init(x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.dx = math.random(2) == 1 and 100 or -100
  self.dy = math.random(-50, 50)
end
```

- update the ball using delta time, `dt`

  ```lua
  function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
  end
  ```

- draw the ball using the `rectangle` function

```lua
function Ball:render()
  love.graphics.rectangle('fill', self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
end
```

Finally, and differently from the paddle class, add a `reset()` method to reposition the ball in the center of the screen.

```lua
function Ball:reset()
  self.x = VIRTUAL_WIDTH / 2 - self.width / 2
  self.y = VIRTUAL_HEIGHT / 2 - self.height / 2
  self.dx = math.random(2) == 1 and 100 or -100
  self.dy = math.random(-50, 50)
end
```

Once more, this allows `main.lua` to reposition the ball with a cleaner syntax.

```lua
if gameState == 'waiting'
  gameState = 'playing'
else
  gameState = 'waiting'
  ball:reset()
end
```
