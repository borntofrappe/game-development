# Breakout 12 - Paddle Select

Instead of directly going from start to serve state, the game lets the player choose a paddle. This using the colored paddles in the paddles table and the arrows as retrieved from the `arrow` graphic. This graphic is 48px wide by 24px tall, so each graphic is 24 by 24.

## Setup

In order to introduce the new `PaddleSelectState`, it is first necessary to frame the new stage in the flow of teh application.

The paddle selection follows the start state, when pressing enter on the 'START GAME' string. It precedes the serve state, and therefore needs to introduce and transmit to the serve state all the necessary values (the paddle, the level, score, health). Basically every single value previously passed from the start state to the serve state neesd to first go through the paddle select state.

## main.lua

- create a new frame in the `gFrames` table, referencing the two arrows.

  Luckily, retrieving the quads is as simple as retrieving the heart's quads. The `GenerateQuads` function, combined with the knowledge of the size of the two arrows, allows to rapidly concoct the quads.

  ```lua
  GenerateQuads(gTextures['arrows'], 24, 24)
  ```

- add the new state in the instance of the state machine.

## StartState

Instead of calling the serve state, call the paddle select state instead.

```lua
gStateMachine:change('paddleselect', {
  paddle = Paddle(1),
  bricks = LevelMaker.createMap(1),
  health = 3,
  score = 123456,
  level = 1
})
```

## PaddleSelectState

The state functions like a stepping stone between the start and serve state. In light of this, it defines in the `enter()` function and passes through the instance of the state machine the fields, the values necessary for the game to play out.

Beside this middle man function however, the state is also responsible for the change in color of the paddle. which can be achieved through the instance of the paddle class itself.

The code is rather well documented, but here's the gist:

- through the `render()` function display the paddle in between the two arrows created in the `gFrames` table;

- when pressing the left or right key, go and select the previous or following color. By modifying `self.paddle.skin`, it is possible to have the change immediately evident;

- if the paddle refers to the first or last selection, avoid updating the paddle (perhaps by starting on the opposite side).

This pretty much explains the project, but a note is warranted also for `love.graphics.setColor`. When altering the fourth value (transparency), the change is applied to all drawables, including images. This allows to have the arrows semi-transparent when reaching the first or last color.