# Breakout

## Preface

For the [third video](https://youtu.be/pGpn2YMXtdg) in the intro to game development @cs50, the game breakout allows to cover the following topics:

- sprite sheets (large image files, of which a desired section is shown);

- procedural generation (laying bricks with different colors);

- state (a more specific way to manage the state);

- levels (progression system, influencig the generation of the levels);

- player health (in the form of hearts);

- particle systems (aesthetical pleasing addition to highlight a collision between ball and bricks);

- collision detection (once more);

- persistent data (to show the high scores of the game).

## Introductory Remarks

The game is set to play out with the following state chart as a reference:

```text
------ start ←----------------------------------
|         |                                     |
|         |                                     |
|        ↓ ↑                                    |
|     high score ← -- enter high score ←-- game over
|                                               ↑
|                                               |
 ----→ paddle select ----→ serve  ----→ play -- |
                             |           |
                             |           |
                             ↑           |
                         victory ←-------
```

There's a rather more complex flow to the game, most notably due to the presence of the screen showing the high scores
