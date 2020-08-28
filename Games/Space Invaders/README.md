Recreate the popular game _Space Invaders_.

## Updates

- [x] add record audio

- [x] minor fixes

  - [x] remove dev functions

  - [x] pixel error when rendering the particles for the player

  - [x] render bullets behind aliens

- [ ] add shields

- [ ] improve aliens AI to have the bullets fired in the vicinity of the player

## Design

For the font, I decided to use the same font introduced in _Pong_.

For the graphics, I used GIMP to create the spritesheet you find in the "res" folder. The following table works as a reference for the coordinates and sizes of the individual shapes. The information is most relevant for "Utils.lua", where the quads are generated from the single image.

| Visual               | x   | y   | Width | Height |
| -------------------- | --- | --- | ----- | ------ |
| Alien                | 0   | 0   | 24    | 21     |
| Bonus Alien          | 0   | 63  | 39    | 18     |
| Player               | 0   | 81  | 27    | 21     |
| Bullet               | 29  | 87  | 3     | 15     |
| Particles (type 1-3) | 48  | 0   | 24    | 21     |
| Particles (type 4-5) | 42  | 66  | 30    | 18     |
