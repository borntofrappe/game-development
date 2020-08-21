Recreate the popular game _Space Invaders_.

## Design

For the font, I decided to use the same font introduced in _Pong_.

For the graphics, you find in the _res_ folder a spritesheet for the visuals of the game. The following table works as a reference for the size of the individual shapes.

| Visual      | Width | Height |
| ----------- | ----- | ------ |
| Alien       | 24    | 21     |
| Bonus Alien | 39    | 18     |
| Player      | 27    | 21     |
| Projectile  | 3     | 15     |

## Update 0 — title

Render a screen with the title, above a basic instruction on how to proceed. Use the `timer` module from the **knife** library, to animate the scene.

_Please note_: the state specifies a hard-coded high score, to illustrate how to display such a record. Ultimately, the idea is to update the value with the player score achieved during the game.

_Please note_: future updates modifies _main.lua_ to have the game immediately start from the play state. This is to speed up the development, but ultimately the state is reached from the title screen, and by pressing enter.

## Update 1 — player

Render the quad making up the player's visual, and allow to move said visual horizontally.

## Update 2 — aliens

Render rows of aliens using the three variants provided in the spritesheet, one row after the other.

`GenerateQuadsAliens` is built to provide a table where each alien has two variants. Ultimately, the idea is to use the second variant to animate the shape.

A timer is included to illustrate how the animation would actually take place.

## Update 3 — bullet

Fire a bullet and detect collision with the static aliens. In keeping with the super game boy version, there should be only one bullet at a time.

## Update 4 — rows of aliens

Include the aliens in rows. Move the rows horizontally and vertically when when they bounce with the game's window.

## Update 5 — round and victory

Introduce the round state for a brief period of time, and always before the play state.
