The sixth installment goes through a top-down dungeon-crawler inspired by The Legend of Zelda.

## Topics

- top-down perspective

- infinite dungeon generation

- hitboxes (areas where the entity inflicts damage) and hurtboxes (areas where the entity receives damage)

- events (executing a chunk of code following a specific action/situation)

- screen scrolling (transitioning between two different levels)

- data-driven design (the engine builds the game based on data rather than logic)

## Project structure

I decided to break down the final game into demos curating parts of the final game. For instance, `Spritesheet` explores how the `love.graphics.newQuad` function sections the textures for the entities and rooms. In `Stencil` I consider the concept of a stencil and in `Scrolling` I consider the movement between rooms.

From these folders, the game is developed in increments following the convention introduced in past titles, `The Legend of Zelda 0`, `1` and so forth.

<!--
- title, play, gameover state
- spritesheet 16x16, random tiles for the left/top/right/bottom gates, corners for the corners,
- entities, definitions
- spritesheet 32x32 with padding
- entities similar to pokemon

- top-down perspective

  - shadows
  - corners
  - skewed/tilted walls

- dungeon generation

  - room as a fundamental unit. Have a table describing rooms
    {
    {room, room, room, nil}
    {nil, nil, room, room},
    {nil, room, room, room}
    }

  ensure a connection

  world folder describing dungeon (models dungeon and rooms, animates between rooms), room (individual room, one active at a time, rendering tiles, keeping track of player, entities and objects), doorway

- screen scrolling current room, next room, tween adjacent room

-->

## Resources

- [The Legend of Zelda](https://youtu.be/SPAffu3ivIM)

- [Project assignment](https://docs.cs50.net/ocw/games/assignments/5/assignment5.html)
