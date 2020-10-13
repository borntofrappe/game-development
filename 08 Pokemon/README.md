The eight title in the course introduces the genre of RPGs by looking at the Pokemon series.

## To dos

- feature | add audio

- visual bug | have the selection overlap with the underlying panel

  ```diff
  -self.width = def.width or 72 + 2
  +self.width = def.width or 72 + 4
  ```

  _Note_: this was fixed with `Pokemon 10`

- secret | add the possibility to change the sprite of the player, picking at random from the available entities

  ```lua
  self.player.sprite = math.random(#gFrames["entities"])
  ```

## Topics

- state stacks, an alternative to state machines

  The idea is to have a series of states _stacked_ one atop the other. Consider for instance having a field state, displaying the level, and a dialog state displaying a message above the level.

- turn-based systems

- graphical user interfaces, or GUIs, presenting information in panels, text boxes

- RPG mechanics, like damage, experience points

## Project structure

The game is developed in increments, but the folder describes other demos to introduce relevant concepts. Consider for instance `StateStack`.

## Resources

- [Pokemon](https://youtu.be/gx_qorHxBpI)

- [Project assignment](https://docs.cs50.net/ocw/games/assignments/7/assignment7.html)
