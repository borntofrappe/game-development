Recreate the popular game _Space Invaders_.

## Design

For the font, I decided to use the same font introduced in _Pong_.

For the graphics, you find in the _res_ folder a spritesheet for the visuals of the game. The following table works as a reference for the size of the individual shapes.

| Visual      | Width | Height |
| ----------- | ----- | ------ |
| Alien       | 24    | 21     |
| Bonus Alien | 39    | 18     |
| Player      | 27    | 21     |
| Projectile  | 3     | 18     |

## Update 0 — title

Render a screen with the title, above a basic instruction on how to proceed. Use the `timer` module from the **knife** library, to animate the scene.

_Please note_: the state specifies a hard-coded high score, to illustrate how to display such a record. Ultimately, the idea is to update the value with the player score achieved during the game.

## Update 1 — player

Render the quad making up the player's visual, and allow to move said visual horizontally.

_Please note_: the update modifies _main.lua_ to have the game immediately start from the play state. This is to speed up the development, but ultimately the state is reached from the title screen, and by pressing enter.
