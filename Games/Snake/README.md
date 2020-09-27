# Snake

Recreate the popular game starting with squares of different color.

<!--

## Debugging secrets

I've decided to include helper structures to ease the development of the game. These are mapped to specific keys.

| Key    | Brief             |
| ------ | ----------------- |
| g or G | Toggle grid lines |

-->

## State

The idea is to have the game divided in two stages, one showing the title, and one dedicated to actually playing the game.

In the title screen, however, I still plan to include the snake, perhaps even a dumbed down version of the game, played by the computer instead of following user input.

Refer to the following for a simplified description of the state's flow.

```text
TitleScreenState ----> PlayState
```
