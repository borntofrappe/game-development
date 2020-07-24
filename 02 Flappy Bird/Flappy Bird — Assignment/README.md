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
