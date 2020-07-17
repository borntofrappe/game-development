A game of pong ultimately meant to replicate a mobile interface and touch-based input.

The paddles are created as semicircles and positioned at either end of the screen. The movement occurs by touching the left or right half of each respective panel.

## Development

Following the structure described in the course, the game is developed in increments.

### Update 0 – drawing

In the first update the goal is to draw the elements of the game. There are essentially three drawing functions in the `love.draw()` method:

- `love.graphics.circle(style, cx, cy, r)`

- `love.graphics.line(x0, y0, x1, y1, ..., xn, yn)`

- `love.graphics.arc(style, cx, cy, r, startAngle, endAngle)`

For the arc, the start and end angles are specified in radians. Use the `math` module to consider the value of PI, so to draw the two different semicircles.

With regards to other functions:

- `love.graphics.clear(color)` describes the background

- `love.graphics.setLineWidth(width)` changes the width of the stroke

- `love.graphics.setColor(color)` sets the color

The color is specified with a list of 4 values: `red, green, blue, alpha)`. Once set with the `setColor` function, it is applied to every drawing function which follows. This explains the repetition of the function, for instance to have the circle at the center of the screen semi-transparent, without compromising the opacity of the other elements.

```lua
love.graphics.setColor(1, 1, 1, 0.15)
love.graphics.circle('fill', WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 42)
love.graphics.setColor(1, 1, 1, 1)
```

### Update 1 – class

Without adding any functionality, the update refactors the code to have two additional files: `Ball.lua` and `Paddle.lua`. The goal is to draw the elements using object-oriented programming, and without using the `class.lua` script introduced in the course.

I'll describe the logic for the `Ball`, but the same structure is repeated for the paddles, except for minor modifications. Refer to [programming with lua](https://www.lua.org/pil/contents.html) and the [object-oriented programming section](https://www.lua.org/pil/16.html) for more information.

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

### Update 3 – paddle movement

In `main.lua`, you can move the paddles using keys, similarly to the game developed in the course. This using the `love.keyboard.isDown` function, as highlighted in the following snippet for one of the two paddles:

```lua
function love.update(dt)
    if love.keyboard.isDown('left') then
        player1.dx = PADDLE_SPEED * -1
    elseif love.keyboard.isDown('right') then
        player1.dx = PADDLE_SPEED
    else
        player1.dx = 0
    end
end
```

However, in this particular game, the goal is to move the paddles by pressing the screen on the left or right side of each half. To consider a press of the mouse, love2d provides `love.mousepressed()`; this function is fired as the mouse clicks on the screen, and describes a series of informative values like the coordinates of the point being pressed.

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

#### mouse v touch

love2d provides [touch functions](https://love2d.org/wiki/love.touch), which means that more research is warranted to actually support mobile devices.

```lua
function love.mousereleased()
    player1.dx = 0
    player2.dx = 0
end
```