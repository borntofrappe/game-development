# Space Invaders

The goal is to recreate the game <i>Space Invaders</i> while practicing with the concept of a state machine and a timer library.

![Space Invaders in a few frames](https://github.com/borntofrappe/game-development/blob/master/Practice/Space%20Invaders/space-invaders.gif)

## Resources

In the `res` folder I include the static assets used in the project, including `spritesheet.png`, which I created to describe the player and aliens, and `Timer.lua`, which I documented in the `Utils` folder as an alternative library to that introduced in the course.

_Please note:_ at the time of writing the timer library is actually different from that in the `Utils` folder, as I've modified the code following the progress made with <i>Space Debris</i>.

## Projectiles

The projectiles are included either in the `Player` or `Invaders` class. To accommodate for the two instances, `Projectile.lua` accepts as input not only the coordinates, but also the direction.

```lua
function Projectile:new(x, y, direction)
end
```

The idea is to directly modify the vertical value `dy` to move the sprite upwards or downwards for the player and invaders respectively.

The projectile class includes a boolean to also highlight whether or not the projectile should be removed from play. This happens when the projectile reaches the top or bottom edge of the window.

## Collisions

The project differentiates between three types of collision: invader, player and projectile. The difference mostly boils down to a different sprite, but in the instance of the player, there is also a tweak in logic.

In all instances, the classes are equipped with a `update` and `render` function. In the update logic the idea is to consider the passing of time to eventually remove the sprite from the window. Following a delay, or a certain number of repetitions for the player, the classes switch the `inPlay` boolean to `false`; this allows the wrapper class `Collisions` to remove the collisions from contention.

## Update

The bulk of the game happens in `PlayState`. Here the title is updated in two ways: with delta time and at an interval.

Delta time is useful to update the position of the player, projectiles, and to execute the logic of the different collisions.

The interval helps to move the invaders with a staggered motion. At an interval. `PlayState:setupInterval` implements the interval, and is called as soon as the game is instantiated, but also when the invaders reach the left or right edge of the window. In this instance the existing interval is removed in favor of a new one, running at a faster pace.

## Pause

It is possible to pause the game from the play state, and following a press on a specific key. To pause the interval, and instead of removing the functionality from the `Timer` object, I've chosen to have the existing interval persist, and just stop updating the timer.

When the game enters the play state, the timer resumes from its previous state.

To avoid setting up multiple, concurrent intervals, the play state conditions the `setupInterval` function to a specific boolean.

```lua
if params.setupInterval then
  self:setupInterval()
end
```

As the pause state doesn't specify the variable, `params.setupInterval` resolves to `false`.
