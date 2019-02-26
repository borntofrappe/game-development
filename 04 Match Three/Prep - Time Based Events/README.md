# Time Based Events

## Previous Approach - previous.lua

So far we have leveraged `dt` to influence the speed of the ball, paddle or any other time-based event. You have a variable keeping track of the state and you modify said value in the `update()` function, using the `dt` argument to have the frame per second influence the change in state.

To show a timer for instance:

- include `currentSecond` and `secondTimer` in the `load()` function.

  ```lua
  currentSecond = 0
  secondTimer = 0
  ```

  The former is used to enumerate the timer, whilst the second identifies the passing of time, rounding down any excess to 1 second. Lua indeed doesn't differentiate between integer and floats, and there needs to be a way to include only integers.

- in the `update(dt)` function increase the value of `secondTimer` by `dt` and when this value goes past 1 (second) update `currentSecond` whilst at the same time removing any excess time from `secondTimer`.

  ```lua
  function love.update(dt)
    secondTimer = secondTimer + dt
    if secondTimer > 1 then
      currentSecond = currentSecond + 1
      secondTimer = secondTimer % 1
    end
  end
  ```

- in the `draw()` function render the variable with the `printf` function.

Here's the problem with this approach: when you need to create multiple instances of the timer, with 2 variables for each instance, to keep track of `dt` and to update the actual value. This is not a scalable solution.

## Previous Approach's Issues - problematic.lua

To highlight the issues with the previous approach, multiple timers are setup in `problematic.lua`. As mentioned, for each single timer there needs to be a set of variables and updating logic.

```lua
-- first timer
-- updated every second
currentSecond1 = 0
secondTimer1 = 0
-- second timer
-- updated every 2 second
currentSecond2 = 0
secondTimer2 = 0
-- third timer
-- updated every 3 second
currentSecond3 = 0
secondTimer3 = 0

-- in the update function
function love.update(dt)
  secondTimer1 = secondTimer1 + dt
  if secondTimer1 > 1 then
    currentSecond1 = currentSecond1 + 1
    secondTimer1 = secondTimer1 % 1
  end


  secondTimer2 = secondTimer2 + dt
  if secondTimer2 > 2 then
    currentSecond2 = currentSecond2 + 1
    secondTimer2 = secondTimer2 % 1
  end

  secondTimer3 = secondTimer3 + dt
  if secondTimer3 > 3 then
    currentSecond3 = currentSecond3 + 1
    secondTimer3 = secondTimer3 % 1
  end

end

function love.draw()
  love.graphics.setColor(1,1,1,1)
  love.graphics.setFont(gFonts['big'])
  love.graphics.printf(
    'Timer 1: ' .. tostring(currentSecond1),
    0,
    VIRTUAL_HEIGHT / 4 - 16,
    VIRTUAL_WIDTH,
    'center'
  )
  love.graphics.printf(
    'Timer 2: ' .. tostring(currentSecond2),
    0,
    VIRTUAL_HEIGHT / 2 - 16,
    VIRTUAL_WIDTH,
    'center'
  )
  love.graphics.printf(
    'Timer 3: ' .. tostring(currentSecond3),
    0,
    VIRTUAL_HEIGHT * 3 / 4 - 16,
    VIRTUAL_WIDTH,
    'center'
  )
end
```

## New Approach - main.lua

Using the `knife` library and an anonymous function, it is possible to implement a more efficient solution by referencing a timer object.

Instead of initializing and updating multiple variables, it is possible to centralize the logic in a `Timer` object.

Start by requiring [knife timer](https://github.com/airstruck/knife/blob/master/knife/timer.lua). From here, the two main functions used in the game are:

- `Timer.after`

  Takes as argument `delay` as well as a `callback` function. The logic described in the callback will be implemented when the delay has run its course.

- `Timer.every`

  Takes as argument `interval` as well as a `callback` function. The logic will run every time the interval has lapsed.

With the second function in particular, it is possible to simplify the use of multiple intervals as follows:

- in the `load()` function create tables for the different intervals and counters.

- always in `load()` create a timer for every counter, using the `Timer.every` function in a loop.

  ```lua
  for i = 0, #counters
  Timer.every(intervals[i], function()

    end)
  end
  ```

  It is in the anonymous, callback function where the behavior we want occurrying is specified. In this instance, increment the counter value by 1.

  ```lua
  for i = 0, #counters
  Timer.every(intervals[i], function()
    counters[i] = counters[i] + 1
    end)
  end
  ```

  For every counter in the `counters` table the value will be updated every time `dt` goes past the matching value in the `intervals` table.

- in the `update(dt)` function update the logic of each timer by calling `Timer.update(dt)`. This single line is responsible for updating every interval set up on the object.

- in the `draw()` function render the counters.

The library takes care of updating the various values, which is certainly more scalable and less prone to error.

Adding another timer is a matter of expanding the `counters` and `intervals` table.
