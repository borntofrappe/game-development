# Flappy Bird 9 - Score

The logic behind the score is implemented as follows:

- add a field in each instance of the `PipePair` class to describe whether the bird has passed by the pipe itself. Something akin to `scored`;

- when the bird is past a pair of pipes, switch the boolean of `scored` to `true`;

- in the update function of the play state, and when looping through the pairs of pipes, check for those instances which are **not** scored **and** are to the left of the bird. These are pairs prompting a point. Once you account for their contribution, switch the boolean back to `false` as to avoid counting the same pair twice.

Of course this covers how to keep track of the score in the play state. Once a game is over however, the score needs to be displayed in a separate screen. It is here that we make use of the `:enter` function available on all states inheriting from `BaseState`.

## main.lua

In addition to the previous states, require `ScoreState` class. This will be responsible for the screen showing the score.

```lua
require 'states/ScoreState'
```

In `:update(dt)`, complement the previous instances of the `StateMachine` class with the new value.

```lua
gStateMachine = StateMachine {
  ['title'] = function() return TitleScreenState() end,
  ['play'] = function() return PlayState() end,
  ['score'] = function() return ScoreState() end
}
```

## PipePair

In the `update()` and following the `self.remove` boolean, introduce a field `scored`, representing whether or not the pair of pipes has been scored.

```lua
self.scored = false
```

## PlayState

In the play state, and specifically in the `update(dt)` function, loop through the pair and count a point for each pair of pipe that is not already scored and finds itself to the left of the bird.

```lua
for k, pair in pairs(self.pipePairs) do
  if not pair.scored then
    if pair.x + PIPE_WIDTH < self.bird.x then
      self.score = self.score + 1
      pair.scored = true
    end
  end
end
```

Only in the specified instance, count then point and then set the flag to true, making it so that the pair will not increase the tally more than once.

Note how to check a condition opposite to a certain assumption, through the `not` keyword followed by the condition itself. (much alike the exclamation mark `!` in JavaScript).

This covers how to track the score in the play state. For feedback, you can already display the score _as_ the game proceeds, and through the `print` or `printf` functions, but the integer is the prominent feature of another state, the score screen state. The key is to here take the score value and have it passed to the separate class. This feature is achieved by leveraging the functions so far, and specifically:

- `StateMachine:change()`. As mentioned, this function accepts up to two arguments, with the second being an (optional) set of parameters. It is through this second argument that the score is passed to the `ScoreState`:

  ```lua
  -- consider the individual pipes in the pair
  for l, pipe in pairs(pair.pipes) do
    -- if the self.bird collides with one of the pipes go to the score screen
    if self.bird:collides(pipe) then
      -- pass the score as a second argument of the :change function
      gStateMachine:change('score', {
        score = self.score
      })
    end
  end
  ```

- `BaseState:enter()`. This function allows to set, introduce fields in the instance of the state class, and is specified in the `ScoreState` class.

## ScoreState

The score state is responsible for showing the score in bold letters and instruct the player on how to play again.

As you need the `score` value passed from the playing state, you can include this through `enter` function.

```lua
function ScoreState:enter(params)
  self.score = params.score
end
```

Making the score available through in the `score` field of the class.

Once set up, the structure of the `ScoreState` is rather similar to the `TitleScreenState`, except for the different text displayed on the screen.

- in `update(dt)` listen for a key press on the enter key, which triggers the play state once more;

- in `render` display the score, including the value through the `tostring()` function, and a hard-coded string detailing how to play once more.
