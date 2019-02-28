# Match Three 6 - Time Based Events

With this update I set out to implement a couple of timers, in order to:

- have the colors of each letter in the **Match 3** title rapidly change one after the other;

- have a timer displayed in the `PlayState`, counting down an arbitrary amount of time, and increasing in value when pressing a specific key. Here's the additional feat: have the timer move the game to the gameover state upon hitting 0.

## StartState.lua

Starting with the `StartState`, an interval is set up to continuously change the color of each letter, and have each letter with a different color.

There might be a better solution, but here's how I implemented the change in color:

- have a variable `self.color` to update its value at an interval.

- have `self.color` updated in the timer and used in the for loop referring to each word, in the `setColor` function.

- instead of using `self.color` directly, use the measure alongside the index `i` to have the different letters styled with different colors.

It is important to avoid having the color refer to a value exceeding the length of the table. Moreover, it might be best for `self.color` to be reset after successfully looping through the table, as to avoid having too big a number stored in the variable.

Here's how the effect is implemented in code:

- in the `init()` function create a timer with `Timer.every()`.

  ```lua
  Timer.every(1, function()

  end)
  ```

  While `0.07` represents the amount of time at which interval the code will run, the callback `function` is exactly the logic run at every interval.

  In the callback `function` update `self.color`, incrementing its value and resetting the same value when reaching the end of the table.

  ```lua
  Timer.every(1, function()
    self.color = self.color + 1

    if self.color == #self.colors then
      self.color = 1
    end
  end)
  ```

  This guarantees that at every second `self.color` is incremented by 1, and is set back to a value of 1 when reaching the length of the table.

- in the `update(dt)` function update the timer by using the function fittingly available on the `Timer` object.

  ```lua
  Timer.update(dt)
  ```

- in the `render()` function and in the for loop introducing the letters, declare a local variable in `color`.

  ```lua
  local color = self.color + i
  ```

  `color` is initialized to the counting variable plus the index value, to have the different letters use different hues. It is important to highlight how `color` can and effectively will refer to a variable not available in `self.colors`, so it is necessary to cap its value within the table's boundaries.

  ```lua
  local color = self.color + i
  ```

  Once all this logic is set into place, `color` refers to a value in the [1-6] range. One small issue however: as both `i` and `self.color` are initialized at `1`, the first color of the first letter is actually the second color in the table. It is not an overwhelming issue, as the loop inevitably goes back to 1 when reaching the end of the table, but an issue that can be solved by removing 1 to either the index or the counting variable.

All in all it's not an overly-complicated setup, but here's two notes which deserve to be highlighted:

- include the timer in the `init` or `load` function;

- do not forget to update the timer through `Timer.update(dt)`.

## PlayState.lua

The `PlayState` will ultimately include the `Board`, and the table of instances of the `Tile` class. Considering time-based events however, it needs to include a panel describing a countdown.
