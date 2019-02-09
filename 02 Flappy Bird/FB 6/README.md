# Flappy Bird 6 - Pipes Plural

The game currently presents a series of pipes only in one direction, but it is necessary to pair each single pipe with an opposite tube, and allocate between the two enough height as to let a 'jumping' bird go through. It is also necessary to detect a collision, but it is for a later update.

A class of `PipePair` is created for this update to accompany each pipe with another pipe.

## main.lua

- beside importing a new class, in the mentioned `PipePair`, initialize a variable to keep track of these couplets of pipes, in `pipePairs`. This updates the previous `pipes`.

  ```lua
  local pipePairs = {}
  ```

  Remembeer to require both classes of `Pipe` and `PipePair` though. This is essential because ultimately `PipePair` represents a composite object, made up of two instances of `Pipe`. Therefore, you need the logic distilled in both.

- initialize a variable to keep track of the vertical position of the last pipe. With pipes that are randomly positioned, there's indeed a risk to design a level impossible to go through, with pipes at disparate altitudes. This variable allows to accomodate for a trend, with pipes positioned randomly, but within an acceptable range.

  ```lua
  -- subtract the height of the pipe, as the pipe is later flipped upside down, to effectively reference the top of the screen
  -- math.random(80) + 20 then references a distance from the top
  local lastY = -PIPE_HEIGHT + math.random(80) + 20
  ```

- in the `update()` function and specifically when a pipe needs to be introduced, introduce the pipes considering the described `lastY`

  ```lua
  if timerPipes > intervalPipes then
    -- define the vertical coordinate by clamping the value in a selected range
    -- ! to each value the negative - PIPE_HEIGHT is included because the asset is ultimately flipped upside down
    -- think of -PIPE_HEIGHT + 10 as 10 from the top
    -- clamp between 10 from the top and the smaller between [-20,20] around the previous coordinate and an arbitrary value from the top (equal to the height - 90)
    local y = math.max(-PIPE_HEIGHT + 10, math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))

    -- update lastY with the current value
    lastY = y
  end
  ```

- always in the update function and again in the conditional described above, insert an instance of the class in the table and reset the timer (as earlier, but for `pipePairs`).

  ```lua
  table.insert(pipePairs, PipePair(y))
  ```

Evidently, the `PipePair` class is defined to be initialized with a `y` value (which makes sense as this is defined in the update function just described). It seems the idea of the lecturer is to actually take this value and think of it as the beginning of the gap. With this in mind, a sprite is positioned upside down and ending at this value, while another sprite is positioned up to 90px below.

- use `pipePairs` in the loop updating (and possible removing) the pipes. For this last action, it seems the code is a bit modified. The removal takes place if the `pair` item (item of te `pipePairs` table) has a field of `remove` set to true. Evidently, in the `PipePair:update` function there exist a conditional which flips this value to true when the object goes to the left of the screen. and remove loops.

- update the `render` function to use the new class.

  ```lua
  for key, pair in pairs(pipePairs) do
    pair:render()
  end
  ```

## PipePair.lua

For the new class, this is meant to be a composite entity, composite of two instances of the `Pipe` class. The movement previously defined in `Pipe:update` is migrated to this class, meaning that `PipePair:update()` now fulfills the horizontal movements and `Pipe` doesn't need an update function anymore. This last one is indeed more of a rendering class, if you can call it that. Its job is render the pipe on the screen at coordinates which are specified by the `PipePair` class which calls it. Twice.

For the lua file:

- add local variable to describe the gap between pipes.

- in the `init()` function, instantiate the class with:

  - `x`;

  - `y`, initialized through the init function itself (as per the instructions passed in `main.lua`);

  - `pipes`, a table nesting two instances of the `Pipe` class, specified according to their orientation (a string between two possible values) and their vertical coordinate (which mirrors the `y` value).

  - `remove`, a boolean which describes whether the pair is meant to be removed (passed to the left of the screen).

    `pipes` warrants a bit more attention since it provide the key to the update.

    In the table, specify two fields for the `upper` and `lower` pipes. Assign to these fields an instance of the `Pipe` class.

    ```lua
    self.pipes = {
      -- where the 'flipped' pipe ought to begin
      -- it therefore ends at self.y + PIPE_HEIGHT, where the gap begins
      ['upper'] = Pipe('top', self.y),
      -- where the 'unflipped' pipe ought to begin
      -- ending below the bottom edge of the screen, but starting exactly after the top pipe by a measure specified by the gap height
      ['bottom'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }
    ```

    It will likely be more evident in `Pipe.lua`, but the class is initialized with a string, which possibly positions the sprite (or flips it atop the screen) and a vertical coordinate, which possibly describes where the pipe should start.

- in the `update(dt)` function, include the functionality previously described in the individual `Pipe` class, just considering the horizontal offset for two instances.

  ```lua
  if self.x > 0 - PIPE_WIDTH then
    -- if still on screen, update the position of the pair
    self.x = self.x - PIPE_SPEED * dt
    -- apply the coordiante to both instances of the pipe class
    self.pipes['lower'].x = self.x
    self.pipes['upper'].x = self.x
  else
    -- else set the remove flag to true
    self.remove = true
  end
  ```

- in the `render` function loop through the table of pipes and render the individual pipes through the `pipe:render()` function.

  ```lua
  for key, pipe in pairs(self.pipes) do
    pipe:render()
  end
  ```

## Pipe.lua

The `Pipe` class gets initiated with a string for the orientation and a value for the vertical coordinate.

Set the `y` value to this new argument value, and `orientation` for the first string.

The `render()` function is where orientation gets used. The idea is to give a sclae of `-1` to the sprite, effectively creating a mirror image. This is the sixth argument of the `draw()` function, which accepts:

- drawable,

- horizontal coordinate,

- vertical coordinate

- rotation,

- horizontal scale,

- vertical scale.

As the sprite is mirrored, you need to offset the vertical coordinate for the height of the pipe.

```lua
love.graphics.draw(PIPE_IMAGE, self.x,
  -- ternary operator, accounting for the vertical scale later modified for the 'top' value
  self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y,
  0,
  1,
  -- scale the pipe upside down if orientation is set to 'top'
  self.orientation == 'top' and -1 or 1
)
```

Think of the flip as occurring as follows:

```text
  |  |
  |  |
  |  |
  |-1|
  |__|

---------
   __
  |  |
  |  |
  |  |
  |+1|
  |  |
```

Rough, but it gives an idea. Especially as it relates to the offset given to the pipe when flipped.
