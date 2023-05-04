# Pong 4

_Please note:_ `main.lua` depends on `push.lua` and `font.ttf` being available in the same folder

## Fonts

The score is rendered with a larger font.

For every font family, for every font size, you need to repeat the process described in a previous section.

- create an instance of the font at a specified size;

  ```lua
  font = love.graphics.newFont('font.ttf', 8)
  largeFont = love.graphics.newFont('font.ttf', 32)
  ```

- set the font **before** you need to actually use it

  ```lua
  love.graphics.setFont(newFont)
  love.graphics.printf()

  love.graphics.setFont(largeFont)
  love.graphics.printf()
  ```

  Once set, the font will be applied to the visuals which follow

In the project, one of the fonts is also and immediately set in the load function. This to give a default value for the entire application.

## Score

To render the score, the `printf` function doesn't use hard-coded strings, but two variables referring to integer values.

- initialized in `love.load()`

```lua
player1Score = 0
player2Score = 0
```

- render through the `tostring()` function.

```lua
love.graphics.printf(
    tostring(player1Score),
    ...
  )
```

`tostring()` coerces the number to a string value. That being said, the app still works if you refer directly to the integer.

## Variables

The code initializes variables at the top of the script, but also in the `love.load` function.

- `PADDLE_SPEED` details how much the paddle is moved following user input

```lua
PADDLE_SPEED = 200
```

- `player1Score` and `player2Score` describe the score of each player

```lua
function love.load()
  player1Score = 0
  player2Score = 0
```

- `player1Y` an `player2Y` keep track of the vertical position of the paddles.

```lua
function love.load()
  player1Y = VIRTUAL_HEIGHT / 4
  player2Y = VIRTUAL_HEIGHT * 3 / 4
```

**Important**: `PADDLE_SPEED` would be equally available if initialized in `love.load()`. It is not in the `load` function to have the value alongside the other constants.

```lua
WINDOW_WIDTH = 1080
WINDOW_HEIGHT = 608

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200
```

## User input

To move the paddles, the code leans on the core function `love.update(dt)`. As mentioned in a previous chapter, this function runs at every frame, and can be used to update the game as per the game loop.

`dt` refers delta time, how much time has passed in each frame. To maintain uniform speed in the paddles' movememnt, this value is used in conjunction with the constant `PADDLE_SPEED`.

```lua
function love.update(dt)
  player1Y = player1Y - PADDLE_SPEED * dt
end
```

This works as to move the paddle, but it does so regardless of user input.

To consider user interaction, refer to `love.keyboard` and `love.keyboard.isDown`. The function accepts as argument a key, similarly to `love.keypressed`. It listens continuously for a key press and returns a boolean describing whether the specific key is being pressed.

```lua
function love.update(dt)
  if love.keyboard.isDown('w') then
    player1Y = player1Y - PADDLE_SPEED * dt
  end
end
```

Considering the coordinate system, reducing the value of the vertical coordinate `player1Y` moves the paddle upwards. Increasing the value moves the paddle downwards.

```lua
function love.update(dt)
  if love.keyboard.isDown('w') then
    player1Y = player1Y - PADDLE_SPEED * dt
  elseif love.keyboard.isDown('s') then
    player1Y = player1Y + PADDLE_SPEED * dt
  end
end
```

Consider two approaches here:

1. one `if elseif` statement

```lua
if love.keyboard.isDown('w') then
  player1Y = player1Y - PADDLE_SPEED * dt
elseif love.keyboard.isDown('s') then
  player1Y = player1Y + PADDLE_SPEED * dt
end
```

2. two `if` statements

```lua
if love.keyboard.isDown('w') then
  player1Y = player1Y - PADDLE_SPEED * dt
end

if love.keyboard.isDown('s') then
  player1Y = player1Y + PADDLE_SPEED * dt
end
```

In the first instance, the paddle is allowed to move up or down. Moreover, order matters: since `w` is evaluated first, moving the paddle upwards is never cancelled by pressing the opposite key.

In the latter instance, the paddle can be updated in both directions. The end result is that by pressing both keys, the paddle stays virtually stills. In fact the position is being updated, but in opposite directions.

That aside, to move the other paddle is a matter of adding additional control statement for different keys.

In the project at hand:

| Player | Key        | Movement |
| ------ | ---------- | -------- |
| 1      | w          | up       |
| 1      | s          | down     |
| 2      | arrow up   | up       |
| 2      | arrow down | down     |
