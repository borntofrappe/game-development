# Berzerk

[Berzerk](<https://en.wikipedia.org/wiki/Berzerk_(video_game)>) is an arcade game where the player roams a series of levels, shooting robot enemies while avoiding incoming fire and the surrounding walls. Here I try to replicate the essence of the game taking inspiration from the port for the Atari 2600 system.

![Berzerk in a few frames](https://github.com/borntofrappe/game-development/blob/main/Practice/Berzerk/berzerk.gif)

## Spritesheet

The `res/graphics` sub-folder includes a spritesheet I designed with GIMP for the title. There are multiple visuals for the player, enemies and enemies' particles (shown when an enemy is destroyed), but each frame is 8 pixels wide and tall.

- for the player there are 5 frames, describing its idle, walking, shooting and losing state. The walking state is represented by two frames, with the idea of rapidly shuffling between the two

- for the enemies there are multiple frames for multiple states; in the idle state you find 8 sprites, while in the walking state, itself subdivided in four types according to the chosen direction, you find 3 sprites

- for the particles there are 2 frames. Ideally, the idea is to shown the two in succession only when the enemies are destroyed by a bullet, and only the first when the entities collide with a wall

## Levels

Picking up from the course, see project `05 The Legend of Zelda.`, the idea is to create levels on the basis of data. `constants.lua` introduces such a concept with a long strings, describing the position of the walls, enemies and ultimately player.

```lua
local LEVEL = [[
xxxxxx
ooeooo
oxoexo
oxxxxo
oxpoxo
ooooeo
xxxxxx
]]
```

For the walls the idea is to create a rectangle for any contiguous `x` character. For the player and enemies the idea is to spawn an entity at the position specified by the `p` and `e` characters instead.

The idea is to

## Entity, player, enemy

Picking up from the course, see project `04 Super Mario Bros.`, the idea is to have an `Entity` class manage the state of both the player and enemies, as well as any variable or method shared by the two types.

Attributes belonging to one or the other entity are initialized in `this`, the table distinct for the inheriting class, while common values are passed to `defs`, and included through the entity and its `init` function. Notice here the use of the `Entity` class capital `E` to update the player and enemies.

```lua
function Player:update(dt)
  Entity.update(self, dt)
end
```

In this manner the logic of the `update` function of the `Entity` class is applied to the invoking entity, in this instance teh player.

```lua
function Entity.update(self, dt)
    self.stateMachine:update(dt)
end
```

The colon character allows to hide the receiving `self` argument.

```lua
function Entity:update(dt)
    self.stateMachine:update(dt)
end
```

## States, machine and stack

The game leans on both a state stack and a state machine, for the game and the entities respectively.

For the game, the stack helps to layer multiple states one above the other. This is what ultimately allows the transition state to overlay a solid background when transitioning between states. Note that to respect the design of the Atari port, the transition state works only one way, introducing the overlay before abruptly removing it and show the new state underneath.

For the entities, the machine helps to manage one state at a time.

## Animation

The title state introduces the game with a small animation. The idea is to lean on the `Timer` library to move an enemy from the bottom of the window the middle portion, right below the title. Following this brief transition, the idea is to then spawn a message, as if the enemy was talking. The `Message` class helps to render the message one character at a time.
