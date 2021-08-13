# Super Mario Bros — Final

Wrap up the project developed in increments up.

## Bounce

The idea is to have the player jump when falling above a creature.

```lua
if entity:collides(self.player) then
  self.player.score = self.player.score + 100
  table.remove(self.player.level.entities, k)
  self.player:changeState("jump")
end
```

## Audio

The game includes audio in the form of music and sound bytes. Music is set in `love.load()`, and is set to loop indefinitely with a subdued volume.

```lua
gSounds["music"]:setLooping(true)
gSounds["music"]:setVolume(0.5)
gSounds["music"]:play()
```

Sound bytes are included for the actions described in the following table.

| Sound          | Action                                           |
| -------------- | ------------------------------------------------ |
| chasm          | Player falls in a chasm                          |
| death          | Collision with creature                          |
| empty-block    | Collision with a block which doesn't spawn a gem |
| jump           | Player jumps                                     |
| kill           | Player falls on a creature                       |
| music          | Play on loop                                     |
| pickup         | Player picks up gem                              |
| powerup-reveal | Collision with a block which spawns a gem        |

## Chasm

This is something I failed to consider up to now, but a gameover is also caused by having the player fall in a chasm. This is included in the falling state, by checking the vertical coordinate of the player against the game window.

```lua
if self.player.y + self.player.height >= VIRTUAL_HEIGHT then
  gSounds["chasm"]:play()
  gStateMachine:change("start")
end
```

## Stucked

It is possible for a creature to continuously flip its direction left and right. Consider for instance a situation in which the entity is between two pillars, or again between a pillar and a chasm. The end result is that the texture is flips frame after frame creating a rather annoying effect. To fix this, the moving state checks that, when the creature finds an obstacle and tries to change its direction, it is actually possible to move to the opposite side.

```lua
if not tileBottomLeft or (tileBottomLeft and tileBottomLeft.id == TILE_SKY) then
  self.creature:changeState("stucked")
end

-- similarly for the bottom right tile, when moving left
```

Checking the bottom left tile when moving right, or the bottom right one when moving left, the creature moves to the `stucked` state. Here the logic mirrors that of the idle state, in that the creature does not move, but also that of the moving state, in that the creature chases the player within the prescribed range.
