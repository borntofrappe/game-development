## 06 Angry Birds

The seventh videos in the course introduces the game Angry Birds where the player throws an entity toward a target.

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

2. add a series of kinematic bodies

3. consider mouse input

4. detect collisions in the world

5. set up the game

6. in the play state, initialize a world with static edges and two dynamic shapes

7. recreate the start state with a bold title and a world based on the ball pit demo

8. refactor the code to have the logic pertinent to the aliens in its own class

9. include obstacles in the play state

10. react to a collision between game entities

11. move the player by dragging the cursor

## Resources

- [Angry Birds](https://youtu.be/9iYjOkRDzBs)

- [Love2D Physics](https://love2d.org/wiki/love.physics)

- [Box2D](https://box2d.org/)

- [Project assignment](https://docs.cs50.net/ocw/games/assignments/6/assignment6.html)
