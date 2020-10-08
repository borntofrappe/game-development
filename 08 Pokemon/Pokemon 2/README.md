Introduce the `FadeState` to transition between states.

_Please note_: taking inspiration from the suggestion of the lecturer, the update creates a single class for both a fade-in and a fade-out operation.

_Plese also note_: the notes are for the fading transition introduced between the start and play/dialogue states, but the technique is repeated between the play and start state as well.

## FadeState

`FadeState` is initialized with a table, itself describing the following:

- `color`, for the rgb component attributed to the rectangle

- `duration`, for the `Timer.tween()` function

- `opacity`, describing the goal opacity

Using the `opacity` in particular, the class initiazes `self.opacity` with an opposite value.

```lua
function FadeState:init()
  self.color = def.color
  self.duration = def.duration
  self.opacity = def.opacity == 1 and 0 or 1
end
```

This is to have the value obtain the input `opacity` at the end of the transition. Passed in the state, the value describes the goal opacity.

```lua
gStateStack:push(
  FadeState(
    {
      color = {["r"] = 1, ["g"] = 1, ["b"] = 1},
      duration = 0.5,
      opacity = 1 -- fade in
    }
  )
)
```

For the actual animation, the timer library uses the mentioned `Timer.tween` function.

```lua
Timer.tween(
  self.duration,
  {
    [self] = {opacity = def.opacity}
  }
)
```

The `Timer` object needs to be updated.

```lua
function FadeState:update(dt)
  Timer.update(dt)
end
```

This to finally use the changing value in the `render` logic.

```lua
love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.opacity)
-- rectangle
```

This is enough to have a rectangle fade in or out. Past the transition however, it is necessary to describe how to continue. The timer library allows to execute code after the transition by way of the `:finish()` function

```lua
Timer.tween():finish(function()

end)
```

This is where the `FadeState` can be removed from the stack.

```lua
Timer.tween():finish(function()
  gStateStack:pop()
end)
```

To continue with the game however, the `FadeState` needs to execute code which depends on the situation. Between start and play state, the code needs to push the play state. Between play state and combat state (consider when a battle begins), the code needs to trigger the battle sequence. To accommodate this variety, the class is initialized with an additional argument, a function to be executed as `FadeState` is popped from the stack.

```lua
Timer.tween():finish(function()
  gStateStack:pop()
  def.callback()
end)
```

### callback

Considering the transition between start and play/dialogue state once more, the two states are added to the stack in the body of the callback function.

```lua
gStateStack:push(
  FadeState(
    {
      -- previous attributes
      callback = function()
        gStateStack:pop()
        gStateStack:push(PlayState())
        gStateStack:push(DialogueState())
      end
    }
  )
)
```

The code is not executed immediately, but only when the `tween` operation is complete.

### Fade in fade out

To complete the fading transition, the callback function includes yet another push operation. This time for a `FadeState` where a white rectangle is animated to be fully transparent.

```lua
gStateStack:push(
  FadeState(
    {
      color = {["r"] = 1, ["g"] = 1, ["b"] = 1},
      duration = 0.5,
      opacity = 0,
      callback = function()
      end
    }
  )
)
```
