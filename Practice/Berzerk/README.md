# Berzerk

[Berzerk](<https://en.wikipedia.org/wiki/Berzerk_(video_game)>)

## Spritesheet

In the `res/graphics` sub-folder you find the spritesheet used to render the player, the enemies, and the particles shown when an enemy is shot.

The player has five sprites, describing the idle, walking, shooting and loosing state. The walking state relies on two frames to highlight the movement.

The enemies are represented by a multiple of frames, for the idle and walking state. The walking state has three frames for each direction, describing the enemy moving down, right, up or left.

The particles are composed by two frames, shown rapidly one after the other.

Each frame is 8 pixels wide and tall.

## Colors

The game relies on a limited set of colors, described here in the rgb components required by Love2D (in the `[0,1]` range)

- player and projectiles: 0.949, 0.545, 0.694

- enemies and foreground: 0.824, 0.824, 0.824

- background: 0.09, 0.09, 0.09

- walls: 0.427, 0.459, 0.906

## Entities, player and enemies

Picking up from `04 Super Mario Bros` the idea is to have a class dedicated to the entities of the game. With this class the player and enemies share a few common features, like a state machine.

## State machine, state stack

The game relies on both a state machine and a state stack, for the entities and the overall game respectively.

## Level

A table describes the position of the walls, player and enemies. This structure highlights a concept first introduced in `05 The Legend of Zelda`, whereby the script creates levels based on data.

## Title state cutscene

The `Timer` library allows to animate the title state with a small cutscene. The idea is to move an enemy upwards, towards the title of the game, and then show an introductory message.

The `Message` class in the `gui` folder helps to implement a text box which includes one character at a time.

## OOP

```diff
-Entity.init(self, def)
+Entity.init(this, def)
```

TODO

- [x] player moving

- [x] player shooting

- [ ] enemies, AI (interval to decide whether to walk or stay idle), in play, shooting

- [ ] doors

- [ ] dungeon?
