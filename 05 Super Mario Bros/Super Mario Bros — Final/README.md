- bug: walking state doesn't consume gems

Finalize the progress achieved with "Super Mario Bros 9" with minor changes.

## Bounce

The idea is to have the player jump when falling above a creature.

```lua
if entity:collides(self.player) then
  self.player.score = self.player.score + 100
  table.remove(self.player.level.entities, k)
  self.player:changeState("jump", true)
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
