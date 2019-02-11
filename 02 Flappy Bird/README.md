# Flappy Bird

For the second project in the Introductory to Game Development course, the game is **flappy bird**. The topics covered, and hopefully learned by creating a replica are:

- sprites (including images);

- inifinite scrolling (moving the background giving the illusion of movement);

- procedural generation (as to create pipes at various heights);

- state machines (a class to transition between states);

- mouse input.

## Project structure

Like for **Pong**, this game will be created in increments, in folders labeled fittingly 'FP 0', 'FP 1' and so forth. The repo also has a **Resources** folder, in which any file which is not a `.lua` file coded by hand will be included. What's more, the resources folder mirrors the actual structure in which I work locally (and the structure of the folder I feed to the Love2D .exe file).

Each sub-folder will have its own README, in which I'll try to detail the purpose of the code found in the existing files. I will include only those files which are altered between updates and try my best to explain the reasoning behind the addition. Unlike for Pong, in which I mostly read the source code and tried to grasp each line of code, I will try to code along the lecturer and write my own solutions.

Even when a snippet is meant to be exactly the same, I will avoid copy-paste to reinforce my learning of the subject.

## Update & Assignment

There actually isn't any update 13, but I decided to create one for the assignment given by the lecturer to expand on the game.

These are tasks that go beyond the scope of the video, but it is teaching and also entertaining to indulge in them.

### Slightly random pipe gaps

To include randomness in the height of the gaps I modified `PlayState.lua` and `PipePair.lua` as follows:

- in `PlayState.lua`, and specifically where each pair of pipe is generated, I created a new variable in gap. This is a local variable just like `y`, and just like `y` it is passed to the instance of the `PipePair` class inserted in the table.

  ```lua
  -- in update(dt), when adding a pair of pipe
  local gap = math.random(90, 150)

  -- local y logic

  -- insert an instance of the pipe pair class with the specified vertical coordinate and the random gap value
  table.insert(self.pipePairs, PipePair(y, gap))
  ```

- in `PipePair.lua` I adjusted the `init()` function as to describe a field for the gap as well.

  ```lua
  function PipePair:init(y, gap)
    self.gap = gap -- in addition to previous fields
  end
  ```

And then modified the use of the gap variable in the instance of the bottom `Pipe`, from `GAP_HEIGHT` to `self.gap`.

### Slightly random pipe interval

I had previously and already stored a reference to the interval in a variable used in the `update(dt)` function of the play state.

Making it random is a matter of initializing it randomly:

```lua
self.interval = math.random(2, 4)
```

And later re-assign a random value as a new pipe gets spawned. Right after setting the timer back to 0:

```lua
-- when adding a pipe
self.timer = 0
self.interval = math.random(2, 4)
```
