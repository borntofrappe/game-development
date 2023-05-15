# Side Operation

Try to avoid the walls as you are subject to a variable force of gravity, pulling you on either side.

![Side Operation](https://github.com/borntofrappe/game-development/blob/main/Practice/Side%20Operation/side-operation.gif)

## graphics

`side-operation.png` describes the overall appearance of a level. Background, wall, strip and player. The idea is to duplicate the wall on either side, but show the strip only on one side, the one where the gravity pulls the player away from the center.

In addition to these elements, the actual game includes:

- a progress bar, a rectangle 1px tall at the top of the page. The idea is to show the marker to illustrate when the gravity _might_ change

- a trophy, awarded if the player moves away from the wall and very close to the boundary

## Player

The update logic resides is moved to `PlayState.lua`, so that `Player.lua` the class is purely aesthetic. The goal of `Player` is to initialize the image found in the `graphics` folder and render the visual at round coordinates, to maintain the crisp, pixelated nature.

## States

- `TitleState`: introduce the level, move to the countdown state when pressing the "enter" key or the left button

- `CountdownState`: countdown to anticipate `PlayState`

- `PlayState`: update the player to move as per a force of gravity; score the level when the player collides with a wall; allow to pause when pressing the "p" key or the right button

- `PauseState`: stop updating the player; allow to continue when pressing the "p" key or the right button

- `ScoreState`: score in terms of the number of seconds lapsed in the play state and potential trophy; allow to replay when pressing the "enter" key or the left button

## Scrolling

To scroll the background indefinitely, instead of having an image taller than the actual window, draw two copies and move both in the same direction. Reset the position to continue the illusion of indefinite movement.

```lua
love.graphics.draw(images["background"], 0, -scroll_offset)
love.graphics.draw(images["background"], 0, VIRTUAL_HEIGHT - scroll_offset)
```

## Input

Add a table to the `love.keyboard` module to register the key pressed in the current frame. Add a function to return if a specific key is registered.

```lua
function love.keypressed(key)
    love.keyboard.key_pressed[key] = true
end

function love.keyboard.was_pressed(key)
    return love.keyboard.key_pressed[key]
end
```

Add a table to `love.mouse` to register the button pressed in the current frame. Include the coordinates of the mouse for the button. Consider the table directly instead of through a helper function.

```lua
function love.mousepressed(x, y, button)
    x, y = push:toGame(x, y)
    love.mouse.button_pressed[button] = {
        ["x"] = x,
        ["y"] = y
    }
end
```

## Overlay

Overlap a semi-transparent, bright rectangle to mask background elements and have the instructions/text more apparent on top of the visuals.

```lua
function drawOverlay()
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end
```

## Timer

Use a counter variable to keep track of the passage of time. `timer` is useful to:

- count down before `PlayState`

- change the direction of the gravity at an interval

- delay the action from `ScoreState` to avoid having the key press/ mouse press meant for the play state immediately trigger a new level
