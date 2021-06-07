# Touch Pong

The goal of this project is to create the game pong with touch controls and basic shapes. Consider it a follow-up of `00 Pong`, and a pretext to practice with functions from the `love.graphics` module and the `love.mousepressed` interface.

## Gameplay

The players are represented by two paddles on opposing end of the screen. By clicking the left or right half of the window, the paddles move horizontally to have the ball bounce in the opposite direction. The paddles are represented with the outline of a circle, but when a point is scored, the appearance is modified with a growing circle. The idea is to have this filled circle expand point by point, until the paddleis completely filled and the player wins the game.

## Resources

In the `res` folder you find [`class.lua`]() to work with object-oriented programming. A later version might refactor the code to implement classes with of Lua's metatables, but the library offers a quicker alternative.

`font.ttf` includes the font [Train One](https://fonts.google.com/specimen/Train+One).

## love.graphics

- `love.graphics.setBackground` allows to set a background color directly in `love.load`

```lua
function love.load()
  love.graphics.setBackgroundColor(0.16, 0.14, 0.33)
end
```

- `love.graphics.translate` and `love.graphics.rotate` allow to render the instructions from the perspective of the two opposing sides.

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

## State

`gameState` stores a string to manage the state of the game between four possible values `{ 'waiting', 'countdown', 'playing', 'gameover' }`.

## Classes

- Paddle -> Player ???
- Ball

## Collision

## Points, goal
