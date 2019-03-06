# Animation

While I have already made a first attempt in animating the character, by rapidly changing the stance through dedicated variables, the lecturer includes animation through a custom class, `Animation`. I therefore decided to remove my variables in favor of this solution. This doesn't mean the code was include for nothing though. The logic of how the character is updated, like a flip book, and the way the character is made to look the opposite way, by setting the `xScale` to negative values, are concepts which repeat themselves.

## Animation.lua

I tried to comment the **Animation.lua** as much as possible, to understand the inner logic of the class, but here I'll also add a few notes jotted down while reviewing the video.

Here's the idea behind the class:

- pass in a table with the possible values through which the class needs to loop;

- pass in the interval describing how rapidly the values are modified.

In light of this it seems that `def` is an argument referring to every variable passed through the class, like `params` for the `:enter` counterpart.

Back to the class:

- using the table and set interval loop through the table and through a custom function, `getCurrentFrame`, return the frame referred to by the interval.

The idea seems to have the class update the frames and use the function in `main.lua` to actually change the appearance of the character. Rather comprehensible once the `def` argument is understood.

## Update 0 - moving.lua

Once the `Animation` class is set up, its logic is incorporated in the application to allow for horizontal movement.

- include the animation class in the list of dependencies of the game. Or simply include it atop the `lua` file;

- create variables referring to the possible animation. The idea is to have a variable describe the current animation and update this variable following player input. Following the input of the player and selecting from a series of possible values.

  In the current update, the possible animations are `idleAnimation` and `movingAnimation`, to have the character respectively stand still and move horizontally.

  ```lua
  idleAnimation = Animation {
    frames = {1},
    interval = 1
  }
  movingAnimation = Animation {
    frames = {10, 11},
    interval = 0.1
  }
  ```

- initialize a variable referring, as mentioned, to the current animation, but also a variable referring to the current direction.

  ```lua
  currentAnimation = idleAnimation
  currentDirection = 'right'
  ```

  This last one to have the character look and move to the left by scaling the quad to a negative `xScale` value (more on this soon).

The code has thus included the animation class, but it is necessary to have it reflect its logic visually and update its logic following player input.

To visually detail the change introduced by the class, and specifically in the `love.graphics.draw` function detailing the character:

- include the current frame obtained through the `getCurrentFrame()` function in the argument detailing the quad.

  ```lua
  gFrames['character'][currentAnimation:getCurrentFrame()]
  ```

- include the `currentDirection` variable in the argument detailing the horizontal scale of the quad, to have it visually point to the left.

  ```lua
  currentDirection == 'right' and 1 or -1, -- x scale
  gFrames['character'][currentAnimation:getCurrentFrame()]
  ```

- update the argument making up the `x` coordinate of the character in light of the changed `xScale` value. Indeed scaling back the value to `-1` causes the character to instantly teleport itself to the left by the amount of pixels making up its width. This is because the change in the scale is applied with the left edge of the character as a hinge, and the rotation effectively moves the character back a few pixels. To offset this force, add the width of the character, conditional to the direction being the one changing the `xScale` to a negative value.

  ```lua
  currentDirection == 'right' and math.floor(gCharacter.x) or math.floor(gCharacter.x + CHARACTER_WIDTH),
  ```

To change the animation and most importantly to have it update the appearance of the character, it is then necessary to update th logic in `love.update()`:

- by default set the current animation to be the idle animation.

  ```lua
  currentAnimation = idleAnimation
  ```

  This to have the character always revert back to the idle state, and change the animation only following player input.

- change the animation to refer to the `movingAnimation` when the arrow keys are pressed.

  ```lua
  currentAnimation = movingAnimation
  ```

  Change also the direction to have the character scaled to the right/left.

  ```lua
  currentDirection = 'right'
  ```

- do not forget to add the update logic through the `update(dt)` function.

  ```lua
  currentAnimation:update(dt)
  ```

## Update 1 - main.lua

With the second round of animation-related update, the goal is to animate a jump. This relates not only to the animation class, but also a change in the vertical position of the character.

In terms of vertical coordinate, the solution in inspired by the approach incorporated in Flappy Bird, changing the `y` coordinate as to emulate gravity.

In terms of animation, and instead of creating one instance of the animation class, the movement is differentiated in two instances: jumping and falling. This is because the character behaves inherently different when it is jumping (destroying for instance blocks) vis a vis when it is falling (eliminating enemies). It becomes important to separate the two states.

The change in vertical coordinate is implemented as follows:

- create a `dy` variable in which to describe the vertical offset, from the `y` coordinate;

  ```lua
  gCharacter = {
    -- horizontally centered
    ['x'] = (VIRTUAL_WIDTH / 4) - (CHARACTER_WIDTH / 2),
    -- vertically right atop the ground tiles
    ['y'] = (MAP_SKY - 1) * TILE_SIZE - CHARACTER_HEIGHT,
    ['dy'] = 0
  }
  ```


- in the update function change the `y` coordinate according to `dy`;

  ```lua
  gCharacter.y = gCharacter.y + gCharacter.dy * dt
  ```

- itself, `dy` is updated as time passes and as the player hits the up arrow key.

  As time passes, the offset is weighed by a constant referring to the gravity.

  ```lua
  gCharacter.dy = gCharacter.dy + GRAVITY
  ```

  As the up arrow key it pressed, the offset considers the variable stored in a constant referring to the character's own speed.

  ```lua
  gCharacter.dy = CHARACTER_JUMP_SPEED
  ```

  In light of this, `CHARACTER_JUMP_SPEED` refers to a negative value (pushing the character upwards). `GRAVITY` refers instead to a positive value (bringing the character back).

- to avoid having the character fall below the tiles making up the ground, be sure to include a safety hatch, a condition to have `dy` reverrt back to 0 as the ground is hit.

  ```lua
  if gCharacter.y >= (MAP_SKY - 1) * TILE_SIZE - CHARACTER_HEIGHT then
    gCharacter.y = (MAP_SKY - 1) * TILE_SIZE - CHARACTER_HEIGHT
    gCharacter.dy = 0
  end
  ```

  Just remember that the coordinate system goes top to bottom with increasing values.

## Final Notes

I decided to apply the following changes:

- the background is darkened with a semi-transparent black overlay. The color was striking a bad balance with the character's own color;

- the character is animated as to squat, whenever the down key is being pressed. This allows to detail another animation;

- the animation of the character, moving to the left and right is applied conditional to `dy` being equal to 0. Otherwise the jumping and falling animation is overriden by the horizontal one.