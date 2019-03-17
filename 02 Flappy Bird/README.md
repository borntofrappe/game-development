# Flappy Bird

For the second project in the Introductory to Game Development course, the game is **flappy bird**. The topics covered, and hopefully learned by creating a replica are:

- sprites (including images);

- inifinite scrolling (moving the background giving the illusion of movement);

- procedural generation (as to create pipes at various heights);

- state machines (a class to transition between states);

- mouse input.

## Project structure

Like for **Pong**, this game will be created in increments, in folders labeled fittingly 'FB 0', 'FB 1' and so forth. The repo also has a **Resources** folder, in which any file which is not a `.lua` file coded by hand will be included. What's more, the resources folder mirrors the actual structure in which I work locally (and the structure of the folder I feed to the Love2D .exe file).

Each sub-folder will have its own README, in which I'll try to detail the purpose of the code found in the existing files. I will include only those files which are altered between updates and try my best to explain the reasoning behind the addition. Unlike for Pong, in which I mostly read the source code and tried to grasp each line of code, I will try to code along the lecturer and write my own solutions.

## Update

Following the completion of the video available in **FB 12** I decided to include in the root structure for the Flappy Bird game the code fulfilling the assignment as described [right here](https://cs50.harvard.edu/games/2019/spring/assignments/1/).

The assignment puts forwards a few additions, which can be described in the following wish list.

- [x] _Randomize the gap between pipes (vertical space), such that they’re no longer hardcoded to 90 pixels_

- [x] _Randomize the interval at which pairs of pipes spawn, such that they’re no longer always 2 seconds apart_

- [x] _When a player enters the ScoreState, award them a “medal” via an image displayed along with the score_

  - [ ] _Choose 3 different ones, as well as the minimum score needed for each one_

- [x] _Implement a pause feature, such that the user can simply press “P” (or some other key) and pause the state of the game_

  - [x] _a simple sound effect should play_

  - [ ] _the music should pause_

  - [ ] _display a pause icon in the middle of the screen_

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

That being said, I decided to award a medal every time the player scores 5 points. This is shown immediately below the score.

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

This covers the point-based badge, but to fulfill the assignment in full 2 more badges are at least needed. I decided to add three badges for the following feats:

- made the bird jump more than 30 times;

- had the bird exceed the top of the screen;

- have the bird almost reach the bottom of the screen.

On top of these, the points badge has been redesigned to highlight how it is awarded every five points. While the points badge is awarded on screen, while playing, I decided to include the other badges only in the `ScoreState`.

### Pause feature

The new flow of the application can be then described as follows:

```text
title ---- → countdown --- → play ↔ pause
                ↑             ↓
                 -------- score
```

With the pause state affecting only the play state and allowing indefinitely to switch between the two.

Progressively, I was able to complete the feature as follows:

- add `PlayState.lua`. This means requiring the file in `main.lua` and have it referenced in the instance of the state machine;

- structure the pause state much alike `TitleScreenState`, with `printf` functions describing the nature of the state;

- in the play state, listen for a press on the enter key, at which point call the `:change()` function to change toward the pause state. Mirroring this feat, listen for a press on the enter key also in the pause state, to revert back to the play state.

This had the effect of creating a separate screen, allowing to pause and switch back to the play state. Unfortunately, this simple implementation doesn't reflect a pause feature, but more a reset feature. Every time the `PlayState` gets called through the state machine, the `init` function initializes all the variables, essentially resetting the game. The score goes back to 0, the bird starts from the center of the screen, the pipes are added from an empty table.

The approach I took to actually implement the pause **and** resume feature took consideration of the `:enter` function, and specifically how I was able to have the score value passed from the play state to the score state.

In light of this, `PauseState` is called with an object specifying the values which need persisting:

```lua
if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
  gStateMachine:change('pause', {
    score = self.score,
    bird = self.bird,
    pipePairs = self.pipePairs,
    timer = self.timer,
    interval = self.interval,
    lastY = self.lastY
  })
end
```

And in the `enter()` function, the class sets the same values through the `self` keyword:

```lua
function PauseState:enter(params)
  self.score = params.score
  self.bird = params.bird
  self.pipePairs = params.pipePairs
  self.timer = params.timer
  self.interval = params.interval
  self.lastY = params.lastY
end
```

This means that the pause state has access to the score, but also the bird, pairs of pipes and the connected logic regarding their movement and position.

It is possible to use this values already in the play state, perhaps as to show the current score:

```lua
love.graphics.setFont(normalFont)
love.graphics.printf(
  'Current score: ' .. tostring(self.score),
  0,
  -- display the text just above the 16 height ground
  VIRTUAL_HEIGHT * 3 / 4 - 4,
  VIRTUAL_WIDTH,
  'center'
)
```

But most importantly, it is possible to have these values thrown back to the play state to have it effectively start from the previous setting.

```lua
function PauseState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('play', {
      score = self.score,
      bird = self.bird,
      pipePairs = self.pipePairs,
      timer = self.timer,
      interval = self.interval,
      lastY = self.lastY
    })
  end
end
```

`PlayState` needs to be of course modified as to accept these parameters. Parameters which can be set through the `enter()` function to existing values, if any.

```lua
function PlayState:enter(params)
  if params then
    self.score = params.score
    self.bird = params.bird
    self.pipePairs = params.pipePairs
    self.timer = params.timer
    self.interval = params.interval
    self.lastY = params.lastY
  else
    self.score = 0
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.interval = math.random(2, 4)
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
  end
end
```

In case parameters are defined, the fields are initialized with those values, else there's a fallback for the default values describing the starting point.

It is also possible to use a ternary operator:

```lua
self.score = params and params.score or 0
```

But given the number of fields I found it best to separate the two possible branches in the `if then else` statement. Such a conditional is necessary as the `PlayState` might be called without parameters (and it is after the countdown state).

This allows to implement the bulk of the pause features, but two modifications are required to complete the assignment. First, the music should pause while in the `PlayState`. Second, instead of showing a string describing the `PauseState`, or perhaps in addition to this text, show a giant pause icon.

<!-- TODO: implement the features to pause the music and show a pause icon -->
