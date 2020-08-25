Recreate the popular game _Space Invaders_.

## Updates

- [ ] Fix the horizontal scroll so that the aliens change direction only when the first/last _available_ column approaches the window's edges. In the previous version, the game considered a bounce with the first/last column regardless of whether the aliens in said column existed or not.

- [x] Slow down the frequency with which the aliens move

- [x] Describe dy movement similarly to dx

- [x] Clear timer in round state

- [ ] Change the frequency as the player destroys a certain number of aliens

- [x] Add score table state

- [ ] Detect a loss when the aliens reach the bottom of the screen

- [ ] Allow the aliens to fire back at random

- [ ] Add lives and detect collision with the aliens' bullets

- [ ] Add shields

- [ ] Improve aliens AI to have the bullets fired in the vicinity of the player

## Design

For the font, I decided to use the same font introduced in _Pong_.

For the graphics, I used GIMP to create the spritesheet you find in the "res" folder. The following table works as a reference for the size of the individual shapes, and supports the logic described in "Utils.lua".

| Visual      | Width | Height |
| ----------- | ----- | ------ |
| Alien       | 24    | 21     |
| Bonus Alien | 39    | 18     |
| Player      | 27    | 21     |
| Projectile  | 3     | 15     |
