# Breakout 8

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Breakout — Final`.

## Tiers and colors

The idea is to "knock down", decrement, the color and tier of a brick until it reaches the first variant. It is then only when the brick has a value of `1` for both attributes that the instance is "destroyed", removed from view by flipping the boolean `inPlay` to false.

```lua
function Brick:hit()
  if self.color > 1 then
    self.color = self.color - 1
  elseif self.tier > 1 then
    self.tier = self.tier - 1
  else
    self.inPlay = false
  end
end
```

## Audio

This is a minor detail, but in terms of audio:

- there are multiple sound bites describing a collision between the ball and a brick, `brick-hit-1` and `brick-hit-2`. The first one seems most appropriate to describe when the brick is destroyed, while the second variety works for a more general collision.

- love2d waits for the sound bite to be over before playing a new one. This means two collisions occurring in rapid succession result in a single sound. To fix this, use the `:stop()` function to remove the previous audio and play only the new one

## Points

When a ball collides with a brick, use the tier and color for a more complex scoring system.

```lua
self.score = self.score + 200 * (brick.tier - 1) + 50 * brick.color
```
