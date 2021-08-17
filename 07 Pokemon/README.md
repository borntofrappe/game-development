## 07 Pokemon

The eight title in the course introduces role-playing games with a demo inspired by the Pokemon series.

## Topics

- state stacks, an alternative to state machines

  The idea is to have a series of states _stacked_ one atop the other. Consider for instance having a field state, displaying the level, and a dialog state displaying a message above the level.

- turn-based systems

- graphical user interfaces, or GUIs, presenting information in panels, text boxes

- RPG mechanics, like damage, experience points

## Project structure

The game is developed in increments, but

Start from `StateStack`, which describes the concept of the stack used throughout the game. Beyond this folder, the game is developed in increments:

0. create a start state with a title and a looping animation

1. add a play and dialogue state. Update the stack to move between the individual states

2. introduce the `FadeState` to transition between states

3. render an entity in the `PlayState`

4. initialize a player class, with an idle and walking state

5. generalize the dialogue state

6. introduce the battle state

7. add a pokemon and level class; consider grass tiles in the walking state

8. add graphical user interfaces

9. incorporate GUIs in the logic of the individual states

10. add pokemon statistics

11. refactor battle states

12. add experience, react to a pokemon reaching zero health points

`Pokemon — Final` shows the game as close as to the one proposed in the video as possible (notice that the way I developed some of the features differs considerably from the lecturer's implementation). `Pokemon — Assignment` updates the demo to complete the assignment.

## Resources

- [Pokemon](https://youtu.be/gx_qorHxBpI)

- [Project assignment](https://docs.cs50.net/ocw/games/assignments/7/assignment7.html)
