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

## Update 8

Add the score in the top left corner of the play state, and the score state when the android hits the bottom of the screen.

### Notes

I specifically mentioned the bottom of the screen as the game is not capable, with the current update, to detect a collision between android and lollipops.

It is interesting to point out that the `:render` functions of the play and score state are one and the same. The difference between the two states boils down to how the play state updates the buildings/android/lollipops to actually move.

## Update 9

Detect a collision between the android and the lollipops.

### Notes

Detecting a collision is made slightly more challenging given the non-rectangular shape of the lollipops. However, knowing the structure of the image, and granting a more lenient detection, it is possible to find an approximate, satisfactory solution.

First off, it's necessary to reconsider the way the android is positioned rendered. By changing the offset value to have the image rotate from the center, it is possible to have `self.x` and `self.y` describe describe the exact center simply by using the input coordinates of `VIRTUAL_WIDTH / 2` and `VIRTUAL_HEIGHT / 2`

```lua
function Android:init(x, y)
  self.x = x
  self.y = y
end

function Android:render()
  love.graphics.draw(self.image, self.x, self.y, math.rad(self.angle), 1, 1, self.width / 2, self.height / 2)
end
```

In previous updates, I had the coordinates off because I figured the offset would impact only the rotation, and not from where the image would be drawn. By using the offset of `self.width / 2` and `self.height / 2`, the image is already drawn from the center.

I came to this realization by drawing a circle atop the image. A visual way to debug the code, if you will.

```lua
function Android:render()
  love.graphics.circle('fill', self.x, self.y, 5)
end
```

With this modification, detecting a collision is a matter of expanding the approach introduced in the course. In the course, the lecturer describes the axis-alignment bounding box (AABB): if the character is before or after, if the character is above or below a rectangular shape, there is no collision. A similar test is repeated here as well, with a slight modification for the x-axis. For the y-axis, it's possible to use the coordinates and height of the lollipop as-is.

```lua
function Android:collides(lollipop)
  if self.y < lollipop.y or self.y > lollipop.y + lollipop.height then
    return false
  end
end
```

For the x-axis, however, add _padding_, extra space before the collision is actually detected.

```lua
function Android:collides(lollipop)
  if self.x < lollipop.x + PADDING or self.x > lollipop.x + lollipop.width - PADDING then
    return false
  end

  -- y-axis
end
```

This is because the rectangle making up the lollipop stick is actually thinner than the full image. How much padding depends on the thickness of this rectangle, and also the position of `self.x`. Remember that `android.x` indicates the center of the image making up the android.

This AABB test takes care of the lollipop stick, but not of the circle making up the head of the lollipop. To this end, I use pytagora's theorem against the center of this circle. The center is compared to two different coordinates depending on the position of the lollipop, considering once more what `android.x` and `android.y` represent:

- for the upper lollipop, consider the top right corner of the android: `(android.x + android.width / 2, android.y - android.width / 2)`

- for the lower lollipop, consider the middle point on the right side of the android: `(android.x + android.width / 2, android.y)`. This center right coordinate provides a more satisfactory solution than the bottom right corner, especially considering how the image leans consistently on its right side
