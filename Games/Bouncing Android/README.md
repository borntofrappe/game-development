With this project I set out to take what I learned from _01 Pong_ and _02 Flappy Bird_ to replicate the flappy bird-like game provided on android devices running the lollipop version.

Keep in mind that the scripts depend on the resources found in the _res_ folder. I tried using the object-oriented approach explained in _programming in lua_, but ultimately decided to rely on the utility library that is `class.lua`. It is more convenient, and it is used thoroughly in the course.

## Update 0

Render the assets making up the background.

### Notes

The buildings included above the background are included through three `.png` images. This is to ultimately move the assets at different speed to give the illusion of depth.

To add the static assets:

1. load the graphic with `love.graphics.newImage()`, specifying the path of the image itself

2. render the image with `love.graphics.draw`, specifying the image and the coordinates of the top left corner

The images are designed with the `400x550` dimensions picked for the window.

## Update 1

Move the buildings in the background with different speed.

### Notes

Include a variable describing the horizontal coordinate and a variable detailing how much to offset the coordinate within the game loop.

```lua
BUILDINGS_1_OFFSET = 0
BUILDINGS_1_SPEED = 20
```

The logic is repeated for the other images as well, just with a different sped value.

With these variables, update the offset in `love.update(dt)`

```lua
function love.update(dt)
    BUILDINGS_1_OFFSET = (BUILDINGS_1_OFFSET + BUILDINGS_1_SPEED * dt) % BACKGROUND_WIDTH
end
```

Finally, use the variable in the `draw` function.

```lua
love.graphics.draw(buildings_1, -BUILDINGS_1_OFFSET, 20)
```

## Update 2

Introduce the android through a dedicated class.

## Update 3

Have the android fall and bounce back following user interaction.

### Notes

Include a variable `dy`, have the variable change with the passage of time and then update the `y` coordinate according to `dy` itself. This structrue allows to fake gravity by continuously increasing `dy`.

```lua
GRAVITY = 22

function Android:update(dt)
  self.dy = self.dy + GRAVITY * dt
  self.y = self.y + self.dy
end
```

Moreover, the structure allows to have the shape bounce back by setting `dy` equal to a negative value.

```lua
function Android:update(dt)
  if love.mouse.waspressed then
    self.dy = -9
  end
end
```

`waspressed` refers to a boolean introduced in `main.lua`, in order to know whether or not the mouse was pressed in the window in the separate file. The idea is to use the `love.mouse` module and add the boolean to the table.

```lua
function love.load()
  love.mouse.waspressed = false
end
```

When the mouse is pressed, you switched the boolean to `true`.

```lua
function love.mousepressed()
  love.mouse.waspressed = true
end
```

In the game loop then, you reset the variable to false, to avoid always registering the mouse press.

```lua
function love.update(dt)
  love.mouse.waspressed = false
end
```

This covers the vertical movement of the android, but the update adds another element in the rotation of the image.

```lua
function Android:init(x, y)
  self.angle = 45
  self.dangle = -2
end
```

The value is then updated exactly like the `y` coordinate:

- update `dangle` according to the passage of time `dt` or user interaction `love.mouse.waspressed`

- update `angle` with `dangle`

The only difference is that the angle is _clamped_ to a range, to avoid having the image turn in the opposite direction, and that the angle is also "hard" set to a minimum value as it bounces upwards. This to avoid having the android lean excessively downwards.

One essential note however: once the angle is considered through the mentioned attributes, it is necessary to actually rotate the image. This is possible knowing that `love.graphics.draw` accepts additional arguments, among which the rotation (in radians).

```lua
love.graphics.draw(x, y, rotation)
```

By default, te rotation occurs from the top left corner, but you can specify different coordinates once again specifying additional arguments.

```lua
love.graphics.draw(x, y, rotation, scalex, scaley, offsetx, offsety)
```

`offsetx` and `offsety` allow to pick and choose the center of the image.

## Update 4

Add lollipops at an interval.

## Update 5

Include lollipops in pairs.

### Notes

`LollipopPair` needs to know about the width and height of the single sprite. To this end, the script initializes a throw-away table to pick the measures from the `Lollipop` file.

## Update 6

Add randomness in the design of the game.

### Notes

Two random elements are imported from _02 Flappy Bird_, and relate to have a random gap between the individual lollolipops as well as a random interval for their appearance.

Beside these elements, the idea is to add variety also in the design of the individual lollipops. To this end, the _res_ folder is equipped with additional `lollipop-*` images. The images are loaded in `main.lua`

```lua
function love.load()
  lollipop_images = {
    love.graphics.newImage('res/lollipop-1.png'),
    love.graphics.newImage('res/lollipop-2.png'),
    love.graphics.newImage('res/lollipop-3.png'),
    love.graphics.newImage('res/lollipop-4.png')
  }
end
```

And an image at random is picked when a pair is initialized.

```lua
table.insert(lollipopPairs, LollipopPair(lollipop_images[math.random(#lollipop_images)]))
```

## Update 7

Manage the state through a state machine.

### Notes

The approach of a global state machine managing different states is taken directly from the course. It is extremely convenient to have a dedicated file in which to update and render the assets for each specific situation. In the title screen, show `title.png`. In the play state, show and scroll the buildings, show and move the android, the lollipops.
