# Breakout 5

_Please note:_ `main.lua` depends on a few assets in the `res` folder. Consider copy-pasting the resources from `Breakout — Final`.

## Paddle collision

Immediately, update the vertical component and the position of the ball to bounce in the opposite direction.

```lua
self.ball.y = self.paddle.y - self.ball.height
self.ball.dy = self.ball.dy * -1
```

To increase the difficulty of the game consider multiplying the speed by an arbitrary amount, and capping the value so that it doesn't cross a given threshold.

```lua
self.ball.dy = math.max(-150, self.ball.dy * -1 * 1.02)
```

The logic works to have the ball bounce, but it is helpful to further modify the movement in the horizontal component and depending on where the ball hits the paddle.

Start by computing the distance between the center of the paddle and the hit region.

```lua
local deltaCenter = (self.ball.x + self.ball.width / 2) - (self.paddle.x + self.paddle.width / 2)
```

The idea is to change the horizontal component offsetting the `dx` by the distance and an arbitrary multiplying factor.

```lua
self.dx = self.ball.dx + deltaCenter * 5
```

This helps to consider the direction of the ball as well, or rather, the position from which the ball arrives at the paddle.

If `self.dx` is positive, the ball comes from the left. If the hit is before the center, the value is detracted the distance from the center, resulting in a slower ball. If the distance is even greater than the horizontal speed, the ball moves in the opposite direction. If the hit is after the center, the ball becomes faster. The same is true if `self.dx` is negative, resulting in steeper/softer inclines.

Once again it is helpful to cap the values to given thresholds.

```lua
self.ball.dx = math.min(150, math.max(-150, self.ball.dx + deltaCenter * 5))
```

## Brick collision

For the bricks, the trajectory needs to be adjusted depending on where the ball actually hits the structure.

The idea is to here go through a series of conditional statements, considering if the ball hits the brick on the left, right, top or bottom side.

- if the ball is before the brick and moving right, consider a collision with the left side

- else, if the ball is after the brick and moving left, consider a collision with the right side

- else, if the ball is above the brick, consider a collision from above

- else, resolve the collision from below

Barring edge cases, the approach is rather solid. This especially considering a slightly smaller bounding box for the left and right check.

```diff
-self.ball.x + self.ball.width < brick.x and self.ball.dx > 0
+self.ball.x + self.ball.width - 3 < brick.x and self.ball.dx > 0

-self.ball.x > brick.x + brick.width and self.ball.dx < 0
+self.ball.x + 3 > brick.x + brick.width and self.ball.dx < 0
```

This preference for the top and bottom edge allows to avoid a messy situation the moment the ball nears a brick at an angle.

As you resolve a collision, it is possible to break out of the loop so that the ball considers one collision per frame.

```lua
if self.ball:collides(brick) and brick.inPlay then
   -- collision

   break
end
```
