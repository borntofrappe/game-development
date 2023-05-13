# Flappy Bird 7

_Please note:_ `main.lua` depends on a few assets in the `res` folder:

- `push.lua` and `class.lua` in `res/lib`

- a series of images in `res/graphics`

## Update — y

In order to detect a collision between the bird and each of the pipes making up a pipe pair, it is first necessary to update the way the pipes are rendered.

This is something introduced in the course, which I failed to replicate out of convenience. Out of convenience, I rendered the pipes using the same `y` coordinate.

```lua
self.pipes = {
    upper = Pipe(self.x, self.y - GAP_HEIGHT, 'top'),
    lower = Pipe(self.x, self.y, 'bottom')
}
```

For the upper pipe, `self.y` describes the bottom, while for the lower pipe, it describes the top. This is efficient, but problematic once you need to detect a collision with a test using the axis aligned bounding box (AABB). With such a test, you need a reference to the same coordinates, for instance the top left corner.

For the upper pipe, it is necessary to include the height of the pipe.

```lua
self.pipes = {
    upper = Pipe(self.x, self.y - GAP_HEIGHT - PIPE_HEIGHT, 'top'),
    lower = Pipe(self.x, self.y, 'bottom')
}
```

In the render function for the individual pipe then, it is then necessary to use the height once more to position the pipe where desired.

```lua
function Pipe:render()
    love.graphics.draw(
        PIPE_IMAGE,
        self.x,
        self.origin == 'top' and self.y + self.height or self.y,
        0,
        1,
        self.origin == 'top' and -1 or 1
    )
end
```

Since the pipe is flipped, you need to first move the asset down.

## Update — width and height

In `PipePair`, it is useful to know the width and height of the pipe image. This is constant, so you can use variables at the top of the script (as done up to down).

```lua
PIPE_WIDTH = 70
PIPE_HEIGHT = 288
```

You can however pick up the value by using an instance of the `Pipe` class.

```lua
PIPE_WIDTH = Pipe().width
PIPE_HEIGHT = Pipe().height
```

## AABB Test

Once you have a uniform coordinate system, as thanks to the first update, the test checks the position of the bird against the position each pipe:

- if the bird before or after the pipe, there is no collision

  ```lua
  function Bird:collides(pipe)
      -- left | right
      if self.x + self.width < pipe.x or self.x > pipe.x + pipe.width then
          return false
      end

  end
  ```

- if the bird above or below the pipe, there is no collision

  ```lua
  function Bird:collides(pipe)
      -- left | right

      -- top | bottom
      if self.y + self.height < pipe.y or self.y > pipe.y + pipe.height then
          return false
      end

  end
  ```

- else, the two collide

  ```lua
  function Bird:collides(pipe)
      -- left | right

      -- top | bottom

      return true
  end
  ```

The course introduces a measure to detect a collision with more leeeway, but that's substantially it.

With this function, loop through the pipes in `love.update()`

```lua
function love.update(dt)
    for k, pipePair in pairs(pipePairs) do
        pipePair:update(dt)

        for l, pipe in pairs(pipePair.pipes) do
            if bird:collides(pipe) then
                -- collision
            end
        end
    end
end
```

## scrolling

Ultimately, the game will include several states, but to show the function in action, update the game assets following a boolean.

```lua
scrolling = true

function love.update(dt)
    if scrolling then
        -- update game assets
    end
end
```

Then flip the boolean to false when a collision is detected.

```lua
for l, pipe in pairs(pipePair.pipes) do
    if bird:collides(pipe) then
        scrolling = false
    end
end
```

## Update — scrolling

To try and continue testing the game I added an instruction following a keypress through the letter `"r"`.

```lua
if key == "r" then
    bird = Bird()
    pipePairs = {}
    scrolling = true
end
```
