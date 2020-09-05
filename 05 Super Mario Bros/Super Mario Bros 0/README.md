Following the progress achieved in the "Tiles", "Character" and "Level" folders, refactor the game to provide a more modular structure.

## gGlobals

The variables describing the textures, frames, and soon fonts and sounds are moved from `love.load()` to the file describing the dependencies. This is to keep in line with the file organization of the assignment.

## StateMachine

The project incorporates the state machine developed in the previous games. The specific update contemplates a single state, to play a level, but at a later stage the game will include a state with the title screen as well.

## Character

In this class I migrated the instructions for the player. I've also included a few functions to move the player and change its appearance in a more declarative manner. With this update, it's enough to call `self.character:move(direction)` to have the character move in the desired direction. The actual implementation is in the `Character` class.
