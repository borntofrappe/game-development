# Physics

Here I explore how to physics ultimately included for both players.

## Range

The game is based on two values, a velocity `v` and and angle `theta`. Based on these, and on a constant gravity `g` roughly set to `9.81`, a cannonball moves by an amount equal to the following.

```math
range = (v ^ 2 * math.sin(2 * theta)) / g
```

The demo uses the formula with a set value for the velocity and angle, but allows to modify each value by pressing the arrow keys `up` and `down`. The value being modified is changed by pressing the `v` and `a` key.

It is important to note that `theta` is a value in radians, while the angle in the game is introduced in degrees. `math.rad` allows to convert to the desired format.
