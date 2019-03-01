# Match Three 7 - Transitions

Before actually incorporating the board and detailing the architecture of the game, in terms of levels and scores, this update sets out to detail the transition between `StartState` and `PlayState`. This making use of the concepts introduced in the **time based events** and **tween between values** folders, not to mention the notion of chaining introduced in **chain functions**.

## The Goal

The transition can be described as follows:

- the player selects 'Start';

- the screen fades to white;

- the screen fades from white to show the board;

- a stripe detailing the current level is shown appearing from the top, stopping midway through and disappearing at the bottom;

- the panel showing the level, score, goal and timer is introduced;

- the player is allowed to interact with the board, effectively playing the game.

The transition explained in the fourth point repeats itself once a new level is reached, but this update is tasked to implement the fade-out, fade-in transition exclusively between `StartState` and `PlayState`. The level state describing how the player has reached a certain goal, will be the subject of a future update.

## Overall Design

Before diving into the transition between states I decided to detail a little better the gameover state, as to include an overlay similar to the one introduced in the play state. I also updated the start state insofar as it introduces a dark layer before every graphic, to effectively darken the underlying background. These might be minor stylistic choices, but they do add up. Moreover, they are in line with the advice of the lecturer given toward the end of the video: _use a limited number of colors_. The consistency across states really helps delivering a good experience.

## StartState

The fade-to-white transition is implemented through a rectangle, included in the `render()` function and following every other graphic. The idea is to modify this rectangle's opacity to have the content of the start state effectively hidden from view.

- in the `render` function include the rectangle:

  ```lua
  love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  ```

  For the color of the rectangle, include a variable to describe the opacity. This to later update said values and have the `render()` function draw an ever more opaque shape.

  ```lua
  love.graphics.setColor(self.fadeout.r, self.fadeout.g, self.fadeout.b, self.fadeout.a)
  love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
  ```

  I decided to not only describe a variable for the opacity, but a table for the entire rgba code of the shape. This, in theory, allows to rapidly change the color in one place and have it apply immediately in the `render()` function.

- in the `init` function initialize the variable just mentioned.

  ```lua
  self.fadeout = {
    r = 1,
    g = 1,
    b = 1,
    a = 0
  }
  ```

  Notice the initial opacity, to have the rectangle hidden by default.

- in the `update(dt)` function and specifically when the player hits enter on option one, include the tween transition.

  ```lua
  -- option 1 - go to play state
  if self.highlight == 1 then
    Timer.tween(0.7, {
      [self.fadeout] = { a = 1 }
    })
  end
  ```

  This allows to modify the opacity later used for the background, assuming the timer is itself updated later in the code.

  Fading to white is impressive, but it is also necessary to do transition to the play state. The transition is achieved **after** the tween has completed its job through the `:finish()` function, which allows to chain logic.

  ```lua
  -- option 1 - go to play state
  if self.highlight == 1 then
    Timer.tween(0.7, {
      [self.fadeout] = { a = 1 }
    }):finish(function()
      -- go to the play state
      gStateMachine:change('play')
    end)
  end
  ```

  Declaratively, the code describes a tween transition and goes to the play state when said transition is over.

## PlayState

The `PlayState` implements a fade-from-white transition, mirroring the behavior described in the `StartState`.

On top of this, the state needs to highlight the current level through another transition, involving a stripe scrolling from the top, stopping in the middle of the screen and exiting the scene below the bottom of the screen.

This is where the concept of _chaining_ comes into play, along with the `Timer.after` function. Indeed, the transitions need to follow one another on a schedule:

- fade the white overlay to nil opacity;

- introduce the stripe showing the level, transitioning it from the top to the middle of the screen;

- have the stripe pause in the middle of the screen, to give the player a change to read the brief text included in it;

- make the stripe disappear moving downwards, out of the scope of the screen.

It is only after this last transition that the timer should begin. It is also here where the player is allowed to interact with the board, but that feature will be discussed in the following update.

Coming back to the transition and the chaining of the different functions: the biggest challenge is not in implementing the logic of each tween or delay timer, but nesting the different callbacks appropriately. I still don't have much practice, but here's a how I managed the multitude of `end` keywords at the end of each function: begin describing the function fired after the transition, or more broadly the time-based events, is complete.

```lua
Timer.tween(time, {
  -- transition here
}):finish(function()
  -- logic fired after _time_ here
end)
```

In the function describing the logic to-be-considered when the tween transition ends, include other time-based events:

```lua
Timer.tween(time, {
  -- transition here
}):finish(function()
  Timer.tween(timeAgain, {
    -- transition here
  }):finish(function()
    -- logic fired after time and after timeAgain here
  end)
end)
```

All things considered, include the `:finish` keyword after each transition. Start by building up the structure of the callback function and wrap whichever logic needs to run after the transition in this function.

```lua
:finish(function()

end)
```

After nesting the different transitions, the code should look as follows:

```text
transition
  transition
    transition

    end
  end
end
```

It is perhaps overly descriptive, but the nature of the language, indentation based, on top of the chaining of multiple functions has the potential to complicate the implementation of the scheduled transitions.

Another important issue relates to the interplay between the `tween` and `after` functions with the `every` function implemented for the countdown timer.

They all share the same `Timer.update(dt)` call, meaning that the countdown counts down even before the transition has been completed. To avoid this annoyance, `Timer.every` can be nested in the last chained function.

Finally, as to allow the logic of the `update(dt)` function only after the schedule of transitions is completed, a boolean is introduced in `self.isPlaying`. Every functionality that is supposed to be enabled by the play state, and following the intro animation, is subject to this boolean being true. It is however initialized to false and switched only as the countdown timer starts running, in the last chained function.
