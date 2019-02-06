# Pong 7

Index:

- [Update Collision](#update-collision)

- [Ball Collision](#ball-collision)

Snippet:

- main.lua

- Ball.lua

Pong 7 focuses on detecting collision between the paddles and the ball, but also adds a title to the page. This is a minor tweak, but it is allowed by the `setTitle()` function, available on the `love.window` module.

As regards the collision detection, this is included in the `love.update(dt)` function, before the ball/paddle have a chance to move. Furthermore, it is included through the `Ball` class, and specifically a `:collides()` function, to which a paddle is passed as argument.

I'll review the function later, but assuming it returns a boolean, it is possible to establish how it works in the context of the `main.lua` file.

## Update Collision

If the game is ongoing, the `update` function checks if the ball collides, with the first or second paddle.

The logic can be summarised as follows (given a collision):

- change the horizontal direction and slightly increase the speed:

  ```lua
  ball.dx = -ball.dx * 1.03
  ```

- change the horizontal coordinate to avoid an immediate overlap between paddle and ball.

  For the first paddle, this means positioning the ball to the right of the paddle:

  ```lua
  ball.x = player1.x + player1.width
  ```

  For the second paddle, this means positioning the ball to the left of the paddle:

  ```lua
  ball.x = player2.x - ball.width
  ```

  The coordinates are incremented/ decremented considering how shapes are drawn from the top left corner, lef to right (and top to bottom).

- change the vertical direction, but keep the same trajectory (never going in the opposite direction from which the ball came). This is guaranteed by including a random value which is always negative if `dy` is already negative, or accordingly otherwise.

  ```lua
  if ball.dy < 0 then
    ball.dy = -math.random(10, 150)
  else
    ball.dy = math.random(10, 150)
  end
  ```

Beside thse conditional statements, the file also includes another `if then` statement, to assess the vertical coordinate of the ball. This to guarantee that not only a collision with the paddles, but a collision with the lower and upper edge of the window results in a bounce.

For the lower edge, reverse the direction when `y` is below or equal to 0:

```lua
if ball.y <= 0 then
  ball.y = 0
  ball.dy = -ball.dy
```

The value is immediately set to 0 to once again avoid immediate overlaps.

For the upper edge, repeat the same logic, but when the ball reaches the top of the screen:

```lua
if ball.y >= VIRTUAL_HEIGHT - ball.width then
  ball.y = VIRTUAL_HEIGHT - ball.width
  ball.dy = -ball.dy
```

## Ball Collision

In the `Ball.lua` file, the `:collide` function takes as argument a paddle and checks the position of the ball in connection to the coordinate of this object. It then checks through a series of conditional whether the ball and the paddle are **not** overlapping, returning `true` otherwise.

An overlap, actually the lack of an overlap is assed by checking the position of the edges of the two shapes with the following considerations:

- if the horizontal coordinate of the right edge of one shape is less than the one of the left edge of the other shape;

- if the horizontal coordinate of the left edge of one shape is greater than the one of the right of the other shape

Then the two are not overlapping, given how the shapes are continuous and box-like.

Again:

- if the vertical coordinate of the bottom edge of one shape is greater than the one of the top edge of the other shape;

- if the vertical coordinate of the top edge of one shape is less than the one of the bottom edge of the other shape

Then the two are not overlapping either. Just be sure to account for the width/height of the two shapes (always working with the described coordinate system).
