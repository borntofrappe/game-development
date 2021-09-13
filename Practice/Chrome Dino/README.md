# Chrome Dino

Google Chrome offers a [neat endless scroller](https://en.wikipedia.org/wiki/Dinosaur_Game) when the browser is offline.

## res

### Spritesheet

- ground 256 pixels by 10

- dinosaur 16 by 16 for the idle, walking and gameover states, 21 by 11 for the ducked down version

- cacti 12 by 16 for the two smaller versions, 15 by 24 for the larger piece

- cloud 25 by 8

- bird 19 by 16

<!-- ### Sound bytes -->

### lib

Timer library to manage delays, tweens, intervals

push library to scale the window while preserving pixelated look

Animation library to manage sprite animation

## src

State stack to manage the game. Global values for the dinosaur, ground coordinates and score
