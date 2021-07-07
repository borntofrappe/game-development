# Match Three 10

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Match Three — Final`.

_Please note:_ the score in the play state is modified to rapidly surpass the goal.

## Gameplay

The goal is initialized at an arbitrary value of `5000`, and is increased every time the score surpasses its amount.

```lua
function PlayState:init()
  self.goal = 5000
end

function PlayState:removeMatches()
  if self.score > self.goal then
    self.goal = math.floor(self.goal * 2.5)
  end
end
```

When the goal is updated, the level is also increased. Moreover, the timer receives a bump to give more time in order to reach the higher goal.

```lua
function PlayState:removeMatches()
  if self.score > self.goal then
    self.timer = self.timer + self.level * 10
    self.level = self.level + 1
    self.goal = math.floor(self.goal * 2.5)
  end
end
```

## Tween

The first level is highlighted with a string that is transitioned from the top, stops in the middle of the screen and then moves at the bottom of the window.

Thanks to the boolean `isTweening`, it's possible to repeat the animation while preventing user interaction with the board.

```lua
function PlayState:removeMatches()
  if self.score > self.goal then
    self.goal = math.floor(self.goal * 2.5)

    self.isTweening = true
    self.levelText.y = -VIRTUAL_HEIGHT / 2 + 40
    -- repeat y animation
  end
end
```
