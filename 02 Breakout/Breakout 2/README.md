# Breakout 2

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Breakout — Final`.

## PauseState

While technically not part of the course, the pause state is a welcomed addition to practice once more with state and how data is passed from one state to the other.

When pressing the enter key, the idea is to pass the horizontal coordinate of the paddle from the play state.

```lua
gStateMachine:change(
  "pause",
  {
    x = self.paddle.x
  }
)
```

In the pause state, then, the idea is to pause the soundtrack before displaying an arbitrary string.

```lua
function PauseState:init()
  gSounds["music"]:pause()
end
```

When leaving the state, the audio is set to play once more.

```lua
function PauseState:exit()
  gSounds["music"]:play()
end
```
