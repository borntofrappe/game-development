# Breakout 6

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Breakout — Final`.

## States

The game introduces two additional states.

### ServeState

Right after the introductory title and `StartState`, initialize the serving state. In here initialize the level, the paddle, ball and bricks.

The idea is to move to and from the playing state to show the paddle, always with the ball on top, so that it is necessary to pass the necessary information through the `:enter` functions and the `params` argument.

As the ball starts from the paddle, update `Ball:init` so that the vertical speed is always negative, and the ball moves upwards.

In the top right corner of the serving and playing state show the number of points and health points left. The two are the subject of later sections and a couple of utility functions.

### GameoverState

Once the crosses the bottom of the screen _and_ there are no health points left, instead of reverting back to the serving state, the idea is to initialize `GameoverState`.

Here you receive the score, so you can display the information along a final message.

## Health points

Include heart icons per the `hearts.png` image. The sprites are side by side and each with a (10x9) size, so that it's possible to use `GenerateQuads` directly.

```lua
gFrames = {
  ['hearts'] = GenerateQuads(gTextures['hearts'], 10, 9)
}
```

To show the health, add a global function `displayHealth` in `main.lua`. This function consider the health points left, the maximum number of health points and renders the heart icons in the top right corner. The idea is to show here `n` number of hearts, and use the filled, red version to represent the remaining lives.

## Score

Add a global function `displayScore` to show the number of points below the heart icons. The score is increased in the play state, and by an arbitrary amount of 50 points for every brick collision, but a future update will specify a more complex scoring system.
