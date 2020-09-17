Incorporate changes from the lecturer's code:

- include a state machine for the game

- render and move the player in the play state

## Depencencies

The file requires the libraries and other `lua` files developing the game, but it also includes global variables previously defined in the body of `love.load`.

```lua
gFonts = {}
gTextures = {}
gFrames = {}
```

## constants.lua

The game window is increased, but this has the unfortunate effect of having a black bar at the bottom of the screen. This is because the actual height of each background is smaller than `VIRTUAL_HEIGHT`. This is fixed in one of two ways:

- render two copies of the background, and have the second flipped at the bottom of the screen

  ```lua
  love.graphics.draw(gTextures["backgrounds"], gFrames["backgrounds"][self.background], 0, 0)

  love.graphics.draw(
    gTextures["backgrounds"],
    gFrames["backgrounds"][self.background],
    0,
    BACKGROUND_HEIGHT,
    0,
    1,
    -1,
    0,
    BACKGROUND_HEIGHT
  )
  ```

- modify `background.png` to have the backgrounds as tall as the game window.

I chose the latter option, and modified the image accordingly.

## main.lua

### Input

To register which key is being pressed, the game repeats the technique introduced in previous games:

- add a table to the `love.keyboard` module

- following a keypress use the key to mark a boolean in the table

- define a method to return if a particular key was pressed in the previous frame, and based on the value of the boolean

### State

The state machine works with two states: start and play.

In `StartState`, the game generates a level through the `LevelMaker.generate` function — more on this later — and renders the map above a background.

In `PlayState`, the game renders a different level, but always using the `LevelMaker.generate` function. On top of this level, the state also introduces the player, player movement, and camera scroll.

## LevelMaker.lua

The class includes the logic previously developed in the "Prep" folders and specifically the "Level 2" demo. In a future update, it will be modified to build a more complex table, and one which will include a tilemap as well as instances of a `Tile` class.

## Player.lua

Similarly to the level maker, the class includes the logic developed in the "Prep" folders, and considers the code describing how the player is defined and rendered. The lecturer's code has a more complex implementation, and one that contemplates a more general class from which the player inherits — `Entity`. This will be however the topic of a future update.
