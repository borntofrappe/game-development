# Breakout 2 - Ball

Just like for the paddles, we create here a function in the `util.lua` file, to target the specific quad(s) representing the balls

### Util.lua

- always using breakout.png;

- with px precision finding the 8px tall balls, after the bricks;

- setting the x and y values before looping for as many times as there are assets in the row.

### main.lua

Add here the new set of quads below the paddles, to have the game rapidly access one of the ball graphics:

```lua
gFrames = {
  ['paddles'] = GenerateQuadsPaddles(gTextures['breakout']),
  ['balls'] = GenerateQuadsBalls(gTextures['breakout']) -- new asset
}
```

### Ball.lua

Once the balls are retrieved in a table, it is possible to render them much alike the paddle.

Much alike the paddle, you create a Ball class containing the logic of the ball.

- x;

- y;

- width;

- height;

- dx, initialized at a random value;

- dy, initialized at a random value;

- skin, for the different color, targeting a different ball in the `gTextures['balls']` table. This can be initialized with a random value as well, to have a ball of a different color for every play through.

Following the `init` function (in which the skin is actually passed as argument) include a `collides` function, using AABB collision to detect a hit between the paddle and the ball

Include a `reset` function re-centering the ball

Moreover, in the `update` function update the movement and accommodate for a bounce on the walls (switching the movement according to the wall being hit). Add also sounds, as to provide minor feedback.

In the `render` function finally use the draw function targeting the specific ball much alike the specific paddle, but using the skin passed as argument. This can be chosen at random at runtime.

### PlayState.lua

Incorporate the ball creating an instance of the class, and update / render the same with the logic already used for the paddle. To increase randomness, you can give a random dx and dy value at runtime

When checking a collision be sure to also reset the position of the ball. Not just change the direction. This to make sure that the ball doesn't collide with the paddle continuously

Finaly note, but more on the interplay between play state and pause state: previously, I had the coordinate of the paddle persist through the enter parameter and specifically the `params.x` value. As the ball too has an `x` coordinate, the values passed to and from the pause state need to be restructured into their own table.

Passing the values:

```lua
gStateMachine:change('pause', {
  paddle = {
    x = self.paddle.x
  },
  ball = {
    x = self.ball.x,
    y = self.ball.y
  }
})
```

Setting the values:

```lua
function PauseState:enter(params)
  self.paddle = {
    x = params.paddle.x
  }

  self.ball = {
    x = params.ball.x,
    y = params.ball.y
  }
end
```

The same is mirrored for the way back, when the state machine changes to the play state and the play state alters the coordinate of the classes if such coordinates are provided.
