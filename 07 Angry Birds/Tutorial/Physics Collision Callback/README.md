# [Tutorial:PhysicsCollisionCallbacks](https://love2d.org/wiki/Tutorial:PhysicsCollisionCallbacks)

Building on top of the progress achieved in the `Tutorial — Physics` folder, the demo follows the tutorial to react to a collision between two objects. The relevant function is [`World:setCallbacks`](https://love2d.org/wiki/World:setCallbacks).

## Tutorial update

From the mentioned starting point, the objects are modified to have a distinct label on each body. This using the `setUserData`](https://love2d.org/wiki/Fixture:setUserData) function on the fixture.

```lua
objects.ball.fixture:setUserData("ball")
```

One of the two blocks is also removed, to have the demo focus on the collision between ball and the one block.

## Callback

`:setCallbacks` accepts up to four arguments, specifying callback functions which are executed considering the lifecycle of a collision:

```lua
world:setCallbacks(beginContact, endContact, preSolve, postSolve)
```

In is then up to you to design the functions.

```lua
function beginContact() end
function endContact() end
function preSolve() end
function postSolve() end
```

The functions are able to work with a set of arguments:

- two objects describing the fixtures involved in the collision

- an object describing the contact

Focusing on the objects, it is here that the label used through `setUserData` comes in handy. It is indeed possible to examine the object to trigger a certain behavior if the collision involves a desired set of fixtures, like the ball and the block.

```lua
function beginContact(f1, f2)
  if (f1:getUserData() == "ball" or f1:getUserData() == "block") and (f2:getUserData() == "ball" or f2:getUserData() == "block") then
    -- do something
  end
end
```

In the demo, the function changes the value of a string, as well as a counter to describe the number of collisions involving the two bodies.

### Contact

In addition to the objects involved in the collision, the functions provide more information through a [`contact`](https://love2d.org/wiki/Contact) object.

```lua
function beginContact(f1, f2, contact) end
```

This is used for instance to acquire the coordinates of the actual collision.

```lua
function beginContact(f1, f2, contact)
  x, y = contact:getPositions()
end
```

_Be warned_: there exist `getPosition`, but this is for an older version of love2d. `getPositions` plural provides the points of where the fixture collide, and there can be multiple points.

```lua
function beginContact(f1, f2, contact)
  x1, y1, x2, y2 = contact:getPositions()
end
```

Consider that lua is quite accommodating when the number of variables doesn't match the number of values returned by a function. Superfluous, as in excessive, variables are set to `nil`.
