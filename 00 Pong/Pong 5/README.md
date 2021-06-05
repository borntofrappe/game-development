# Pong 5

_Please note:_ `main.lua` depends on `push.lua` and `font.ttf` being available in the same folder

## Clamping

Once the paddles are allowed to move following user input, you need to make sure their position doesn't exceed the boundaries of the window.

Lua provides `math.min` and `math.max` to clmap values to a lower and upper threshold. The idea is to assign to the coordinate the value following user interaction, or the threshold. For instance, to clamp the northbound paddle for `player1`, as the paddle reaches the top of the window (`y = 0`), assign a value of `0` to avoid having the paddle above the window (`y < 0`)

```lua
if love.keyboard.isDown('w') then
  player1Y = math.max(0, player1Y - PADDLE_SPEED * dt)
end
```

For the opposite direction, `math.min` allows instead to clamp the position to the height of the window. More specifically the height of the window minus the height of the paddle, since the coordinate describes the top left corner of the paddle.

```lua
if love.keyboard.isDown('s') then
  player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
end
```

`20` is here the height of the paddle, and ultimately a value which is better stored in a variable to avoid repeating a hard-coded number.

## Randomness

To avoid a predictable behavior, the code introduces randomness in the form or random integers and through the concept of seeds.

`math.random()` works with a variable number of arguments:

- without arguments, it returns a random float in the `[0, 1)` range

- with one positive integer `i`, it returns a random integer in the `[1, i]` range

- with twp positive integer `i` and `j`, it returns a random integer in the `[i, j]` range

`math.random()` produces a random number. However, the output is not completely random. It is based on a seed, a fixed value which means the function ultimately produces the same sequence of numbers. `math.randomseed()` is used to change this seed. By using a different seed every time, the script ensures that this sequence changes, and one way of describing a different seed is through the current time from the `os` module.

```lua
math.randomseed(os.time())
```

With this preface, the code makes use of `math.random` in a few instances.

1. assign one of two values to a variable.

   To move the ball either left or right, `math.random(2)` is equated to 1, and since it can only be `1` or `2`, `ballDX` is assigned one or the other value.

   ```lua
   ballDX = math.random(2) == 1 and 100 or -100
   ```

   The `and` and `or` keywords allow to specify the expression to be evaluated if the condition is true or false respectively.

2. assign a random value to a variable.

   This is perhaps the most conventional use case, but for the change in the vertical coordinate, the ball is assigned an integer in the `[-50, 50]` range

   ```lua
   ballDY = math.random(-50, 50)
   ```

## Ball movement

The script moves the ball by changing its `x` and `y` coordinate.

Initially, these variables describe the center of the window

```lua
function love.load()

  ballX = VIRTUAL_WIDTH / 2 - 3
  ballY = VIRTUAL_HEIGHT / 2 - 3
end
```

`-3` to offset for the size of the ball, `6`

```lua
function love.draw()
  love.graphics.rectangle('fill', ballX, ballY, 6 , 6)
end
```

In the `update(dt)` function then, the code considers the two previous random variables to modify the position of the ball, and ultimately where the ball is drawn.

```lua
function love.update(dt)
  ballX = ballX + ballDX * dt
  ballY = ballY + ballDY * dt
end
```

## Game state

The project introduces the concept of game state through a single variable.

```lua
gameState = 'waiting'
```

Initialized in the `load()` function, it describes different behaviors for the game. For instance, the movement of paddles, the movement of the ball can be conditioned to the string describing a value of `playing`.

```lua
if gameState == 'playing' then
  if love.keyboard.isDown('w') then
    player1Y = math.max(0, player1Y - PADDLE_SPEED * dt)
  end
end
```

In the `keypressed` function, the string is toggled between one of two values

```lua
function love.keypressed(key)
  if key == 'enter' or key == 'return' then
    if gameState == 'waiting' then
      gameState = 'playing'
    else
      gameState = 'waiting'
    end
  end
end
```

The variable is then used:

- in the `update` function to move the ball conditional to the string being `playing`

```lua
function update(dt)
  if gameState == 'playing' then
    ballX = ballX + ballDX * dt
    ballY = ballY + ballDY * dt
  end
end
```

- back in the `keypressed` function to re-initialize the ball as the string is toggled back to `waiting`

```lua
else
    gameState = 'waiting'

    ballX = VIRTUAL_WIDTH / 2 - 3
    ballY = VIRTUAL_HEIGHT / 2 - 3
    ballDX = math.random(2) == 1 and 100 or -100
    ballDY = math.random(-50, 50)
end
```

- in the `draw` function to render the string "Press enter to play" or "Press enter to stop" in the two different versions

```lua
if gameState == 'waiting' then
  love.graphics.printf(
    'Press enter to play',
    0,
    VIRTUAL_HEIGHT / 16,
    VIRTUAL_WIDTH,
    'center'
  )
else
  love.graphics.printf(
    'Press enter to stop',
    0,
    VIRTUAL_HEIGHT / 16,
    VIRTUAL_WIDTH,
    'center'
  )
end
```
