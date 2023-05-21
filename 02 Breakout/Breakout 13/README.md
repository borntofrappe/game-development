# Breakout 13

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Breakout — Final`.

## ServeState

The update includes an additional state between start and serve, `PaddleSelectState`. The goal is to give the choice to the player to pick and choose a color for the paddle, so that the class is initialized before the serving state. To this end, update `ServeState` to always consider parameters in the `:enter` function, and set defaults if the matching value is not passed through the `params` table.

```lua
function ServeState:enter(params)
  self.level = params.level or 1
  self.health = params.health or 3
  -- ...
end
```

## Arrows

In `res/graphics/arrows.png` you find the sprites for the arrows. Create the quads with a method similar to the one described for the hearts.

```lua
gFrames = {
  ['arrows'] = GenerateQuads(gTextures['arrows'], 24, 24)
}
```

With the idea of showing the left and right variants on either side of a paddle.

## PaddleSelect

In terms of visuals, render some text the paddle, and the arrows on either side.

In terms of logic, allow to change the color of the paddle between one of the four available variants by pressing the left and right key.

```lua
if love.keyboard.waspressed("left") then
  self.paddle.color = self.paddle.color - 1
  gSounds["select"]:play()
end
```

Instead of looping to the other end when pressing the left key on the first option, or the right key on the last choice, prevent the action and play the matching sound byte.

```lua
if love.keyboard.waspressed("left") then
  if self.paddle.color == 1 then
    gSounds["no-select"]:play()
  else
    self.paddle.color = self.paddle.color - 1
    gSounds["select"]:play()
  end
end
```

To accompany the logic, render the corresponding arrow as semi-transparent.

```lua
if self.paddle.color == 1 then
  love.graphics.setColor(1, 1, 1, 0.5)
  -- left arrow
end
```
