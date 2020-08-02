With this project I set out to take what I learned from _01 Pong_ and _02 Flappy Bird_ to replicate the flappy bird-like game provided on android devices running the lollipop version.

Keep in mind that the scripts depend on the resources found in the _res_ folder.

## Update 0

### Goal

Render the assets making up the background.

### Notes

The buildings included above the dark, starry sky are included through three `.png` images, and not only one. This is to ultimately move the assets at different speed for a parallax scroll.

To add the static assets:

1. load the graphic with `love.graphics.newImage()`, specifying the path of the image itself

2. render the image with `love.graphics.draw`, specifying the image and the coordinates of the top left corner

With regards to point #2, it is important to note how the images are all designed with the `400x550` dimensions picked for the window.

It is also important to stress the _order_ with which the buildings are rendered: the darker shapes, which are meant to be visually more distant, are drawn first, so to have the lighter shapes on top.

This covers much of the update, a static update if you will. The only interaction is included to have the window close when pressing the `escape` key.

```lua
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end
```

## Update 1

### Goal

Move the assets in the background at a different rate.

### Notes

The images are drawn with the same logic introduced in _02 Flappy Bird_, by having a variable describing the horizontal coordinate and a variable detailing how much to offset this coordinate within the game loop.

```lua
BUILDINGS_1_OFFSET = 0
BUILDINGS_1_SPEED = 20
```

Here I illustrate for the first building, but the logic is repeated for the other images as well, just with a different sped value.

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

### Goal

Define a table for the android. Render at the center of the screen.

### Notes

I used _table_ since Lua does not have a concept of class, but the idea is to use here object-oriented programming, and create a separate, independent entity in `Android.lua`.

I'll refer you to the official manual for [object-oriented programming](https://www.lua.org/pil/16.html), but the idea is to crate a table, `Android`, with the desired attributes and methods. Within an initialization function then, then idea is to then return a different table, which looks at `Android` for any value it does not have.

```lua
Android = {}

function Android:init()
  local android = {}

  -- set attributes

  setmetatable(android, {__index = self})
  return android
end
```

For instance, in the moment you define a `render` function.

```lua
function Android:render()
  love.graphics.draw(self.image, self.x, self.y)
end
```

Any instance generated through `Android:init()` will have access to the function by virtue of setting the metatable.

```lua
android = Android:init()
android:render()
```

One important note: I use `local` before initializing the table in the `Android:init` function. I found this necessary to avoid a potential conflict in the moment you create an instance with the same name.

```lua
function Android:init()
  local android = {}
  -- ...
end
```

## Update 3

### Goal

Have the android fall and bounce back following user interaction.

### Notes

The vertical movement of the android mirrors that of the bird in _02 Flappy Bird_. Include a variable `dy`, have the variable change with the passage of time and then update the `y` coordinate according to `dy` itself. This allows to fake gravity by continuously increasing `dy`

```lua
GRAVITY = 22

function Android:update(dt)
  self.dy = self.dy + GRAVITY * dt
  self.y = self.y + self.dy
end
```

Moreover, it allows to have the shape bounce back by setting `dy` equal to a negative value.

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

This covers the vertical movement of the android, but it's not all. In trying to be faithful to the original game, the image is also rotated as it moves up and down. The rotation is included with additional attributes in `Android.lua`.

```lua
function Android:init(x, y)
  local android = {}

  -- previous attributes
  android.angle = 45
  android.dangle = -2

  setmetatable(android, {__index = self})
  return android
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

### Goal

Add lollipops at an interval.

### Notes

Lollipops are created with an image _and_ with a rectangle shape. You can create an image tying both elements together, but this would complicate how you ultimately detect a collision with the android (for a later update).

To include multiple copies, `main.lua` mirrors the structure introduced in _02 Flappy Bird_:

- specify two variables `timer` and `interval`

- update `timer` with delta time `dt` and every time it crosses a prescribed threshold, reduce `interval`

- when `interval` hits `0`, create a new copy of the lollipop and reset the variables to the original values

The lollipop copies are stored in a table, updated and rendered through a loop.

```lua
lollipops = {}

function love.update(dt)
  for k, lollopop in pairs(lollipops) do
    lollopop:update(dt)
  end
end

function love.draw()
    for k, lollopop in pairs(lollipops) do
        lollopop:render()
    end
end
```

Moreover, the lollipops are removed from the table once they scroll to the left of the game window. Similarly to flappy bird, this is achieved through a boolean, which is toggled to `true` in `Lollipop.lua`, and when the coordinate is less than the established value.
