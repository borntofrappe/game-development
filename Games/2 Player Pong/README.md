# 2 Player Pong

Recreate the game pong with a mobile interface and touch-based input.

## Project structure

The game is developed in "main.lua", and is further divvied up in "Ball.lua" and "Paddle.lua". These two describe the behavior of the ball and paddles respectively.

## Object oriented programming

Unlike the games developed in the course, the project does not use a library to implement classes. Object-oriented programming is instead implemented following the example provided in [programming with lua](https://www.lua.org/pil/contents.html) and the [object-oriented programming section](https://www.lua.org/pil/16.html) in particular. I'll describe the logic for the `Ball`, but the same structure is repeated for the paddles. What changes is the actual implementation of the of the entity.

### Tables

In lua you don't have a concept of classes, or objects. That being said, you can create a similar construct with the only data structure it provides: tables. Tables and metatables to be precise.

A table is a data structure of key value pairs.

```lua
hero = {}

hero.name = 'timothy'
hero.age = 28
```

A metatable is a table to which you reference, to which you link from another table.

```lua
Character = {}
Character.hp = 10

Character.__index = hero
setmetatable(Character, hero)
```

If you run the previous two snippet, for instance on [lua's own website](https://www.lua.org/demo.html), you have a situation in which `hero` has access to three keys: `name` and `age`, as expected, but also `hp`

```lua
print(hero.name) -- 'timothy'
print(hero.hp) -- 10
```

This because lua effectively goes through the following:

- look for the `hero` table

- look for the `hp` key, which is not available

- look for the `hp` key in the table it points to, `Character`

- return `Character.hp`

In this fashion you can replicate the construct of a class, like `Character`, and objects, instances of the class, like `hero`.

The code in `Ball.lua` and `Paddle.lua` is more complex, but it fundamentally repeats the logic described in this section. The only difference is that the process of creating the "instance" tables, so to speak, is automated in a `:init` function.

```lua
Ball = {}

function Ball:init(cx, cy, r)
    ball = {}

    ball.cx = cx
    ball.cy = cy
    ball.r = r

    self.__index = self
    setmetatable(ball, self)

    return ball
end
```

From this starting point, any attribute, any function included in the `Ball` table is made available to `ball`, the table returned by the `:init` function.

```lua
function love.load()
    ball = Ball:init(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 3)
end
```

## Input

The goal is to move the paddles by pressing the screen on the left or right side of each half. To consider a press of the mouse, love2d provides `love.mousepressed()`. The function is fired as a mouse clicks is registered on the screen, and provides a series of informative values like the coordinates of the point being pressed.

```lua
function love.mousepressed(x, y)

end
```

With this in mind, moving the paddle is a matter of using if statements to consider the half which describes the player, and the half which describes the direction. For instance and for one of the two paddles (the one in the top half)

```lua
if y < WINDOW_HEIGHT / 2 then
    if x > WINDOW_WIDTH / 2 then
        player1.dx = PADDLE_SPEED
    else
        player1.dx = -PADDLE_SPEED
    end
end
```

Now, you can include the logic for the second paddle in an `else` statement, considering the fact that the press is either on the top or bottom half.

```lua
if y < WINDOW_HEIGHT / 2 then
    -- player1 logic
else
    if x > WINDOW_WIDTH / 2 then
        player2.dx = PADDLE_SPEED
    else
        player2.dx = -PADDLE_SPEED
    end
end
```

**A word of caution**: depending on how Love2D registers touch events, the `if .. else` construct might lead to the unwanted result of moving one paddle at a time, and having one paddle override the movement of the opposite one.

## State

State is considered with a string variable, initialized in the `love.load()` function.

```lua
function love.load()
    gameState = 'waiting'
end
```

This variable stores one of three values: waiting, serving or playing. The interplay between the three is explained as follows:

- begin with a value of `waiting`

- when both players are ready to play, move from waiting to `serving`

- at the end of a countdown, move from `serving` to `playing`

- when the ball crosses the top/bottom of the window, return to `waiting`

To signal that the players are ready, the paddles specify an additional attribute.

```lua
function Paddle:init(cx, cy, r)
    -- previous attributes

    paddle.is_ready = false
end
```

When a press is registered on the corresponding half then, the boolean is flipped to `true`.

To count down from an arbitrary number, two additional variables are included in `love.load()`: `timer` and `countdown`

```lua
function love.load()
    countdown = 3
    timer = 0
end
```

In `love.update(dt)` then, `timer` is incremented with the value of `dt`, and every time it crosses a second, it reduces `countdown` by 1.

```lua
function love.update(dt)
    if gameState == 'serving' then
        timer = timer + dt
        if timer > 1 then
            timer = 0
            countdown = countdown - 1
        end
    end
end
```

When `countdown` reaches zero finally, the state is switched automatically to `playing`, while the variable are reset to their initial value.

```lua
function love.update(dt)
    if gameState == 'serving' then
        timer = timer + dt
        if timer > 1 then
            timer = 0
            countdown = countdown - 1
        end

        if countdown == 0 then
            gameState = 'playing'
            timer = 0
            countdown = 3
        end
    end
end
```

One refinement which comes from a later lecture in the course: instead of resetting timer to zero once it crosses the arbitrary threshold, use the remainder operator.

```lua
timer = timer % 1
```

In this manner you consider the excess at the next iteration.

Instead of using a hard-coded value, also prefer to specify a variable for the threshold.

```lua
if timer > COUNTDOWN_TIME then
    timer = 0
    countdown = countdown - COUNTDOWN_TIME
end
```

This way you can speed up/slow down the countdown by using a value less than/more than 1.

## Scoring system

Instead of keeping track of the number of points and establish a victory when one of the two players reaches an arbitrary number, the idea is to play with the size and speed of the two paddles. With each point, the paddle becomes smaller and slower. A victory is detected when the size is ultimately reduced to `0`.

Since a player can win, it is also necessary to add anther state: `victory`. In this state, only the losing player is shown, while the winning side display a message celebrating the victory.
