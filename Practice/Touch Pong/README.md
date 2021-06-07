# Touch Pong

The goal of this project is to create the game pong with touch controls and basic shapes. Consider it a follow-up of `00 Pong`, and a pretext to practice with functions from the `love.graphics` module and the `love.mousepressed` interface.

## Gameplay

The players are represented by two paddles on opposing end of the screen. By clicking the left or right half of the window, the paddles move horizontally to have the ball bounce in the opposite direction. The paddles are represented with the outline of a circle, but when a point is scored, the appearance is modified with a growing circle. The idea is to have this filled circle expand point by point, until the paddleis completely filled and the player wins the game.

## Resources

In the `res` folder you find [`class.lua`](https://github.com/vrld/hump/blob/master/class.lua) to work with object-oriented programming. A later version might refactor the code to implement classes with of Lua's metatables, but the library offers a quick alternative.

The folder includes also the font [Train One](https://fonts.google.com/specimen/Train+One) and a few sound files created with [bfxr](https://www.bfxr.net/)

## Ball

Bounce collision.

```lua
if (self.dx > 0 and self.x < paddle.x) or (self.dx < 0 and self.x > paddle.x) then
  self.dx = self.dx * -1
end
```

```lua
if (self.dx * (self.x - paddle.x) < 0) then
  self.dx = self.dx * -1
end
```

## Paddle

Instead of limiting the paddles' moveent.

```lua
self.x = math.min(WINDOW_WIDTH - self.r, math.max(self.r, self.x + self.dx * dt))
```

The shapes move to the opposite side of the window.

```lua
if self.dx < 0 and self.x < -self.r then
  self.x = WINDOW_WIDTH + self.r
end

if self.dx > 0 and self.x > WINDOW_WIDTH + self.r then
  self.x = -self.r
end
```

The same logic is applied to the ball in `main.lua`. The circle moves to the opposing side instead of bouncing.

## Player

Paddle describes the basic shape and movement.

Player includes the logic with the ready state and the number of points.

The class also updates the side with a rather declarative syntax: move, stop.

Note that in `main.lua` you need to refer to `player.paddle` when comparing the ball against the circle making up the paddle.

## Points

Points, victory and inner radius.

## Countdown

`COUNTDOWN`, `COUNTDOWN_SPEED` constant. `countdown` and `time` variables.

## State

`gameState` stores a string to manage the state of the game between four possible values: waiting, countdown, playing, and gameover.

## love.graphics

- `love.graphics.setBackground` allows to set a background color directly in `love.load`

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

- `love.graphics.line` draws a line considering the input vertices

  ```lua
  love.graphics.line(x1, y1, x2, y2... xn, yn)
  ```

- `love.graphics.circle` draws a circle with a given mode, x and y orign and radius

  ```lua
  love.graphics.circle('fill', cx, cy, r)
  ```
