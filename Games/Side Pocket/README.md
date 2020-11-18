# Side Pocket

With this project I set out to create a basic game of pool, or billiard, leveraging the physics library Box2D.

## Style

The game has but one screen, to play an infinite game of pool. The bottom half is reserved to the pool's table, while the top helf is instead devoted to the launcher and a panel showing which ball is already pocketed.

### Launcher

The component describes a circle positioned inside a rounded rectangle.

<svg viewBox="-2 -2 100 20" width="200" height="40">
  <rect rx="8" width="96" height="16" fill="none" stroke="hsl(0, 0%, 30%)" stroke-width="2" />
  <circle fill="hsl(0, 0%, 30%)" cx="8" cy="8" r="6" />
</svg>

The idea is to have the circle move following a particular key press, for instance on the space bar, and continuously bounce from end to end.

<svg viewBox="-2 -2 100 20" width="200" height="40">
  <rect rx="8" width="96" height="16" fill="none" stroke="hsl(0, 0%, 30%)" stroke-width="2" />
  <circle opacity="0.2" fill="hsl(0, 0%, 30%)" cx="64" cy="8" r="6" />
  <circle opacity="0.4" fill="hsl(0, 0%, 30%)" cx="66" cy="8" r="6" />
  <circle fill="hsl(0, 0%, 30%)" cx="68" cy="8" r="6" />
</svg>

As the same key is pressed once more, the component finally computes the speed considering the percentage covered in the rectangle.

<svg viewBox="-2 -2 100 20" width="200" height="40">
  <rect rx="8" width="96" height="16" fill="none" stroke="hsl(0, 0%, 30%)" stroke-width="2" />
  <circle fill="hsl(0, 0%, 30%)" cx="68" cy="8" r="6" />
  <text font-size="9" x="75" y="11.5">70%</text>
</svg>

This covers the interaction behind the launcher, but in terms of style, the idea is to also provide a signifier, a helper graphic above the rounded rectangle. This signifier might describe the purpose of the component with two strings, `min` and `max`, as well as a series of rectangles of increasing height.

<svg viewBox="0 0 80 20" width="200" height="50">
  <g fill="hsl(0, 0%, 30%)">
    <g font-size="9" style="text-transform:uppercase;">
      <text  x="5" y="15">Min</text>
      <text  x="75" y="15" text-anchor="end">Max</text>
    </g>
    <g transform="translate(0 15) scale(1 -1)">
      <rect rx="2" x="28" width="4" height="4" />
      <rect rx="2" x="34" width="4" height="6" />
      <rect rx="2" x="40" width="4" height="8" />
      <rect rx="2" x="46" width="4" height="10" />
      <rect rx="2" x="46" width="4" height="10" />
    </g>
  </g>
</svg>

### Pocketed

The component describes, always in a rounded rectangle, the balls already pocketed in the game. It does so maintaining the order in which the balls are eliminated and by highlighting the corresponding number.

<svg viewBox="-2 -2 100 50" width="200" height="100">
  <g stroke="hsl(0, 0%, 30%)" fill="none" >
    <rect rx="8" width="96" height="46" stroke-width="2" />
    <circle cx="11" cy="11" r="6" />
    <circle cx="27" cy="11" r="6" />
    <circle cx="43" cy="11" r="6" />
  </g>
  <g fill="hsl(0, 0%, 30%)" font-weight="bold">
    <text font-size="10" x="10.75" y="14.75" text-anchor="middle">6</text>
    <text font-size="10" x="26.75" y="14.75" text-anchor="middle">2</text>
    <text font-size="10" x="42.75" y="14.75" text-anchor="middle">3</text>
  </g>
</svg>

### World

Box2D itself creates the surface with a rectangle, and six circles making up the pockets.

<svg viewBox="-5 -5 110 60" width="220" height="120">
  <g stroke="hsl(0, 0%, 30%)" fill="none" >
    <rect width="100" height="50" stroke-width="2" />
  </g>
  <g fill="hsl(0, 0%, 10%)" font-weight="bold">
    <circle cx="0" cy="0" r="5" />
    <circle cx="50" cy="0" r="5" />
    <circle cx="100" cy="0" r="5" />
    <circle cx="0" cy="50" r="5" />
    <circle cx="50" cy="50" r="5" />
    <circle cx="100" cy="50" r="5" />
  </g>
</svg>

The edges are however not rendered. Instead, the idea is to use `love.graphics` to improve the aesthetics with rounded corners.

