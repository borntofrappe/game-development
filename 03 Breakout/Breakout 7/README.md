# Breakout 7 - Tier Update

The update sets out to account for the tiers and colors of the bricks, with the following logic:

- whenever a brick is hit, reduces its color;

- if the color is in the lowest possible value (1, meaning blue), reduce the brick's tier

- if the tier too is in its lowest possible value (1, meaning solid), make the brick disappear (as you have always done up to now).

In addition to this, the score is weighed to award higher points to bricks with higher tiers and colors.

Previously I considered the correct approach would be to reduce the tier and then the color starting from the highest tier, but I can see how this approach would be rather detrimental to the enjoyment of the game.

## Brick.lua

The change in the code happes in the `hit` function. Here we evaluate the tier, color, and change the appearance of the brick accordingly. Only when the brick reaches tier 1 color 1 we set the `inPlay` flag to true.

## PlayState.lua

Instead of arbitrarily increase the score by 10 points, we weigh the tier and color of the brick in the computation and update of `score`. We do this **before** the brick is hit, as to use the current tier and color, and we give the following weights:

- 200 points for each tier following the first;

- 50 points for each color, already starting with the first.

## Quirky Collision

The way I previously checked for the side of the collision between ball and bricks does not work when the ball finds itself in between multiple bricks. Indeed, the way I set up the conditional statements only checks for the horizontal coordinate, and relegates the vertical dimension to the `else` statament.

By checking also that the ball is right before or after the brick vertically, it is possible to more accurately respond to the possible collusion of the ball, and also when the ball finds itself atop one brick and below another one.

## Sound Update

This was a rather subtle change, but the sound played when a brick gets hit changes when the brick ultimately disappear. We not play a new sound to remark the 'death' of the brick, through `brick-hit-1`.

In addition, and as to avoid a minor annoyance when multiple bricks are hit soon after one another, the code introduces also a `stop()` function, right before playing the audio.

```lua
gSounds['brick-hit-2']:stop()
gSounds['brick-hit-2']:play()
```

As sounds do not overlap, this guarantees that the sound plays for most recent brick.
