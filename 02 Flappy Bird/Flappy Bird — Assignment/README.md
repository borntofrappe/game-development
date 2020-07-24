# Flappy Bird — Assignment

Following [the goals from the assignment](https://docs.cs50.net/ocw/games/assignments/1/assignment1.html):

- randomize the gap between pipes

- randomize the interval at which pairs of pipes spawn

- when a player enters the ScoreState, award them a “medal” via an image displayed along with the score. Choose 3 different ones, as well as the minimum score needed for each one

- implement a pause feature, such that the user can simply press “P” (or some other key) and pause the state of the game. When pausing the game, a simple sound effect should play. At the same time, the music should pause, and once the user presses P again, the gameplay and the music should resume just as they were. Display a pause icon in the middle of the screen, so as to make it clear the game is paused

## Randomize

The first two parts of the assignment are connected in that they both rely on `math.random`

### Random gap

To have each pipe with a different, random gap, the value is included in the `init` function

```lua
function PipePair:init(y)
    self.gap = math.random(70, 90)
end
```

Every time a pipe pair is initialized, it gets a random gap in the prescribed range.

### Random interval

The interval is initialized in the `init` function of the play state.

```lua
function PlayState:init()
    self.interval = 4
end
```

To have the value change, assign a random value every time a new pipe is created.

```lua
function PlayState:update(dt)
    if self.timer > self.interval then
        self.timer = self.timer % self.interval
        self.interval = math.random(2, 5)
    end
end
```

Keep in mind that in lua, using `math.random` with two integers has the effect of providing a random number in the range, extremes included.

## PauseState

By pressing `p`, the game moves to te pause state.

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

love2d removes `love.audio.resume()` in version 11.0. As instructed in [the docs](https://love2d.org/wiki/11.0), using `love.audio.play()` after `love.audio.pause()` is enough to have the audio pick up from where it left.

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
