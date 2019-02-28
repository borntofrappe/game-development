# Match Three 5 - State Machine

The previous updates have focused on a key feature of the game, but only a feature nonetheless. The board, allowing to swap, match and clear tiles needs to be incorporated into a larger structure, detailing the game from start to finish.

Considering the overall experience, the game can be described according to the following states:

```text
startState → playState
    ↑           |
    |           |
    |           ↓
     ----- gameoverState
```

It is not a complex structure, but the transitions introduced in between the states provide a bit of a challenge. Not to mention the transitions included in the states, like the title `Match 3` changing in color rapidly and one letter at a time.
