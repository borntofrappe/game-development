# Alien Jump

## Notes

I'll jot down a line or two describing the main concepts/features. The idea is to elaborate more as the game is developed and the choices are cemented in the codebase.

- resources from _05 Super Mario Bros_

- state stack from _08 Pokemon_

- game states:

  - start, by default, pop when pressing the enter key

  - scroll, push the pause state when pressing the down/lowercase s key

  - pause, pop from the stack when releasing the down/lowercase s key

- player states: idle, walk, jump, squat
