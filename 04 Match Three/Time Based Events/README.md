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

- in the `render()` function render the variable with the `printf` function.

Here's the problem with this approach: when you need to create multiple instances of the timer, with 2 variables for each instance, to keep track of `dt` and to update the actual value. This is not a scalable solution.