<svg viewBox="-5 -5 110 60" width="220" height="120">
  <g stroke="hsl(0, 0%, 30%)" fill="none" >
    <rect width="100" height="50" stroke-width="2" />
    <rect x="-2.5" y="-2.5" width="105" height="55" stroke-width="5" rx="5" />
  </g>
  <g fill="hsl(0, 0%, 10%)" font-weight="bold">
    <circle cx="0" cy="0" r="5" />
    <circle cx="50" cy="0" r="5" />
    <circle cx="100" cy="0" r="5" />
    <circle cx="0" cy="50" r="5" />
    <circle cx="50" cy="50" r="5" />
    <circle cx="100" cy="50" r="5" />
  </g>
</svg>

In this context, and again with `love.physics`, the game finally populates the level with a predetermined number of balls.

<svg viewBox="-5 -5 110 60" width="220" height="120">
  <g stroke="hsl(0, 0%, 30%)" fill="none" >
    <rect width="100" height="50" stroke-width="2" />
    <rect x="-2.5" y="-2.5" width="105" height="55" stroke-width="5" rx="5" />
  </g>
  <g fill="hsl(0, 0%, 10%)" font-weight="bold">
    <circle cx="0" cy="0" r="5" />
    <circle cx="50" cy="0" r="5" />
    <circle cx="100" cy="0" r="5" />
    <circle cx="0" cy="50" r="5" />
    <circle cx="50" cy="50" r="5" />
    <circle cx="100" cy="50" r="5" />
  </g>
  <g>
    <circle fill="hsl(0, 0%, 50%)" r="2.5" cx="75" cy="27.5"/>
    <g fill="hsl(0, 0%, 20%)">
      <circle r="2.5" cx="30" cy="27.5"/>
      <circle r="2.5" cx="25" cy="25"/>
      <circle r="2.5" cx="25" cy="30"/>
      <circle r="2.5" cx="20" cy="22.5"/>
      <circle r="2.5" cx="20" cy="27.5"/>
      <circle r="2.5" cx="20" cy="32.5"/>
    </g>
  </g>
</svg>

One of the game's feature is that the balls can be toggled between ball and number. With this different view, the design changes to show the respective number aligned in the outline of a circle.

<svg viewBox="-5 -5 110 60" width="220" height="120">
  <g stroke="hsl(0, 0%, 30%)" fill="none" >
    <rect width="100" height="50" stroke-width="2" />
    <rect x="-2.5" y="-2.5" width="105" height="55" stroke-width="5" rx="5" />
  </g>
  <g fill="hsl(0, 0%, 10%)" font-weight="bold">
    <circle cx="0" cy="0" r="5" />
    <circle cx="50" cy="0" r="5" />
    <circle cx="100" cy="0" r="5" />
    <circle cx="0" cy="50" r="5" />
    <circle cx="50" cy="50" r="5" />
    <circle cx="100" cy="50" r="5" />
  </g>
  <g>
    <circle fill="hsl(0, 0%, 50%)" r="2.5" cx="75" cy="27.5"/>
    <g fill="none" stroke="hsl(0, 0%, 20%)" stroke-width="0.5">
      <circle r="2.5" cx="30" cy="27.5"/>
      <circle r="2.5" cx="25" cy="25"/>
      <circle r="2.5" cx="25" cy="30"/>
      <circle r="2.5" cx="20" cy="22.5"/>
      <circle r="2.5" cx="20" cy="27.5"/>
      <circle r="2.5" cx="20" cy="32.5"/>
    </g>
  </g>
  <g font-size="4" font-weight="bold" text-anchor="middle">
    <text x="30" y="29">1</text>
    <text x="25" y="26.5">2</text>
    <text x="25" y="31.25">3</text>
  </g>
</svg>

## Components

