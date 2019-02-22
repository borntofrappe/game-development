# Chaining

Chaining is a concept tightly connected to time-based events, and relates to how changes are introduced one after the other, as if on a schedule.

## First Approach - conditional.lua

To attempt a first chain of events, a shape is animated to move from corner to corner of the screen as follows:

- create a table describing the various points on the screen where the shape should go. The idea is to have each successive value be the reference point in the shape's movement;

```lua
destinations = {
  [1] = {
    x = VIRTUAL_WIDTH - 25,
    y = 0
  },
  [2] = {
    x = VIRTUAL_WIDTH - 25,
    y = VIRTUAL_HEIGHT - 25
  },
  [3] = {
    x = 0,
    y = VIRTUAL_HEIGHT - 25
  },
  [4] = {
    x = 0,
    y = 0
  }
}
```

- to each 'destination' add a boolean determining whether the destination has been reached. This flag could be added in the declaration, but it is included through a for loop.

```lua
for k, destination in pairs(destinations) do
  destination.reached = false
end
```

- in the `update(dt)` function move the shape on the basis of conditional statements, altering the properties based on which corner was reached. It becomes evident here that there are a lot of variables to track and update, starting from the coordinates of the shape, the passing time, the offset included in each coordinate. Indeed as the shape can move in more than one direction, it is necessary to have a variable keep track of the current position (in the code `baseX` and `baseY`).

### Lua Detour

The code makes use of `ipairs` instead of `pairs`, and this has to do with the data structure chosen for the destinations. As seen [here](http://lua-users.org/wiki/TablesTutorial), `ipairs` proves to be more reliable to go through a table.

> Unlike pairs it only gives you the consecutive integer keys from 1. It guarantees their order sequence.

It seems `ipairs` is tailored for ordered tables, such as the one defining the destinations. `pairs` doesn't guarantee the same order. In light of this:

- in the `update` function we want to go through the table in order, so we use `ipairs`.

- in the `load` function we want to include the `reached` key irrespective of order, so both solutions work.
