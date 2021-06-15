# Breakout 6

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Breakout — Final`.

## States

The game introduces two additional states:

- `ServeState`, between the start and play. Here you show the level, and position the ball atop the paddle. The idea is to move to the play state by pressing enter, and always move the ball upwards away from the paddle

- `GameoverState`, once the ball crosses the bottom of the screen _and_ there are no lives left (see next section). The idea is to show the score and move to the serve state by pressing enter

## Health points

The heart icons are included in the `hearts.png` image, side by side and each with a (10x9) size. Creating the quads is therefore a matter of using `GenerateQuads` with the given measure.

```lua
gFrames = {
  ['hearts'] = GenerateQuads(gTextures['hearts'], 10, 9)
}
```

To show the health, add a global function `displayHealth` in `main.lua`. This function consider the health points left, the maximum number of health points and renders the heart icons in the top right corner. The idea is to show here `n` number of hearts, and use the filled, red version to represent the remaining lives.

## Score

Add a global function `displayScore` to show the number of points below the heart icons. The score is increased in the play state, and by an arbitrary amount of 50 points for every collision, but a future update will specify a more complex scoring system.
