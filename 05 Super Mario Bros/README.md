# Super Mario Bros

The fifth exciting project in the intro to game development course allows to create a 2D platformer with the **lua** programming language and the **love2D** game engine.

The video, for reference, is available [right here](https://youtu.be/_cPwFo--1LA).

The game inspiring the project is **Super Mario Bros**. Its dynamics are deceptively straightforward: control a character on a 2D plane, have it move, jump, collect points and hit enemies. Behind this simple look however, the game offers plenty of complexity and opportunities to learn.

## Topics

- tile maps. The game world is made up entirely of tiles, which need to be positioned on the screen according to specified coordinates.

- 2D animation. The character is animated when it moves and jumps, to emulate a more realistic change.

- procedural level generation. Levels are be created on the basis of tile maps to be entirely random.

- platformer physics. The game is set to react to the position of the character vis a vis the surrounding tiles.

- basic AI. The enemies introduced in the game are set to pursue the character.

- powerups. The character is scheduled to become more powerful as powerups are collected.

## Project Structure

Upon watching the first fifteen minutes of the video, and from analysing the [repo](https://github.com/games50/mario), it is possible to see how the project is developed first describing the different features. To match this subdivision, and just like with **Match Three**, I therefore decided to structure the project as follows:

- in preparatory folders you find the different features, as developed alongside the video;

- following the completion of these important concepts, you find the folders actually developing the game. These will describe the project in increments, following the naming convention in which each successive update is described by a greater integer (Mario 1, Mario 2 and so forth and so on).
