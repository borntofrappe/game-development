# Bouncing Android

Recreate the flappy bird-like game provided on android devices running the lollipop version.

## Project structure

The game is developed in "main.lua". The script requires every other asset from the "src" folder, and benefits from the resources included in the "res" folder.

## Parallax

The buildings rendered above the background are included through three `.png` images. This is to ultimately move the assets at different speed and to give the illusion of depth. The images are designed with the `400x550` dimensions picked for the window.

## Object oriented programming

Instead of implementing OOP with tables and metatables — reder to "2 Player Pong" — the game uses the class library introduced in the course.

## Android movement

The android moves vertically as subject to gravity and a press through the mouse cursor. This movement is further complicated by a rotation, as the android leans toward the right side of the screen.

For the vertical movement, include a variable `dy`, and modify its value with the passage of time. Only at a second stage, update the `y` coordinate according to `dy` itself. The structrue allows to fake gravity by continuously increasing `dy`.

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
  android:update(dt)

  love.mouse.waspressed = false
end
```

For the rotation, the logic is repeated with two additional variables.

```lua
function Android:init(x, y)
  self.angle = 45
  self.dangle = -2
end
```

The rotation is then updated exactly like the vertical coordinate coordinate:

- update `dangle` according to the passage of time `dt` and user interaction in `love.mouse.waspressed`

- update `angle` with `dangle`

The only difference is that the angle is _clamped_ to a range, to avoid having the image turn in the opposite direction, and that the angle is also "hard" set to a minimum value as it bounces upwards. This to avoid having the android lean excessively downwards.

One key difference is how the value is ultimately used. While `y` is included in the second argument of `love.graphics.draw`, as is, the angle is specified in the third argument, but requires additional information. This is because the rotation occurs by default from the top left corner; additional arguments allow to modify this default by specifying an offset in both dimensions.

```lua
love.graphics.draw(x, y, rotation, scalex, scaley, offsetx, offsety)
```

## Collision detection

Detecting a collision is made slightly more challenging given the non-rectangular shape of the lollipops. However, knowing the structure of the image, and granting a more lenient detection, it is possible to find an approximate, satisfactory solution.

First off, it's necessary to reconsider the way the android is positioned rendered. By changing the offset value to have the image rotate from the center, it is possible to have `self.x` and `self.y` describe describe the exact center simply by using the input coordinates and the width/height of the sprite.

```lua
function Android:init(x, y)
  self.x = x
  self.y = y
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
end

function Android:render()
  love.graphics.draw(self.image, self.x, self.y, math.rad(self.angle), 1, 1, self.width / 2, self.height / 2)
end
```

Detecting a collision is a matter of expanding the approach introduced in the course. In the course, the lecturer describes the axis-alignment bounding box (AABB): if the character is before or after, if the character is above or below a rectangular shape, there is no collision. A similar test is repeated here as well, with a slight modification for the x-axis. For the y-axis, it's possible to use the coordinates and height of the lollipop as-is.

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

This AABB test takes care of the lollipop stick, but not of the circle making up the head of the lollipop. To this end, I use pythagoras' theorem from the center of this circle. The center is compared to two different coordinates depending on the position of the lollipop, considering once more what `android.x` and `android.y` represent:

- for the upper lollipop, consider the top right corner of the android: `(android.x + android.width / 2, android.y - android.width / 2)`

- for the lower lollipop, consider the middle point on the right side of the android: `(android.x + android.width / 2, android.y)`. This center right coordinate provides a more satisfactory solution than the bottom right corner, especially considering how the image leans consistently on its right side
