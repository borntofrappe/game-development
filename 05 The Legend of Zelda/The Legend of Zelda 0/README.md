The game is ultimately composed of three states: title, play and gameover. Most of the logic is in the play state, but to get started, it is helpful to set up the game's infrastructure.

With this first update, I include a state machine, the three mentioned states and two libraries used in the project: `Class`, and `push`. The first one is necessary for object-oriented programming, while the second is helpful to scale the pixelated images to a larger size, without losing the crisp, pixelated nature of the texture.

In the `Spritesheet` demos, I didn't use the library, but manually scaled the quads to show the characters/entities larger than their original design.
