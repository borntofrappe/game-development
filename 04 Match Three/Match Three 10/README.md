# Match Three 10 - Wrap Up

Before the assignment, and just like for Breakout, the last update includes the entire project, considering all the `lua` files created for the occasions. The resources like images and sounds are not included, but the final version of `main.lua` and the files included from the `src` folder are.

## Sound

Including audio is rather straightforward, and replicates the process included with Breakout:

- include the audio files in a global table, and through the `love.audio.newSource()` function;

- play the audio through the `:play()` function, available without the need of extra code.

- for the soundtrack, and to have an audio file run continuously, set looping to true, through `:setLooping(true)`

## Timer Update

When incorporating the sound, and specifically the sound bite for the clock, it is possible to see how the audio plays even after the play state is no longer shown. For time-based events setting up an interval, it seems necessary, and desirable, to clear the interval after it has served its purpose, to avoid having the logic linger as the game progresses. Similarly to how JavaScript has a `cleaerInterval()` function, the `knife.timer` module provides a way to clear the interval through `Timer.clear()`.

```lua
Timer.clear()
```

It is essential to highlight where this new function is best placed: **before** changing the state. Otherwise the clear function will refer to intervals also set up in the destination state, meaning that if you had this:

```lua
if love.keyboard.wasPressed('escape') then
  gStateMachine:change('start')
  Timer.clear()
end
```

And if you were to go from the play to the start state, the interval in this last state would not run, and the colors of the letters would not flash.

The following, on the other hand, correctly clears one interval without affecting the other:

```lua
if love.keyboard.wasPressed('escape') then
  Timer.clear()
  gStateMachine:change('start')
end
```
