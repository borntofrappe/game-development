# Touch Pong

The goal of this project is to create the game pong with touch controls and basic shapes. Consider it a follow-up of `00 Pong`, and a good excuse to practice with `love.mousepressed` and functions from the `love.graphics` module.

![Touch Pong in a few frames](https://github.com/borntofrappe/game-development/blob/master/Practice/Touch%20Pong/touch-pong.gif)

## Gameplay

The players are represented by two paddles on opposing end of the screen. By clicking the left or right half of the window, the paddles move horizontally to have the ball bounce in the opposite direction. The paddles are represented with the outline of a circle, but when a point is scored, the appearance is modified with a growing circle. The idea is to have this filled circle expand point by point, until the paddle is completely filled and the player wins the game.

## Resources

In the `res` folder you find [`class.lua`](https://github.com/vrld/hump/blob/master/class.lua) to work with object-oriented programming. A later version might refactor the code to implement classes with of Lua's metatables, but the library offers a quick alternative.

The folder includes also the font [Train One](https://fonts.google.com/specimen/Train+One) and a few sound files created with [bfxr](https://www.bfxr.net/)

## Bouncing

When the ball collides with a paddle, the movement changes according to the ball movement and also the half of the paddle registering the collision. The idea is to specifically flip the horizontal direction when the ball moves rightwards and collides with the left half, or when the ball moves leftwards and collides with the right end.

```lua
if (self.dx > 0 and self.x < paddle.x) or (self.dx < 0 and self.x > paddle.x) then
  self.dx = self.dx * -1
end
```

In both cases `self.dx` and `self.x - paddle.x` have opposing signs, which means it is possible to simplify the condition as follows.

```lua
if (self.dx * (self.x - paddle.x) < 0) then
  self.dx = self.dx * -1
end
```

## Edges

When the ball reaches the left or right edge of the window, the ball doesn't bounce but moves to the opposing side.

```lua
if ball.dx < 0 and ball.x < -ball.r then
  ball.x = WINDOW_WIDTH + ball.r
end

if ball.dx > 0 and ball.x > WINDOW_WIDTH + ball.r then
  ball.x = -ball.r
end
```

The same logic is applied to the paddles, which are not locked to the right or left edge.

## Player

The `Paddle` class describes the basic shape and movement. The two players are however initialized with a `Player` class, which includes the logic of the game, like the number of points and whether the players are ready.

```lua
player1 = Player(WINDOW_WIDTH / 2, 0)
```

The class also updates the side with a rather declarative syntax: move, stop. These functions then call the more imperative functions in the paddle instance.

```lua
function Player:stop()
  self.paddle.dx = 0
end
```

Note that in `main.lua` you need to refer to `player.paddle` when comparing the ball against the circle making up the paddle.

```lua
if ball:collides(player1.paddle) then
  -- bounce
end
```

## Points

The number of points describes when one of the two sides wins, but also the inner radius of the paddle.

```lua
function Player:score()
  self.points = self.points + 1
  self.paddle.innerRadius = self.paddle.r * self.points / VICTORY
end
```

`innerRadius` dictates the radius of the filled circle included with `love.graphics.circle`.

```lua
function Paddle:render()
  love.graphics.setColor(0.15, 0.89, 0.89)
  love.graphics.circle("fill", self.x, self.y, self.innerRadius)
end
```

## State

`gameState` stores a string to manage the state of the game between four possible values: waiting, countdown, playing, and gameover. The variable is updated following a mouse click, and as follows:

- from waiting to countdown when both players are ready. Each side is ready following a mouse press on the respective side

- from countdown to playing when `countdown` reaches `0`

- from playing back to waiting when a point is scored

- from playing to gameover when one of the two sides wins

- from gameover to waiting following a mouse press

## Countdown

`countdown` stores an integer value to count down from `COUNTDOWN` to `0`. The variable is updated when `time` crosses the value of 1 second considering delta time.

```lua
time = time + dt
if time > 1 then
  time = time % 1
  countdown = countdown - 1
end
```

`COUNTDOWN_SPEED` is included to update the counter more frequently.

```lua
if time > 1 / COUNTDOWN_SPEED then
  time = time % (1 / COUNTDOWN_SPEED)
  countdown = countdown - 1
end
```

## Graphics

The game includes several functions from the `love.graphics` module:

- `love.graphics.setBackground` sets the background color directly in `love.load`

  ```lua
  function love.load()
    love.graphics.setBackgroundColor(0.16, 0.14, 0.33)
  end
  ```

- `love.graphics.translate` and `love.graphics.rotate` allow to render the instructions from the perspective of the two opposing sides

  The idea is to move the origin to the center of the canvas, draw the instructions for one player, rotate the reference 180 degrees and repeat the instructions on the other player.

  ```lua
  love.graphics.translate(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  -- p2
  love.graphics.rotate(math.pi)
  -- p1
  ```

- `love.graphics.line` draws a line considering input vertices

  ```lua
  love.graphics.line(x1, y1, x2, y2... xn, yn)
  ```

- `love.graphics.circle` draws a circle with a given mode, x and y origin and radius

  ```lua
  love.graphics.circle('fill', cx, cy, r)
  ```
