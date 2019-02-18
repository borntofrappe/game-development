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

## Update

Just like for flappy bird, I decided to introduce the final project as breakout 13. There isn't any actual update 13, but the idea is to take the preceding 12 updates and finalize the game. Starting with a revision of the codebase and continuing with the assignment.

### State

Here's the revised structure of the game.

```text
------ start ←----------------------------------
|         |                                     |
|         |                                     |
|        ↓ ↑                                    |
|     high score ← -- enter high score ←-- game over
|                                               ↑
|                                               |
 ----→ paddle select ----→ serve  ----→ play -- |
                             |           | ↑
                             |           | |
                             ↑           |  --→ pause
                         victory ←-------
```

Nothing major changed from the introductory README, except for the addition of the pause state.

### Code Changes

While going through the different files, I updated the comments and included the following changes:

- the table of high scores is no longer a global variable. In keeping in line with the course, I decided to make it a variable which is passed to any state which may need it.

- the `displayHealth` function has been modified as to accept also `maxHealth`. This allows to more easily develop a feature in which the health is increased as the game progresses.

- the way the `GameoverState` identifies a high score has been overhauled, from considering the scores in the local `lst` file to analyse the table of high score. This is a much less challenging endeavor, as looping through a table is much easier than cycling though a file of line separated names and scores.

- sound played through the different instances of the `:play()` function has been updated, to aptly consider the different choices (using for instance the `confirm` sound file when choosing a paddle, entering the high score), and most importantly to make use of other files included in the `gSounds` table. The victory and high score soundbite come particularly to mind.
