# Grand Prix

Accelerate and avoid slower cars to reach the finish line in record time.

![Grand Prix in a few frames](https://github.com/borntofrappe/game-development/blob/master/Practice/Grand%20Prix/grand-prix.gif)

## The game

[Grand Prix](<https://en.wikipedia.org/wiki/Grand_Prix_(video_game)>) is a video game developed for the Atari 2600 where you are tasked to accelerate, move on the y-axis to avoid slower cars until an arbitrary finish line.

## Resources

In the `res` folder you find few supporting resources:

- `fonts` provides a font with a pixelated look

. `graphics` includes the spritesheet I created with GIMP. The image describes four different vehicles, each with a slight modification to animate the otherwise static picture, and four types of textures, repeated to build the level one tile at a time

. `lib` houses three libraries to

    1. help and animate the cars by shuffling through the quads

    2. scale the dimensions of the game to preserve the pixelated look with a wider and taller window

    3. manage time events, like delays and tween animations

## Cars movement

The car describing the player does not move. Instead, the tiles in the background move, and the speed at which changes depending on a few factors:

- the player uses the right or left arrow keys

- the player collides with another vehicle

- the player moves outside of the track

The cars describing the other actors of the game do move, and scroll _with_ the tiles. By having the speed different from that of the horizontal scroll, the game creates the illusion that the player approaches or distances itself from the scene.

Note that the `Car` entity does not have a value for the speed. Instead, the field is included on the instances created for the slower competitors.

```lua
local car = Car:new(x, y, color)
local speed = -- compute speed
car.speed = speed
```

## Finish

Up to the finish state, the game uses the same set of tiles, resetting the horizontal coordinate whenever the offset reaches the width of the window (technically, the virtual window).

To signal the end of the game, then, the finish state includes a different set of tiles. Two sets actually: one for the finish line, one for the track exactly like the previous collection, to preserve the illusion of consistency.

As the tiles scroll to the left and reach the player, the state is finally able to assess the end of the race.
