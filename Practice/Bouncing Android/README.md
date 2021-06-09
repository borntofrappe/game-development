# Bouncing Android

The goal of this project is to create the game inspired by flappy bird and included as an easter egg in the lollipop version of the android operating system.

Consider this a follow up of `01 Flappy Bird`, to rehearse procedural generation and state machines in particular.

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

To move from the title to the waiting screen, the idea is to register a mouse press in the boundaries of the larger circle. Instead of immediately moving to the destination state, however, the idea is to also demand a press for an undefined amount of time, and specifically enough time for the semi transparent, white circle to expand and cover the colorful shape.

### Waiting

Fixed moon. Scroll buildings.

### Playing

Android, lollipops.

### Gameover

Stop scrolling and movement altogether.