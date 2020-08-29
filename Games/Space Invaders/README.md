Recreate the popular game _Space Invaders_.

## Updates

- fix: add audio file for the bonus alien

- style: change the design for the aliens' bullets

- style: animate "PLAY" in the state showing the number of points awarded for each alien

- feature: add shields

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
