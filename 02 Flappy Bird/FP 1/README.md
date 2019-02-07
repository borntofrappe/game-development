# Flappy Bird 1 - Faux Scroll

Introduced with the _parallax update_, movement is created by offsetting the position of the images used in the project. By making the ground move toward the left, it is indeed possible to give the impression of a movement toward the right. By making the background move slower than the ground, then, it is also possible to give the appearance of increasing speed.

- create a variable to keep track of the offset (to have the images offset over time by this value, and have it increase over time).

```lua
backgroundOffset = 0
```

- create a variable to keep track of the speed of the scroll (to make the two offset occur at different rates).

```lua
-- all caps as the variable is meant to be constant
BACKGROUND_OFFSET_SPEED = 10
```

- create another variable which considers the size of the image, specifically the point at which the image is repeated. This is used to constantly give the impression of an infinite scroll, whilst using an image with a finite width.

```lua
-- all caps as the variable is meant to be constant
BACKGROUND_LOOPING_POINT = 413
```

In the `love.draw()` function you then se the offset variable in the x coordinate of the `love.graphics.draw()` function.

```lua
love.graphics.draw(background, backgroundOffset, 0)
```

And in the `love.update(dt)` function, which gets run at every frame, you increment this variable according to the speed, while resetting its value when the offset reaching the looping point.

```lua
function love.update(dt)
  backgroundOffset = backgroundOffset + BACKGROUND_OFFSET_SPEED * dt
  if backgroundOffset >= BACKGROUND_LOOPING_POINT
    backgroundOffset = 0
  end
end
```

Apparently the lecturer uses the modulo operator for the offset, finding the value as follows:

```lua
function love.update(dt)
  backgroundOffset = (backgroundOffset + BACKGROUND_OFFSET_SPEED * dt) % BACKGROUND_LOOPING_POINT
end
```

Both approaches seem to work, although this last one provides a rather more enticing snippet.