# Bouldy

The game has the player move inside of a maze, bound by its walls and gates. With every step of uninterrupted movement, the player gains speed, and hitting an arbitrary threshold, it is able to destroy gates in order to pass through. It is an excellent excuse to implement a maze structure with the recursive backtracker algorithm, create a GUI element in the form of a progress bar and rehearse Love2D particle system.

## Prep

In the `prep` folder I explore Love2D particle systems to create two effects: dust and debris. The first is programmed to show the movement of the player inside of the maze, and creates a cloud of dust with increasing intensity; the idea is to show the varying speed by emitting a different number of particles. The second is scheduled to display a gate in the maze being destroyed; given the solid nature of the wall, the visual used in this instance far more rectangular, taller than wider.

The biggest distinction between the two particle system boils down to the following:

- `particle-dust` animates the opacity of the particles, by setting the alpha channel of the images to `0` with `particleSystem:setColors()`

- `particle-debris` emits particles in a specific area with `particleSystem:setEmissionArea`; this allows to span the particles from the surface of the gate, as opposed to a specific point

## Game

`main.lua` is heavily commented, and should be able to explain much of the project, but here a few notes on the project folder.

### Maze

Picking up from the code developed for [borntofrappe/code/Maze Algorithms](https://github.com/borntofrappe/code/tree/master/Maze%20Algorithms), the script creates a maze with the recursive backtracker algorithm.

Refer to the cited repository for more information on the inner workings of the algorithm.

### Timer

`Timer.lua` is a utility I first developed for the game _Petri Dish_. It is here used with a modification to the `Timer:every` function. This one receives an additional argument, describing whether or not the code of the callback function should be executed immediately.

```lua
function Timer:every(dt, callback, isImmediate, label)
  -- add interval to self.intervals

  if isImmediate then
    callback()
  end
end
```

### Update

The two booleans `isUpdating` and `isGameover` are used to manage the state of the game. `isUpdating` specifically is used to avoid running multiple intervals at the same time, while `isGameover` is introduced to reset the game after a delay.

I tried to encapsulate the game's logic in `Timer:every`, so that the code is not continuously executed as in `love.update(dt)`. This last function is devoted solely to update the timer and the particle systems.

```lua
function love.update(dt)
  Timer:update(dt)
  particleSystemDust:update(dt)
  particleSystemDebris:update(dt)
end
```
