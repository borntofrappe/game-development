# Angry Birds 4

The demo includes the kinematic objects introduced with `Angry Birds 2`. I removed them in the update `Angry Birds 3` to have that folder focus on mouse input, but here they are useful to differentiate a collision between different objects.

## User data

The idea is to include and benefit from a label on the different objects. The relevant functions are here `setUserData()` and `getUserData()`, to respectively set retrieve the label.

```lua
box.fixture:setUserData("Box")
box.fixture:getUserData() -- Box
```

The label is essential in the moment a collision is detected between two objects.

## Callback

Callback functions are set on the world object to consider up to four events.

```lua
world:setCallbacks(beginContact, endContact, preSolve, postSolve)
```

The four describe functions which are fired at different stages, moments of a collision:

- `beginContact` and `endContact` are fired when two objects start and end a collision

- `preSolve` and `postSolve`, on the other hand, are fired _before_ and _after_ the collision has a chance of being resolved. `preSolve` could be useful for instance to change the default collision before it has a chance to happen

The functions themselves receive the fixture of the bodies involved in the collision, as well as an object describing their contact.

```lua
function beginContact(f1, f2, contact)

end
```

The last function `postSolve` also receives two additional values which describe _how_ the bodies move after the collision.

```lua
function postSolve(f1, f2, contact, normalInput, tangentInput)

end
```

This is important: the name of the functions, the name of the parameters are all arbitrary. Here I use a similar syntax as the one provided in the love2D wiki.

## Practice

In the demo, I decided to focus on describing the objects subject of a collision and specifically their label. Using the first callback function, the labels are stored in a variable and displayed in `love.draw`.
