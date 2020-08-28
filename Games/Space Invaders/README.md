Recreate the popular game _Space Invaders_.

## Updates

- [x] fix lastRow bug — only the aliens in the last row should fire a bullet

- [x] cap at `x` the number of bullets that aliens are able to shoot

- [x] fix how the bullets and particles are added/removed to the table

- [ ] detect collision with the aliens' bullets

  - [ ] show particles animation

  - [ ] round state (health > 0)

  - [ ] gameover state (health == 0)

- [ ] add shields

- [ ] improve aliens AI to have the bullets fired in the vicinity of the player

## Design

For the font, I decided to use the same font introduced in _Pong_.

For the graphics, I used GIMP to create the spritesheet you find in the "res" folder. The following table works as a reference for the size of the individual shapes, and supports the logic described in "Utils.lua".

| Visual               | Width | Height |
| -------------------- | ----- | ------ |
| Alien                | 24    | 21     |
| Bonus Alien          | 39    | 18     |
| Player               | 27    | 21     |
| Bullet               | 3     | 15     |
| Particles (type 1-3) | 24    | 21     |
| Particles (type 4-5) | 30    | 18     |
