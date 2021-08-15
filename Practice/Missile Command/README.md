# Missile Command

## Notes

[Missile Command](https://en.wikipedia.org/wiki/Missile_Command) is a rather popular arcade game where you are tasked to defend a few structures from incoming ballistic missiles. This is achieved by launching anti-ballistic missiles from ground level, in order to intercept the projectiles.

Here I try to develop the game taking inspiration from the Game Boy version. I am focused on recreating the structure of one of the game's level, where you defend the city of Cairo, with two launch pads of 15 missiles each and six towns to protect.

## Prep

The biggest challenge for the project is how to render the missiles, ballistic and anti-ballistic, in a gradual manner. This is because the missiles are represented by a line, highlighting their position and trajectory through a solid trail. In the `Prep` folder I try to implement the necessary animation:

- `Line Vertices` works to highlight how `love.graphics.line` is able to render the missile and its trail by connecting two vertices

- `Line Points` takes the rudimentary demo to instead draw a line as the result of multiple points. The idea is to use more and more points until the line is complete.

  Note the use of the variable `RESOLUTION`, to reduce the number of points in the final table. Without this constant the number of points is excessive and tends to cause issues with how long the animation should last. Consider for instance 300 points;if you wanted the animation to last 1 second the necessary interval would be less than delta time, `dt`.
