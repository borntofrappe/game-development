# Breakout 9 - Progression

Currently, the game only offers 1 level. Actually, it offers not even the first level of the game, to test out the logic of `LevelMaker`. Since the game ought to begin from level 1, and increment the level whenever the bricks are cleared from the screen, it is necessary to introduce a variable for the level itself.

## StartState

Include the level in between the fields passed to the serve state

```lua
gStateMachine:change('serve', {
  paddle = Paddle(1),
  bricks = LevelMaker.createMap(1),
  health = 3,
  score = 0,
  level = 1
})
```

## ServeState

This is something that holds true for every state which requires the `level` field, but I'll spell it out for the state specifically: in the `enter()` function initialize a variable to store a reference to the values passed from state to state.

```lua
self.level = params.level
```

Pass the value to the play state.

## PlayState

After receiving the value in the `enter()` function, pass it to the pause state as to have it persist. In the pause state, repeat the procedure to have it back in the play state once the pause is completed.

In addition to setting up the value, the play state is the one responsible for updating it. The logic allowed by the level is as follows:

- check if every brick in the `bricks` table has the `inPlay` flag set to false;

- if the level is complete, call the serve state with a new level, leveraging the `LevelMaker` class with the incremented value.

To achieve this feat, create a function to check for victory.

```lua
-- check for victory by looping through the table of bricks
function PlayState:checkForVictory()
  -- if one brick is in play return false, else true
  for k, brick in pairs(self.bricks) do
    if brick.inPlay then
      return false
    end
  end
  return true
end
```

Once created, include this function after detecting a collision with a brick. After `brick:hit()`.

Instead of immediately calling the serve state, the lecturer includes a `VictoryState`, in which the victory sound is played while displaying pertinent information:

- the current level being completed;

- how to proceed.

Once the play proceeds, then the idea is to call the serve state with the new level.

## Victory State

The victory state receives:

- level;

- score;

- health.

But also:

- paddle;

- ball.

This to presumably show the paddle in the same position. Scratch that, this is done to show the ball and the paddle also in the victory state, which can be avoided.

After receiving these values it displays the values and listens for a press on the enter key, at which point it calls the serve state with a new level, in `LevelMaker.createMap(self.level + 1)`.

## LevelMaker

I decided to tweak a little how the levels are created. This to guarantee, at least in the beginning, grids of smaller size and greater variety. As the game progresses, the number of columns and rows is also allowed to increase.
