## 06 Angry Birds

The seventh videos in the course introduces the game Angry Birds where the player throws an entity toward a target.

![A few frames from the assignment for "Angry Birds"](https://github.com/borntofrappe/game-development/blob/master/Showcase/angry-birds.gif)

## Topics

- physics with the Box2D library

- mouse input

## Increments

The `Prep` folder includes several demos to introduce the physics library:

- `Physics`: introduce the `love.physics` module which wrap around the Box2D library

- `Physics Collision Callback`: consider how Love2D manages events following a collision

- `Ball Pit`: simulate the physics resulting from an object falling in a set of small entities

Past these folders, the game is developed in `Angry Birds *` folders:

0. initialize a world and a body

1. simulate a dynamic body and solid ground

2. simulate a dynamic body and a series of kinematic bodies

3. consider mouse input

4. react to a collision between world objects

5. set up the game with a state machine

6. initialize a world with static edges and two dynamic bodies

7. introduce the gane with a bold title and a simulation similar to that introduced in `Prep/Ball Pit`

8. refactor the code to have the logic pertinent to the aliens in its own class

9. include obstacles

10. react to a collision between game entities

11. move the player by dragging the cursor

12. project the trajectory of the launch

## Resources

- [Angry Birds](https://youtu.be/9iYjOkRDzBs)

- [Love2D Physics](https://love2d.org/wiki/love.physics)

- [Box2D](https://box2d.org/)

- [Project assignment](https://docs.cs50.net/ocw/games/assignments/6/assignment6.html)
