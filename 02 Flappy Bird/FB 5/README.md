# Flappy Bird 5 - Pipes

For the pipes we need:

- sprite;

- a way to determine the gap between pipes;

- a way to re-use resources to avoid abuses on memory.

Continuing with the logic introduced with the bird class, creating a `Pipe` class allows to effectively manage the pipes' own logic into its own file.

## Pipe Class

In the `Pipe.lua` file, instead of referencing the image into the instance of the class (in the `:init` function), it is better to create a local variable.

```lua
local PIPE_IMAGE = love.graphics.newImage('Resources/pipe.png')
```

Alongside this variable, and in the outer scope of the file, also initialize a variable to keep track of the horizontall offset (as to fake scroll, exactly like for the background and ground images).

Create a pipe class with the following attributes:

```lua
local PIPE_SCROLL = -20
```

For the class, the `init()` function ought to declare the following fields:

- x; pushing the image past the right edge of the screen;

- y: a random value

  Remember to include a random seed at the top of the `main.lua` function, to truly randomize the retrieved value.

  ```lua
  -- in the load function
  math.randomseed(os.time())
  ```

- width; according to the width of the image and as per `:getWidth()`

In the `update(dt)` function update the horizontal position according to delta time and the scroll variable.

In the `render()` function finally draw the image (using the `love.graphics.draw()` function, specifying the image and the coordinates).

## Main.lua

In `main.lua`, after requiring the `Pipe` class (just like the `Bird` counterpart), create a table for the pipes plural.

```lua
local pipes = {}
```

This variable will be used to store a reference to each pipe rendered on the screen.

As the pipes are introduced through time, you also need a variable keeping track of this value.

```lua
local timer = 0
```

You can update this variable with the `dt` value, cognizant of the fact that 60 is the rough measure at which a second has passed.

In the update function literally update the timer to add delta time and then check an arbitrary threshold at which to add a pipe. To add an item in a table use the `table.insert()` function, accepting as argument the table and the item to be added.

```lua
function love.update(dt)
  -- background, ground, bird logic

  timer = timer + dt
  if timer % 2 == 0 then
    table.insert(pipes, Pipe())
  end

end
```

Each pipe is added through the class, specifying the random coordinates and the image asset.

Small note: instead of using module, and perhaps as to avoid a timer variable which incrementally gets bigger, the timer is reset to 0 when reaching the arbitrary 2s mark.

```lua
function love.update(dt)
  -- background, ground, bird logic

  timer = timer + dt
  if timer > 2) then
    table.insert(pipes, Pipe())
    timer = 0
  end

end
```

This allows to include in the table the desired objects. To actually render the objects nested in the table you can leverage a loop. A loop which has the following rough syntax:

```text
for key, value in pairs(table) do
  -- something
end
```

The `pairs` function comes with lua and allows to identify the couplets of field-values of an object.

```lua
-- loop through the table of pipes and update each asset
for key, pipe in pairs(pipes) do
  pipe:update(dt) -- ! remember to add dt
end
```

This accounts for the pipes being included. To remove them, you can use the `table.remove()` function and pass as argument the table from which to remove and the key identifying the specific item. Remove them as the 'disappear' to the left, as they overshoot pas the left edge of the screen. This way you can reduce the weight carried by the table.

```lua
-- remove the pipes no longer on scree, because going past the left edge
if pipe.x < 0 - pipe.width then
  table.remove(pipes, key)
end
```

Given the fact that the function leverages the `key` value, include it in the `for... in... do` loop.

Finally, you can actually highlight the graphic through the `render` function. Just remember to have the correct order (background -> pipe -> ground -> bird).
