# Pong Assignment

With the [AI Update](https://cs50.harvard.edu/games/2019/spring/assignments/0/) the final project is expanded to have one paddle moving on its own. I decided to control the left paddle and as follows:

- in `love.load` initialize a table to keep track of three variables

  1. `x` to describe the threshold after which the paddle should consider the ball

  2. `y` to describe where the paddle should move

  3. `looksAhead` to avoid computing the vertical coordinate continuously

  ```lua
  ai = {
    ['x'] = math.random(VIRTUAL_WIDTH / 2, VIRTUAL_WIDTH * 3 / 4),
    ['y'] = VIRTUAL_HEIGHT / 2,
    ['looksAhead'] = false
  }
  ```

- set `ai['looksAhead']` to true following multiple conditions

  - when the game moves to the playing state

  - when the ball collides with the player

  - when the ball collides with the top of bottom edge

- in `love.update` compute `ai['y']` when the boolean variable is true and the ball is moving toward the computer

  ```lua
  if ai['looksAhead'] and ball.dx < 0 and ball.x < ai['x'] then
    -- compute ai['y']
  end
  ```

  `ai['x']` is used as an additional condition to have the computer

  `ai['y']` is computed considering where the ball will move. `ball.x / math.abs(ball.dx)` describes the time the ball takes to move toward the left side — space divided by velocity. `ball.dy * time` illustrates the change in vertical coordinate, so that the paddle moves toward `ball.y + changeY`

  ```lua
  ai['y'] = ball.dy * ball.x / math.abs(ball.dx) + ball.y
  ```

- move the computer toward `ai['y']`, matching the way the player moves following key input

  ```lua
  if computer.y > ai['y'] then
    computer.dy = -PADDLE_SPEED
  elseif computer.y + computer.height < ai['y'] then
    computer.dy = PADDLE_SPEED
  else
    computer.dy = 0
  end
  ```

The solution allows for some exchange between paddles, but definitely allows the player to win. The speed is the same for both paddles, and this means that if the vertical distance is greater than the space the computer can make up, the player will score.
