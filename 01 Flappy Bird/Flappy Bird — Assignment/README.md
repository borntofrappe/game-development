# Flappy Bird — Assignment

Following [the assignment](https://docs.cs50.net/ocw/games/assignments/1/assignment1.html), the update achieves the following:

- [x] randomize the gap between pipes

- [x] randomize the interval at which pairs of pipes spawn

- [x] when a player enters the score state, award them a medal via an image displayed along with the score. Choose 3 different ones, as well as the minimum score needed for each one

- [x] from the play state, allow to pause the game by pressing a key. When pausing the game, a simple sound effect should play, while the music should pause. When resuming the game the gameplay and the music should resume just as they were. Display a pause icon in the middle of the screen, so as to make it clear the game is paused

## Randomize

The first two parts of the assignment are connected in that they both rely on `math.random`

### Random gap

The gap is set in `PlayState.lua` and passed to the `PipePair` class through the `init` function.

```lua
-- PlayState.lua
function PlayState:init()
    self.gap = math.random(GAP_MIN, GAP_MAX)
    self.y = math.random(THRESHOLD_UPPER + self.gap, THRESHOLD_LOWER)
    self.pipePairs = {PipePair(self.y, self.gap)}
end


-- PipePair.lua
function PipePair:init(y, gap)
    self.gap = gap
end
```

This is because it is necessary to know the gap in order to ensure that the pipes are included in the boundaries of the window.

```lua
self.y = math.random(THRESHOLD_UPPER + self.gap, THRESHOLD_LOWER)
```

The same is true when the pair is included at an interval. Update `self.gap`, update `self.y` and pass the value to the new instance.

### Random interval

The duration of the interval is initialized in the `init` function of the play state.

```lua
function PlayState:init()
    self.interval = math.random(INTERVAL_MIN, INTERVAL_MAX)
end
```

`interval` is then updated similarly to the gap and the vertical coordinate of the pipe pair, when the timer exceeds the existing value.

```lua
function PlayState:update(dt)
    if self.timer > self.interval then
        self.timer = self.timer % self.interval
        self.interval = math.random(2, 5)
    end
end
```

Keep in mind that in lua, using `math.random` with two integers has the effect of providing a random number in the range, extremes included.

## Medal(s)

Upon entering the score state, the game displays up to three medals. The medals are awarded by crossing arbitrary thresholds: 5, 10 and 15 points. In the `res/graphics` folder you find the different assets.

In `ScoreState.lua`, these are included as follows:

- stores the images in a table and according to the number of points associated with each asset

  ```lua
  function ScoreState:init()
      self.medals = {
          { points = 5, image = love.graphics.newImage('res/graphics/medal-points-5.png') },
          { points = 10, image = love.graphics.newImage('res/graphics/medal-points-10.png') },
          { points = 15, image = love.graphics.newImage('res/graphics/medal-points-15.png') }
      }
  end
  ```

  Since tables are not sorted, sort according to the number of points behind each image.

  ```lua
  function ScoreState:init()
      medals = {
          { points = 5, image = love.graphics.newImage('res/graphics/medal-points-5.png') },
          { points = 10, image = love.graphics.newImage('res/graphics/medal-points-10.png') },
          { points = 15, image = love.graphics.newImage('res/graphics/medal-points-15.png') }
      }

      table.sort(medals, function(a, b) return a.points < b.points end)
      self.medals = medals
  end
  ```

  This ensures the table is now in ascending order of points.

- when receiving the score from the play state, include the images strictly necessary in a different table

  ```lua
  function ScoreState:enter(params)
      self.score = params.score

      awards = {}
      for k, medal in pairs(self.medals) do
          if self.score >= medal.points then
              table.insert(awards, medal.image)
          end
      end

      self.awards = awards
  end
  ```

- render the medals in `self.awards`, using the index in the table and the length of the table itself to have the images separated from the center.

  ```lua
  for i, award in ipairs(self.awards) do
      love.graphics.draw(award, VIRTUAL_WIDTH / 2 - 12 - 28 * (#self.awards - 1) + 56 * (i - 1), VIRTUAL_HEIGHT / 1.5)
  end
  ```

  Keep in mind that in lua:

  - ipairs allows to retrieve the index

  - the index starts at `1`

## PauseState

From the play state, the game pauses by pressing the `p` key.

```lua
function PlayState:update(dt)
    if love.keyboard.waspressed('p') or love.keyboard.waspressed('P') then
        gStateMachine:change('pause')
    end
end
```

To resume playing from the same point however, it is necessary to also pass the values of the play state.

```lua
gStateMachine:change('pause', {
    bird = self.bird,
    pipePairs = self.pipePairs,
    timer = self.timer,
    interval = self.interval,
    score = self.score,
    y = self.y
})
```

With this in mind the `PlayState` picks up the values in the `enter` function.

```lua
function PauseState:enter(params)
    self.bird = params.bird
    self.pipePairs = params.pipePairs
    self.timer = params.timer
    self.interval = params.interval
    self.score = params.score
    self.y = params.y
end
```

Keep in mind that the values need to be passed back to the play state.

```lua
function PauseState:update(dt)
    if love.keyboard.waspressed('p') or love.keyboard.waspressed('p') then
        gStateMachine:change('play', {
            bird = self.bird,
            -- include other values
        })
    end
end
```

And to this end, you need to update the play state so that it includes the parameters, if available.

```lua
function PlayState:enter(params)
    if params then
        self.bird = params.bird
        -- include other parameters
    end
end
```

### Sound

LOVE2D removes `love.audio.resume()` in version 11.0. As instructed in [the docs](https://love2d.org/wiki/11.0), using `love.audio.play()` after `love.audio.pause()` is enough to have the audio pick up from where it left.

Pause the soundtrack in the pause state.

```lua
function PauseState:enter(params)
    sounds['soundtrack']:pause()
end
```

Resume in the play state when setting the parameters.

```lua
function PlayState:enter(params)
    if params then
        sounds['soundtrack']:play()
        -- set parameters
    end
end
```

### Pause

In addition to the previous audio files, the assignment includes `pause.wav`, to signal when the game moves to the pause state.
