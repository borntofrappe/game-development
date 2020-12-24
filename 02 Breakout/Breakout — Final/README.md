The game introduces a more complex structure in terms of state. Consider the following made-up chart for a reference.

```txt
         *
         ↓
 ----- start ←---------------------------------
|       ↓  ↑                                   |
|     highscores ←--  enterhighscore  ←-- gameover
|                            ↓                 ↑
|            *               *          *      |
|            ↑               ↑          ↑      |
 -----→ paddleselect ----→ serve ←---→ play -- |
                             |           | ↑
                             ↑           |  --→ pause
                    * ←-- victory ←-------
```

The path described with an asterisk `*` is accessed by pressing `escape`. For the other states, pressing the same key has the effect of terminating the game.
