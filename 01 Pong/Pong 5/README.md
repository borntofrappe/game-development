# Pong 5

Index:

- [Class](#class)

Snippet:

- main.lua

- Paddle.lua

- Ball.lua

## Class

The project restructures the existing code through _classes_. These are data structures included to more easily manage the elements of the game, namely the paddles and the ball. You can think of a class as an independent entity, with its own variables and functions.

As classes are not a concept native to lua nor love2D, the helper library [provided in class.lua](https://github.com/vrld/hump/blob/master/class.lua) allows to include the construct.

This library is used not as much in `main.lua`, but in `Paddle.lua` and `Ball.lua`. These are separate files required atop the code managing the Love2D functions and which actually describe the different classes.

Remember: Love2D reads the `main.lua` file. Librarie and other lua files can be referenced from this main feature.

Moving on with classes, they work as follows:

- create a class through the `Class{}` keyword. By convention these are capitalized.

  ```lua
  Paddle = Class{}
  ```

  A class can have variables and functions, but starts out with an `init()` function.

- detail a function which runs whenever an instance of the class is created. An initialization function which describes the variables the class ought to hold.

  ```lua
  function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
  end
  ```

  Here, the class is initialized with four variables, describing the paddles coordinates and sizes. It also includes a `dy` variable, initialized to 0, which can be presumed to describe the vertical movement across the y axis.

  Whenever creating an instance of the class, be sure to include the arguments described in the `init` function. Indeed in the `main.lua` function, the paddles are created as follows:

  ```lua
  player1 = Paddle(10, 30, 5, 20)
  ```

  They are later updated using a syntax similar to dot notation in JavaScript. In the update function for instance:

  ```lua
  player1.dy = -PADDLE_SPEED
  ```

- beside the initialization function, declare all the methods connected to the class.

  In the code, the `Paddle` class is equipped with two functions: `update(dt)` and `render()`.

  They are called in `main.lua` as follows:

  ```lua
  player1:render()
  ```

  Using the colon roughly explained in Pong 0. Looking into the functions themselves, these describe the behavior previously included in the main file.

  - `update(dt)` allows to clamp the paddles to the boundaries of the window:

    ```lua
    function Paddle:update(dt)
      if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
      else
        self.y = math.min(VIRTUAL_HEIGHT - self.y, self.y + self.dy * dt)
      end
    end
    ```

    Notice how the function is itself created following a `:` colon, how it accepts an argument which mirrors the delta time in the update function and how the function itself references the values of the class through the `self` keyword.

    This allows to later call the function in `love.update`, pass in as argument delta time and have the function manage the clamping of the paddles.

    ```lua
    function love.update(dt)
      -- change the dy value of the paddles according to the key being pressed

      -- clamp the paddles to the windows edges
      player1:update(dt)
    end
    ```

    The idea is to update the vertical coordinate only on the basis of the `dy` value, and only through the update function.

  - `render()` on the other hand is much shorter and literally renders the paddle on the screen through the `love.graphics.rectangle()` function. This once more using the variables of the class instance, through the `self` keyword.

And this describes how classes, specifically for the paddles, work. For the `Ball` class, the code is rather similar:

- initialize the ball and the variables previously included each on their own. In the `init` function make sure to add `dx` and `dy` using `math.random`.

- describe a `reset()` functions which exactly repositions the ball in the center of the screen and sets new random values for the horizontal and vertical speed.

- include a `update(dt)` function, which similarly to the paddles' counterpart updates the coordinates on the basis of the delta values (in this instance both horizontally and vertically);

- add a `render` function which exactly reepats the structrue of the paddles' one.

All together it may look like a lot, but it is rather understandable.
