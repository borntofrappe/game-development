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

### Medals based on score

At first I picked an icon from [google's material icons](https://material.io/tools/icons/), to focus on the feature more than the design, but after finding the pixel perfect icon rendered blurry (thanks to the push library 'virtualization'), I decided to craft my own blocky icon. It ought to represent a circle with a letter 'J' in it, but it is an icon good enough not to be unnerving. I also decided to craft my own background and ground images, but I've been less than lucky there.

Anyhow, to award a medal, I decided to give a copy on the medal in two instances, and at the condition that the player has reaches a multiple of 5 points.

#### PlayState.lua

- in the `init()` function, I included the image in a field of the class.

  ```lua
  -- init logic
  self.image = love.graphics.newImage('Resources/graphics/medal.png')
  ```

- there's no need to affect the `update(dt)` function here. The medals need to be displayed on the basis of the score, and this is already considered/updated;

- in the `render()` function, a series of conditional statements make it so that, after the 5th point, one medal is rendered for each quintuple.

  ```lua
  -- render logic
  if self-score >= 5 then
    for i = 0, math.floor(self.score / 5) - 1 do
      love.graphics.draw(self.image, (15 * i) + (self.image:getWidth() / 2), 25)
    end
  end
  ```

  The idea is to render each subsequent medal `x` pixel inside the frame (assuming somebody doesn't score an excessive amount of points, there's no risk of overflow).

  I am still uncertain as to how repeat a certain functionality in `lua`, but the idea there is to include for each quintuple one badge. The loop goes from 0 up to `math.floor(self.score / 5)`, which represents 1 if score is in the [5-9] range, 2 if it is in the [10, 14] range and so forth. `-1` is included as the loop already runs once, and for `i = 0`. `15` is then used in the horizontal position to account for a measure larger than the image's width.

  This covers how to show medals as the game progresses, but it is important to also show the medals in the score screen.

#### ScoreScreenState.lua

Before actually diving in the `ScoreScreenState`, it is essential to pass the image alongside the score. This is something achieved in `PlayState`:

```lua
-- losing condition
gStateMachine:change('score', {
  score = self.score,
  image = self.image
})
```

Once it is passed through the second argument, it can be then used in the specified state class.

- in the `enter` function, beside setting `self.score`, set `self.image` to reference the assed passed in the argument of the function.

  ```lua
  function ScoreState:enter(params)
    self.score = params.score
    self.image = params.image
  end
  ```

- in the `render()` function, show one single badge right below the score, and before a number actually counting the number of badges awarded. This of course in case the score warrants a medal.

### TODO

- pause feature.

This is rather challenging feature, and might require a bit more work. Something for a later update.