To implement the design described in the previous section — see [Style](#style) — the game creates a series of `lua` files responsible for the building blocks:

- `Panel` to render a rounded rectangle

- `Slider` to include a circle inside of a panel, and have the signifier move right and left to provide a percentage value

- `Launcher` to wrap together the logic of the slider with the design of the top left screen. Here the slider is accompanied by the mentioned `min`, `max` strings

- `Pocketed` to use a panel in which to show the pocketed balls

## State

`main.lua` manages the state with a series of booleans:

- `isMoving` to update the simulation

  It is here that the game manages the game, removes the pocketed tables, resets the player if necessary. It is also here where the script checks the speed of the balls, in order to toggle the same boolean to `false`.

- `isLaunching` to update the launcher

  The idea is to use the boolean so that, by pressing the `space` key, the game updates the launcher. By pressing the same key again, the game consider the launcher's value and actually launches the player's ball.

- `isGameover` to show a congratulatory message

  The booelean is also used to reset the game following a press on the enter key.

## Gameplay

It is worth to describe the logic of the codebase in a few points.

### Destroy

When objects collide, `world:setCallbacks` allows to execute the logic described in the `beginContact` function.

```lua
world:setCallbacks(beginContact)
```

However, this is not where the bodies are actually destroyed; as detailed in the [tutorial on callback functions](https://love2d.org/wiki/Tutorial:PhysicsCollisionCallbacks), love2d locks the world in place, so that changes need to happen outside of the function's scope. In the scope, the bodies to-be-destroyed are flagged with two different methods:

- balls are included in the table `pocketedBalls`

- the player's ball is signalled with the boolean `isPlayerPocketed`

In `love.update`, the code then proceed to destroying the objects and repopulating the world if necessary.

```lua
if #pocketedBalls > 0 then
  for i, body in ipairs(pocketedBalls) do
    body:destroy()
  end

  pocketedBalls = 0
end

if isPlayerPocketed then
  player.body:destroy()
  player = initializePlayer()
  isPlayerPocketed = false
end
```

### Physics

The game uses plenty of functions from the `love.physics` module. Here, however, I want to highlight `body:applyLinearImpulse` and `body:setLinearDamping`.

- `applyLinearImpulse` is used to have the ball move toward the direction specified by the angle

  ```lua
  player.body:applyLinearImpulse(impulseX, impulseY)
  ```

- `setLinearDamping` is helpful to have the balls slow down

  Without this instruction, the movement of the ball becomes execessively tedious, slow.

  ```lua
  player.body:setLinearDamping(LINEAR_DAMPING)
  ```

One last mention is for `fixture:setSensor()`. This function is used on the bodies making up the pockets so that `beginContact` registers an eventual collision, but the world doesn't consider the body as solid.

```lua
fixture:setUserData("Pocket")
fixture:setSensor(true)
```

### Angle

In order to alter the player's trajectory, the game introduces a variable to describe the angle. This one is initialized to `math.pi`, in order to have the ball aim to the left.

```lua
angle = math.pi
```

The variable updated as the arrow keys are being pressed in `love.update`.

```lua
function love.update(dt)
  if love.keyboard.isDown('up') then
  elseif love.keyboard.isDown('right') then
  elseif love.keyboard.isDown('down') then
  elseif love.keyboard.isDown('left') then
  end
end
```

The logic is rather convoluted, but considers a value in the `[0, math.pi * 2]` range, with the idea of updating the trajectory toward the direction expressed by the key.

Regardless of how the value is updated, the variable is finally used as the game launches the ball, to compute the `x` and `y` dimensions of a linear impulse.

```lua
local impulseX = math.cos(angle) * IMPULSE_MULTIPLIER
local impulseY = math.sin(angle) * IMPULSE_MULTIPLIER
```

_Update_: `angle` is also used in `love.draw`, and to render the trajectory with a series of semitransparent circles.

## Concluding remarks

A few notes for posterity's sake.

### Comments

In `love.draw` there are a few instructions commented out. These are helpful to render the edges introduced by `love.physics`; edges which are however rendered with the panel component.

### constants

Beside variables describing the game's physics and sizes, two values are worth a detailed mention

- in terms of aesthetics, `SEGMENTS` is used to refine the edges of the circles used with `love.graphics`

  ```lua
  SEGMENTS = 20
  ```

  `love.graphics.circle` accepts an additional argument to specify the number of segments with which to render the circle. The higher the value, the smoother the circle's appearance.

- in terms of aesthetics, but also gameplay, POCKET_PADDING describes the part of the pocket with which the balls actually collide

  The idea is to here reduce the radius of the shape making up the pocket.

  ```lua
  love.physics.newCircleShape(POCKET_RADIUS - POCKET_PADDING)
  ```

  In `love.draw` then, the idea is to increase the radius by the same amount.

  ```lua
  love.graphics.circle("fill", pocket.body:getX(), pocket.body:getY(), pocket.shape:getRadius() + POCKET_PADDING)
  ```

  The goal is to ultimately pocket a ball only when the ball is well inside the pocket. To see the actual pocket, as in world-units, remove the constant in `love.draw`.

  ```lua
  love.graphics.circle("fill", pocket.body:getX(), pocket.body:getY(), pocket.shape:getRadius())
  ```
