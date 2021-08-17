# Bouldy

> A small pebble in a considerably large maze.

![A few frames from the demo "Bouldy"](https://github.com/borntofrappe/game-development/blob/master/Practice/Bouldy/bouldy.gif)

The goal of this project is to have the player move a square inside of a maze to collect a few coins. With every step of uninterrupted movement the player gains speed, allowing the player to optionally break through the surrounding gates — but not the edges of the window.

The project is an excellent excuse to practice with the following:

- the recursive backtracker algorithm to create a maze

- a GUI element in the form of a progress bar

- Love2D particle system

- the timer library as developed in `Utils/Timer`

## Timer

_Please note:_ it is likely this section will be outdated in the moment the changes are incorporated in the `Utils` folder.

The `Timer` library is modified to fit the needs of the project at hand, and specifically in the `Timer:tween` and `Timer:interval` functions.

### Tween

The project needs to execute code as a tween ends. Instead of pairing each `:tween` function with a delay — through the `:after` function — the idea is to accept an additional argument with a callback function.

```diff
-Timer:tween(dt, def, label)
+Timer:tween(dt, def, callback, label)
```

The code is then executed once the animation is complete.

```lua
if tween.timer >= tween.dt then
  if tween.callback then
    tween.callback()
  end
end
```

### Interval

It is annoying to wait for the first interval to actually update the game. With this in mind, the `:every` function receives an additional argument with a boolean, detailing whether or not to execute the callback function immediately.

```diff
-Timer:every(dt, callback, label)
+Timer:every(dt, callback, isImmediate, label)
```

There are several ways to implement the feature, but I chose to use the boolean to modify the initial value of the timer. If `true`, the timer is initialized to the amount of time necessary to promptly execute the callback function — always in the `Timer:update` method.

```lua
local interval = {
  ["timer"] = isImmediate and dt or 0,
  ["dt"] = dt,
  ["callback"] = callback,
  ["label"] = label
}
```

## Maze

The project implements the recursive backtracker algorithm as developed in [borntofrappe/code/Maze Algorithms](https://github.com/borntofrappe/code/tree/master/Maze%20Algorithms).

Refer to the cited repository for more information on how the algorithm actually works.

## Update

The movement of the player in the maze, the collision with the edges of the window or gates, the collecting of coins, in other words the logic of the game is nested in the interval set up through the `Timer` library.

`love.update(dt)`, the function called by Love2D every frame, is finally necessary to update the timer library and the particle systems.
