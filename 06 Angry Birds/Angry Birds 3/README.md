# Angry Birds 3

## Mouse input

The relevant functions are here:

- `love.mousepressed(x, y, button)`

- `love.mousereleased(x, y, button)`

They both provide the coordinates of where the mouse interaction occurs, as well as the button being pressed on the mouse (left, right).

To consider mouse inputs in other modules other than the three `love` functions, the same technique used for previous games and keyboard input is used. The idea is to create two functions, `wasPressed` and `wasReleased`, and attach them on the `love.mouse` module.

In detail, the functions consider whether or not the cursor was pressed/released, on the basis of the value stored in a table.

```lua
function love.load()
  love.mouse.buttonPressed = {}
  love.mouse.buttonReleased = {}
end

function love.mousepressed(x, y, button)
  love.mouse.buttonPressed[button] = true
end

function love.mousereleased(x, y, button)
  love.mouse.buttonReleased[button] = true
end

function love.mouse.wasPressed(key)
  return love.mouse.buttonPressed[key]
end

function love.mouse.wasReleased(key)
  return love.mouse.buttonReleased[key]
end
```

With this setup, the game considers mouse input in the `update(dt)` function, and before resetting the values of the two tables.

```lua
function love.update(dt)
  gStateMachine:update(dt)

  love.mouse.buttonPressed = {}
  love.mouse.buttonReleased = {}
end
```

## Update

In the demo, the functions are used to have the box move vertically and in opposite directions:

- have the box rise as the mouse gets pressed

  ```lua
  if love.mouse.wasPressed(1) then
    boxBody:setLinearVelocity(0, -200)
    world:setGravity(0, 0)
  end
  ```

- restore the gravity and have the box plummet back to the ground as the mouse gets released

  ```lua
  if love.mouse.wasReleased(1) then
    boxBody:setLinearVelocity(0, 0)
    world:setGravity(0, 300)
  end
  ```

In both instances `1` describes the left button.
