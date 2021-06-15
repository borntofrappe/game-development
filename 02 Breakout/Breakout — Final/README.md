# Breakout — Final

## State

The game introduces a more complex structure in terms of state. Consider the following chart as a reference.

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

By pressing `escape` in the paddle select, serve, play or victory state the game moves back to the start screen (symbolized by the asterisk character `*`). Otherwise, the game is quit altogether.
