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

## Goal

With this update I will forgo the time-based animations and create the different states, which can be alternated by pressing enter or a selection of keys. Here's the goal of the update:

- introduce a start state in which the title and a menu are shown;

- when pressing enter go to the play state, which incorporates the functional board;

- when pressing a key, go to the gameover state, showing an appropriate message;

- when pressing enter go back to the start state.

Lather, rinse, repeat.

Ultimately the gameover state ought to be shown when a timer hits 0. Ultimately there needs to be a victory, or level state showing the level being reached, but to get started with the structure of the game this seems to be enough.

## Getting Started

Using the same assets introduced in Flappy Bird, and reiterated in breakout, the folder is restructured as to include:

- `StateMachine.lua`, in the `src` folder;

- the different states in the the `src/states` sub-folder. Starting with `BaseState.lua`, from which all following states inherit.

To include these components, `Dependencies.lua` is updated to require each one of the `.lua` files.

## main.lua

The entry point to the game is updated as to include an instance of the state machine and immediately move the game to the `StartState`. I also modified the file to remove any reference to the board, included later in the `PlayState`, and rearranged a bit the code, in the hope of making it easier to parse through.
