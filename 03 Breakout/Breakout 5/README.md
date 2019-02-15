# Breakout 5 - Hearts

Starting with this update, variables shared by different states are passed through the second argument of the `StateMachine:change()` function. I already went through this ordeal with the `PauseState`, but the idea is to have variables defined in the `:enter()` function of each class instead of using global variables.

For instance, going from the start state to the play state, we pass the paddle, the bricks, and now also the hearts and the score.

```lua
gStateMachine:change('play', {
  paddle = Paddle(1),
  bricks = LevelMaker.createMap(),
  health = 3,
  score = 0
})
```

Such values are then available in the `enter()` function, and specifically the argument it accepts, `enterParams`.

## StartState.lua

Instead of transitioning the game to the play state, include the mentioned variables into a `ServeState`. This is roughly equivalent to the `PlayState`, minus the actual movement of the ball.

```lua
gStateMachine:change('serve', {
  paddle = Paddle(1),
  bricks = LevelMaker.createMap(),
  health = 3,
  score = 0
})
```

## ServeState.lua

As mentioned, the serve state lays out the graphics for the bricks, the ball and the paddle. In addition, it waits for input as to transition toward the play state. The idea is to position the ball right atop the paddle and, when registering a press on the enter key, fire the ball toward the top of the screen.

- in the `enter()` function consider the variables passed from the start state and include an instance of the ball class. The lecturer actually changes this instance a little bit, specifying the skin of the ball not when the instance of the class is created, but later and directly changing the value through `self.ball.skin`.

- in the `update(dt)` function, update the paddle and the ball. The ball however ought to move only in connection to the paddle's movement, matching its horizontal change. Listen then for a press on the enter key, at which point trigger the play state. Include then the necesary values: paddle, bricks, health, score and now ball.

- in te `render()` function render the paddle, ball and bricks, as well as a string instructing on how to move toward the play state. In addition to these values, include also the score and the hearts signallng the player's health. These values are specified in `main.lua`, which follows.

## main.lua

A new hearts table is included in `gFrames`. Instead of using `breakout.png` and a function declared in `Util.lua` however, the asset is created from `hearts.png`, which includes the two heart icons in a file 20px wide and 9px tall.

To retrieve the hearts, given that the image describe the hearts only, it is possible to use the `GenerateQuads` to create a table of two values.

```lua
  ['hearts'] = GenerateQuads(gTextures['hearts'], 10, 9)
```

The file also includes two new functions in `displayHealth` and `displayScore`, which are used to display however many hearts and however many points are appropriate for the game.

It is important to note that the functions here created are **global** and can be accessed anywhere in the logic which follows. This has more to do with the lua programming language than love2d, but it is important to highlight in terms of scope.

### displayHealth

Takes as argument:

- `health`, describing the number of hearts available.

Renders the hearts in the top right corner of the screen. Instead of placing the hearts to the left of the score, I decided to position them below the score (which also solves the messy alignment of a 9px icon with an 8px text).

My approach is also a little different considering how the hearts are included. Instead of drawing them left to right, I position them right to left, in such a way that the icons always end at the prescribed coordinate, no matter how many hearts are specified. This of coure means that empty hearts need to be drawn before the filled ones, if empty hearts need to be drawn at all.

Considering the losses, draw empty hearts starting from the end of the screen:

```lua
for i = 1, (maxHealth - health) do
  love.graphics.draw(gTextures['hearts'], gFrames['hearts'][2], lastX - (i * 11), 20)
end
```

Considering the remaining health, draw filled hearts, beginning from where the losses end:

```lua
for i = (maxHealth - health + 1), maxHealth  do
  love.graphics.draw(gTextures['hearts'], gFrames['hearts'][1], lastX - (i * 11), 20)
end
```

### displayScore

Takes as argument:

- `score`, describing the cumulative score.

Renders the score in the top right corner of the screen. To avoid having to worry about allocating enough space, I decided to use the `printf` function and align the text to the right of the screen. This ensures that no matter how high the score might be, the text won't overflow past the right edge of the screen.

```lua
love.graphics.printf(
  'Score: ' .. tostring(score),
  0,
  8,
  VIRTUAL_WIDTH - 8,
  'right'
)
```

## PlayState.lua

Beside being used in the `ServeState`, the variables for the score and health are passed and used in the play state. Additionally and only in the play state, the game updates the health and the score in `update(dt)` and according to following logic:

- when the ball goes past the bottom of the screen, decrease the number of health points. Check if this value hits zero, at which point call `GameoverState`. Else change to the `ServeState`. Always passing the values necessary for the receiving file (score for the gameover screen; paddle, bricks, health and score for the serve screen).

- when the ball hits a brick, add 10 to the score. Currently more as a proof of concept than an actual scoring system.

## GameoverState.lua

In this screen render a giant string of text displaying the end of the game, as well as the score accumulated throughout. Instruct also on how to proceed and for this purpose listen for a key press on specified keys:

- enter to go to the play state

- escape to quit.
