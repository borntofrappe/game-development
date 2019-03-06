# Animation

While I have already made a first attempt in animating the character, by rapidly changing the stance through dedicated variables, the lecturer includes animation through a custom class, `Animation`. I therefore decided to remove my variables in favor of this solution. This doesn't mean the code was include for nothing though. The logic of how the character is updated, like a flip book, and the way the character is made to look the opposite way, by setting the `xScale` to negative values, are concepts which repeat themselves.

## Update 0

I tried to comment the **Animation.lua** as much as possible, to understand the inner logic of the class, but here I'll also add a few notes jotted down while reviewing the video.

### Animation.lua

Here's the idea behind the class:

- pass in a table with the possible values through which the class needs to loop;

- pass in the interval describing how rapidly the values are modified.

In light of this it seems that `def` is an argument referring to every variable passed through the class, like `params` for the `:enter` counterpart.

Back to the class:

- using the table and set interval loop through the table and through a custom function, `getCurrentFrame`, return the frame referred to by the interval.

The idea seems to have the class update the frames and use the function in `main.lua` to actually change the appearance of the character. Rather comprehensible once the `def` argument is understood.

### moving.lua

Once the `Animation` class is set up, its logic is incorporated in `main.lua` as follows (I use `moving.lua` as a temporary file to describe the update, but the logic is included in a `main.lua` file to have it run in the Love2D engine).

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
