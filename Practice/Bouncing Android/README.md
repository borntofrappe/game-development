# Bouncing Android

The goal of this project is to create the game inspired by flappy bird and included as an easter egg in the lollipop version of the android operating system.

Consider this a follow up of `01 Flappy Bird`, to rehearse the powerful concept of state machines.

## Resources

In the `res` folder you find:

- `lib/class.lua` to work with object oriented programming

- `fonts/font.ttf` to include the font [Lato](https://fonts.google.com/specimen/Lato) in its bold variant

- several images in the `graphics` folder to provide the background, player and otherwise world assets. Take notice of the size of the images, especially that of the background, which implies a window size of `400` by `550`

## State

Picking up from `Flappy Bird` and specifically `Flappy Bird 8`, the `StateMachine` class allows to split the game into dedicated states, like the title or playing states, and manages the transition to and from each instance. The end result is that in `main.lua` you update the game and render the necessary visuals as follows.

```lua
function love.update(dt)
  gStateMachine:update(dt)
end

function love.draw()
  gStateMachine:render()
end
```

It is then up to the individual states to implement the `update` and `render` functions.

In the game, there are four planned states, which can be connected with the following simplified flow.

```text
title -> waiting -> playing -> gameover
                      ^           |
                      |___________|
```

### Title

The title screen shows the string 'lollipop' above a series of shapes. The idea is to replicate the game's original title screen with a series of overlapping circles.

To move from the title to the waiting screen, the idea is to register a press in the boundaries of the larger circle. Instead of immediately moving to the destination state, however, the idea is to register a press for a longer stretch of time, and specifically enough time for the semi transparent, white circle to expand and cover the colorful shape.

### Waiting

The waiting state introduces a parallax effect in the form of three images of buildings, moving at different speeds toward the left.

The effect needs to be preserved in the play state as well, while the gameover state should render the buildings as immovable. Knowing this, it is preferable to have a global table in to describe the images, their offset value and speed.

```lua
gParallax = {
  {
    key = "buildings-3",
    offset = 0,
    speed = 5
  },
  -- ... other buildings
}
```

As needed then, the table is updated to offset the images. This would be in the `update` function of the waiting and playing state.

```lua
for i, parallax in ipairs(gParallax) do
  parallax.offset = (parallax.offset + parallax.speed * dt) % WINDOW_WIDTH
end
```

Where necessary, finally, the table is used to draw the images. This would be everywhere except the title state.

```lua
for i, parallax in ipairs(gParallax) do
  love.graphics.draw(gImages[parallax.key], -parallax.offset, 0)
end
```

### Playing

The play state includes most of the game's logic. Similarly to `01 Flappy Bird`, the obstacles are introduced in pairs, through the `Lollipop` and `LollipopPair` classes. Instead of `Bird.lua` then, the player is represented by `Android.lua`.

### Gameover

The gameover state shows the same visuals of the playing state, but without movement. To this end, the `enter` function receives the android, and lollipops. The score is also included to show the number of points awarded in the game.

```lua
function GameoverScreenState:enter(params)
  self.score = params.score
  self.android = params.android
  self.lollipopPairs = params.lollipopPairs
end
```

To stop movement altogether, the `update` function doesn't update the android, nor the lollipops or the buildings. The only job of the function is to register a press to move back to the play state.

```lua
if love.mouse.waspressed then
  gStateMachine:change("play")
end
```

As a small refinement, however, the movement to the play state is also conditioned to a small delay. `self.delay` is decremented with `dt` and only when the value reaches `0` the change is allowed.

```lua
if self.delay == 0 and love.mouse.waspressed then
  gStateMachine:change("play")
end
```

This is to avoid moving to the playing state too quickly.

## Android

The android is positioned with an offset, so that the rotation takes place from the center of the static image.

```lua
love.graphics.draw(
  self.image,
  self.x,
  self.y,
  self.angle,
  1, -- scale x
  1, -- scale y
  self.width / 2, -- offset x
  self.height / 2 -- offset y
)
```

This influences the logic for the collision, both with the bottom edge of the window and the individual lollipops.

## Lollipop

Instead of having a rectangular obstacle, the lollipops are represented by a thin, white rectangle below a large, colorful circle. In terms of collision, it is not only necessary to check whether the android is before/after, above/below the shape, but also the two distinct segments:

- when the vertical coordinates sits in the boundaries of the circle, it is necessary to compute the hypothenuse

- in the context of the thin rectangle, it is necessary to consider the surrounding whitespace
