# Pong 4

Index:

- [Randomness](#randomness)

- [Clamping](#clamping)

- [Game State](#game-state)

Snippet:

- main.lua

## Randomness

To avoid a predictable behavior, the project introduces randomness in the form or random integers and through the concept of seeds.

`math.randomseed()` provides a seed which is 'fed' to `math.random` functions to create random values. It accepts as argument a value which generates a seed, which is set to be the time currently being registered by the OS. This is an every changing value, costantly being updated on the basis of the internal clock. This allows to base the seed on a value which rarely if ever gets repeated.

Based on this random seed, `math.random` provides a random value. This function accept a variable number of arguments, as specified in the docs:

- with no argument, it provides a random value in the [0-1] range;

- with one argument, it provides a random value in the [0, max] range, where max is exactly the processed argument;

- with two arguments, it provides a random value in the [min, max] range, where the two arguments make up the minimum and maximum.

In the actual project, the code makes use of `math.random` with one and two values. In the first instance, it accompanies the expression with a _ternary operator_, to assign a variable a value between to possibilities.

The horizontal direction is indeed determined to be either 100 or -100, based on randomness (the condition evaluates to true half of the times).

```lua
ballDX = math.random(2) == 1 and 100 or -100
```

The syntax above might look a bit more contrived than a JavaScript ternary operator.

```js
ballDX = Math.random() > 5 ? 100 : -100;
```

But I guess it's just a matter of getting used to it.

The ternary operator in lua can be summed up as follows:

```lua
variable = condition and ifTrue or ifFalse
```

The `and` and `or` keywords allow to specify the expression to be evaluated if the condition is true or false respectively.

That's how the project used `math.random` with one argument. With two arguments, the project creates instead a random value in the [-50,50] range:

```lua
ballDY = math.random(-50, 50)
```

This for the vertical direction.

Direction would actually be a misnomer on my part though. It is actually the value which is latter added to the coordinate of the ball to make it move across the screen. In this sense it is closer to the horizontal and vertical speed.

## Clamping

An issue with the previous update concerned the movement of the paddles once said paddles would reach the upper and lower edge of the screen. Without additional consideration, the paddles can and indeed go past the boundaries of the window, which is something the game should not allow.

To fix this problem, the code makes use of the `math.min` and `math.max` function. It is actually a clever use, so spelling it out ought to make it more memorable.

Simply put, instead of checking the position of the paddles and avoiding any movement if it reaches the boundaries, the coordinate of the paddles is updated to be that specified by the movement only if that coordinate is within the prescribed limits. Otherwise, the `math` function clamps the coordinate to be 0 or, for the lower edge, the height of the window minus the height of the paddle (this subtraction to guarantee that the paddle is always and completely above the fold).

```lua
-- when pressing w (or up for the second player) calmp the vertical coordinate to 0
player1Y = math.max(0, player1Y - PADDLE_SPEED * dt)
```

## Game State

As the game stands, the ball can be made moving without need for further input. It quickly moves outside of the window's scope and without detection of any collision, but those are issues for a later update.

As it relatess to the concept of game state, the project introduces it with a variable determining whether the game is ongoing or not.

This variable is initialied in the `load` function.

```lua
gameState = 'waiting'
```

It is then updated on the basis of a key event being registered on the _enter_ key.

```lua
if key == 'enter' then
  if gameState == 'waiting' then
    gameState = 'playing'
  else
    gameState = 'waiting'
  end
end
```

It is then and most importantly used in the `update` function, to move the ball only when the game state is set to the prescribed value of 'playing'.

```lua
if gameState == 'playing' then
  ballX = ballX + ballDX * dt
  ballY = ballY + ballDY * dt
end
```

Such a variable can indeed regulate the state of the game, and allows to transition between different states. It also allows, with a simple conditional statement, to draw different elements on the screen, as in the `draw` function.

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
