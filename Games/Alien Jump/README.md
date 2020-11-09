# Alien Jump

The goal is to develop a game similar to the endless scroller available in a Chrome browser without an internet connection. A game in which all that is required is for the player to jump and avoid incoming obstacles. In the final version, I've included coins and a different scoring system, but the demo doesn't differ wildly from the cited Chrome-based game experience.

## State

Picking up from the projects developed in the CS50 course, the game is the perfect excuse to practice with a state machine for the player — see `04 Super Mario Bros` — and a state stack for the game — see `08 Pokemon`.

### State machine

The player is initialized with four possible states: idle, jump, squat and walk.

```lua
Player(
{
  ["stateMachine"] = StateMachine(
    {
      ["idle"] = -- return macthing state,
      ["jump"] = -- return macthing state,
      ["squat"] = -- return macthing state,
      ["walk"] = -- return macthing state
    }
  )
}
```

The states describe the appearance of the blue/pink alien, by setting upè an animation for dedicated spriites,

```lua
function PlayerWalkState:init(player)
  self.player = player
  self.animation = ALIEN_ANIMATION["walk"]
  self.player.currentAnimation = self.animation
end

function PlayerWalkState:update(dt)
  self.player.currentAnimation:update(dt)
end
```

The logic for the player is however and mostly implemented in `ScrollState`. It is here in `ScrollState` where the player is updated to jump or squat by pressing dedicated keys.

```lua
if (love.keyboard.wasPressed("up") or love.keyboard.wasPressed("w")) then
  self.player:changeState("jump")
  gSounds["jump"]:play()
end
```

One exception to this implementation relates to the jump state. Here, the player is updated to move up and then back down as if subject to gravity (with a decreasing and then negative speed).

```lua
function PlayerJumpState:update(dt)
  self.player.dy = self.player.dy + self.gravity
  self.player.y = self.player.y + (self.player.dy * dt)

  if self.player.y > VIRTUAL_HEIGHT - self.player.height then
    self.player.y = VIRTUAL_HEIGHT - self.player.height
    self.player:changeState("walk")
  end
end
```

This logic is contained in `PlayerJumpState` and allows to move back to the idle state as the player reaches its original `y` coordinate.

### State stack

The game can very well benefit from a state machine, but a state stack seems like the most fitting solution for a situation in which the game is literally paused in a fixed time. The idea is to have the stack update the game through `ScrollState` and then push above this state a pause or gameover instance.

```text
                PauseState
ScrollState -> ScrollState
```

The stack works by rendering the assets of every state, but considers the `update` function of the topmost state only.

```lua
function StateStack:update(dt)
  self.states[#self.states]:update(dt)
end
```

As you push the pause state for instance, the script no longer runs `ScrollState:update(dt)`. The position of the game objects, the vertical position of the player is no longer modified.

## Score

The game uses a global variable to keep track of the score. What's more, the variable is initialized in a field of a table, to also consider the high score.

```lua
gScore = {
  ["hi"] = 0,
  ["current"] = 0
}
```

The score is updated in the scroll state, and registered as the game come to an end, but here I want to focus on how the scores are rendered. Instead of using a font, I decided to benefit from the visual described in `numbers.png`. The `8x8` numbers are structured into the `gQuads` table, and the `displayScore`, `displayRecord` function render one quad for each digit.

To render the digits individually, I created the `numToDigits` function. This one receives an integer, the score or record, and returns a table, a sequence describing the individual digits. Here is how I approached the problem:

- initialize a local table, in which to store the digits

  ```lua
  local digits = {}
  ```

- convert the number to a string

  ```lua
  local string = tostring(num)
  ```

- loop through the string based on its length

  ```lua
  for i = 1, #string do
  end
  ```

- consider the individual characters

  ```lua
  local char = string:sub(i, i)
  ```

- conver the characters back to integers, before adding the result to the `digits` table

  ```lua
  local digit = tonumber(char)
  digits[i] = digit
  ```

## gGlobal

Two additional global variables are set up in `love.load` to pick and choose a specific background and alien. Here, the idea is update both variables as one game comes to and end, and as the player moves back to the scroll state.

- pick a background at random

  ```lua
  gBackgroundVariant = math.random(#gQuads["backgrounds"])
  ```

- pick the alien's color alternating between thw available two

  ```lua
  gAlienVariant = gAlienVariant == "blue" and "pink" or "blue"
  ```

## Bushes

To add more variety, I've decided to build bushes out of multiple sprites rather than using one individual tile from `bushes.png`. In `constants.lua` you find a table describing different configurations.

```lua
BUSH_VARIANTS = {
  {3, 4},
  {1, 3, 4},
  {2, 3, 4},
  {1, 5, 3, 4},
}
```

These refer to specific quads in the `gQuads["bushes"]` table. Notice in particular `5`, which refers to an empty cell. This is used as a space between the colored variants.

## Creatures

Creatures come in two varieties: land and sky. The class describes both variants, since the two kinds behave equally. The only difference comes in the `y` coordinate, whereby the sky creatures are elevated from ground level.

```lua
self.y = VIRTUAL_HEIGHT - self.height
if self.type == 'sky' then
  self.y = self.y - math.random(self.height, math.floor(VIRTUAL_HEIGHT / 2))
end
```

## Shortcomings

The game is primed for several refinements.

Immediately, it is possible to see how the scripts setting up the bushes, coins and creatures share a lot of elements. They are introduced to the right of the gaming window, they move toward the left, they are removed as they exceed the left edge. Bushes are aesthetic in nature, a collision with coins is different from that happening with a creature, but it is not difficult to imagine how the project could benefit from a more general class, think of `GameObject`.

Bushes, coins and creatures are also included, updated and removed through dedicated tables. A `Level` or `LevelMaker` class could abstract this logic to have the game updated as follows.

```lua
function ScrollState:update(dt)
  self.level:update(dt)
end
```

And then delegate the update logic in the `Level` class itself.

```lua
function Level:init()
  self.bushes = {}
end

function Level:update(dt)
  for i, bush in ipairs(self.bushes) do
    bush.x = bush.x - (SCROLL_SPEED * dt)
  end
end
```

Finally, there is no music playing in the background, but thee sound bytes for when the player jumps, picks up a coin is hit.
