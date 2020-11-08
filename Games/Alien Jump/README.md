# Alien Jump

## Notes

I'll jot down a line or two describing the main concepts/features. The idea is to elaborate more as the game is developed and the choices are cemented in the codebase.

- resources from _05 Super Mario Bros_

- state stack from _08 Pokemon_

- game states, with a state stack:

  - start, by default, pop when pressing the enter key

  - scroll, push the pause state when pressing the down/lowercase s key

  - pause, pop from the stack when releasing the down/lowercase s key

- player states, with a state machine (delegate the animation/functionality to each state, render in the player class):

  - idle, by default

  - walk, from the scroll state

  - jump, when jumping and staying above the ground level

  - squat, from the pause state

- game & player states: it is only when the player is walking that the player can squat. It is also only when the player squats that the game should pause itself. I can see two approaches to this conundrum:

  - prevent pushing the pause state unless the player is at ground level

  - give knowledge about the state stack to the player, and have the player modify the state stack directly
