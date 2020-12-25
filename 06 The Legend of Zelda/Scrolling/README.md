# Scrolling

_Please note_: `Timer` is a utility I developed for the projects in the _Games_ folder. It is not ultimately used in the project, as the lecturer prefers the module of the `knife` library, but it has a similar syntax.

As the player approaches an opened door, the idea is to simulate the exploration of the dungeon by translating the current room one of sight, while at the same time translating a new room in its place. To this end, the script considers `currentRoom`, `nextRoom` and `translate` with the following logic:

- render current room and, if existing, the next room

- as one of the arrow keys is pressed, instantiate a new room

  ```lua
  nextRoom = newRoom()
  ```

- translate the rooms in the direction expressed by the arrow key.

  To this end, `ROOM_TRANSLATIONS` is initialized to describe the change to which the current room is subject, in the `x` and `y` dimensions. For instance and when the player proveeds up, the `y` coordinate is reduced by `WINDOW_HEIGHT`, so to have the room move upwards.

  ```lua
  ROOM_TRANSLATIONS = {
    ["up"] = {
      ["x"] = 0,
      ["y"] = -WINDOW_HEIGHT
    }
  }
  ```

  Please note that `love.draw` includes two translations, one before the current room, one before the next one. It is important to mention that the first one affects both rooms, so that by translating its value, both rooms move in the desired direction.

  ```lua
  love.graphics.translate(translate.currentRoom.x, translate.currentRoom.y)
  -- render current room

  love.graphics.translate(translate.nextRoom.x, translate.nextRoom.y)
  -- render next room
  ```

- as the translation is complete, update the current room so that it refers to the next one, and reset this last variable to nil

  ```lua
  currentRoom = nextRoom
  nextRoom = nil
  ```

  Visually, remember to also reset the translation values, so that the room is immediately and again centered in the window

  ```lua
  translate.currentRoom.x = 0
  translate.currentRoom.y = 0
  translate.nextRoom.x = 0
  translate.nextRoom.y = 0
  ```
