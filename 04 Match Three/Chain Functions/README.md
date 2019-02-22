# Chaining

Chaining is a concept tightly connected to time-based events, and relates to how changes are introduced one after the other, as if on a schedule.

## Previous Approach - previous.lua

Without using any external library we can move a shape around the screen as follows:

- create a table describing the various points on the screen where the shape should go. The idea is to have each successive value be the reference point in the shape's movement;

  ```lua
  destinations = {
    [1] = {
      x = VIRTUAL_WIDTH - 25,
      y = 0
    },
    [2] = {
      x = VIRTUAL_WIDTH - 25,
      y = VIRTUAL_HEIGHT - 25
    },
    [3] = {
      x = 0,
      y = VIRTUAL_HEIGHT - 25
    },
    [4] = {
      x = 0,
      y = 0
    }
  }
  ```

- to each 'destination' add a boolean determining whether the destination has been reached. This flag could be added in the declaration, but it is included through a for loop.

  ```lua
  for k, destination in pairs(destinations) do
    destination.reached = false
  end
  ```

  The idea is to use this flag as to animate the shape one set of coordinates at a time, progressively moving it from point to point.

- in the `update(dt)` function move the shape on the basis of conditional statements, in a loop.

  ```lua
  -- update the timer clamping its value to the constant value
  timer = math.min(timer + dt, TIMER_MAX)

  -- loop through the table of destinations
  for k, destination in ipairs(destinations) do
    -- for the destination which is not reached move the shape toward the specified coordinates
    if not destination.reached then
      --[[
        MOVEMENT HERE
      ]]
    end
    -- terminate the loop to avoid running the same logic on two destinations
    break

  end
  ```

  In the if statement targeting the desired set of coordinates, the position of the shape is updated using `baseX` and `baseY`. These become essential as to determine the starting point of the shape, and let the shape move in any of the four directions.

```lua
if not destination.reached then
  -- update the position of the shape starting from (baseX, baseY) and progressively reaching (destination.x, destination.y)
  shapeX, shapeY =
      baseX + (destination.x - baseX) * timer / TIMER_MAX,
      baseY + (destination.y - baseY) * timer / TIMER_MAX
end
```

Always in the if statement, and when reaching the end of the defined timeframe (when `timer` reaches the constant `TIMER_MAX`), it is sthen necessary to reset the timer, update `baseX` and `baseY` and switch the boolean to true. This guarantees that on the following iteration the shape will move from the acquired coordinates toward the following point in the table.

```lua
if not destination.reached then
  -- update the position of the shape starting from (baseX, baseY) and progressively reaching (destination.x, destination.y)
  shapeX, shapeY =
      baseX + (destination.x - baseX) * timer / TIMER_MAX,
      baseY + (destination.y - baseY) * timer / TIMER_MAX

    -- when reaching the end of the transition reset the timer and make it so that the shape starts from the acquired coordinates and goes toward the following point
    if timer == TIMER_MAX then
      timer = 0
      destination.reached = true
      baseX, baseY = destination.x, destination.y
  end

end
```

This solution works, but it becomes evident that there are a lot of variables to track and update. Just like for the intervals introduced in the **Time Based Events** folder, it becomes much easier (and more declarative in nature) to use a library like `knife`, which rapidly allows to chain events through the `finish` function.

### Lua Detour

When looping through the table of destinations the application makes use of `ipairs` instead of `pairs`. This has to do with the data structure chosen for the destinations, an aspect of **lua** more than **love2d**. The concept is still unclear to me, but as described online, [like here](http://www.luafaq.org/#T1.10) `ipairs` should be used when the order of a table matters.

It seems that `pairs` doesn't guarantee that the loop will go through an indexed table in order. In light of this:

- in the `update` function we want to go through the table in order, so we use `ipairs`.

- in the `load` function we want to include the `reached` key irrespective of order, so both solutions work.
