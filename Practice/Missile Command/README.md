# Missile Command

![A few frames from the demo "Missile Command"](https://github.com/borntofrappe/game-development/blob/main/Practice/Missile%20Command/missile-command.gif)

## Notes

[Missile Command](https://en.wikipedia.org/wiki/Missile_Command) is a popular arcade game where you are tasked to defend a few structures from incoming, ballistic missiles by launching anti-ballistic missiles from ground level.

Here I try to develop the game taking inspiration from the Game Boy version. I am focused on recreating the structure of one of the game's level, where you defend the city of Cairo, with two launch pads of 15 missiles each and six towns to protect.

## Prep

The biggest challenge for the project is how to render the missiles in a gradual manner. This is because the missiles are represented by a line, highlighting their position and trajectory through a solid trail. In the `Prep` folder I try to implement the necessary animation:

- `Line Vertices` shows how `love.graphics.line` is able to render the missile and its trail by connecting two vertices

- `Line Points` draws a line with multiple points. The idea is to consider points in increments until the line is complete.

  Note the use of the variable `RESOLUTION`, to reduce the number of points in the final table. Without this constant the number of points is excessive and tends to cause issues with how long the animation should last. Consider for instance 300 points: if you wanted the animation to last 1 second, the necessary interval would be `1/300`, clashing against delta time `dt`

## Game

### Data

The `Data` class keeps track of the number of points accumulated in the game, but also describes the towns and launch pads included in the level. For the structures and their position, notice the use of the variable `level`.

```lua
local level = "xoxxxxox"
```

Here the idea is to loop through the string and for each character create a new structure: a town for every `x`, a launch pad for every `o`. Having a string helps to potentially create different configurations, and provides a quick and easy way to center the structures. It is enough to know the size of an individual structure to know the dimensions of the entire set.

_Please note:_ even though you can create a level with different configurations, the play state is equipped to handle two launch pads.

### Missiles

It is reasonable to assume that the missiles move at constant speed, and the further a projectile travels, the longer it should take to reach its destination. In light of this, the interval is set up considering the number of points and a scaling factor.

```lua
Timer:every(
    updateSpeed * #self.points,
    function()
      -- update points
    end
)
```

Since you use the number of points, consider that the interval changes as you change the resolution of the line as well.

### Launch pads

Each launch pad begins with an arbitrary number of missiles. Which pad then fires then pressing the `return` key depends on this capacity as well as the pad being available — consider the `inPlay` boolean — _and_ the horizontal position of the track ball. The idea is to divide the screen in two and allow, if possible, to reach the destination from the respective half.
