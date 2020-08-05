Improve how collision changes the ball movement.

## Paddle

Beside changing the direction of the ball through `dy`, the idea is to adjust `dx` depending on where the ball hits the paddle.

Start by computing the distance between the center of the paddle and the hit region.

```text
 hit  center
<-x------x-------->
```

From this starting point, the larger the distance from the center, the steeper the change in `dx`.

It's also important to consider the direction of the ball, or rather the position from which the ball arrives at the paddle. With this in mind, hitting the paddle on the right side coming from the left results in a steeper incline, but coming from the right reduces the same value.

In code:

- compute the distance from the center

  ```lua
  deltaCenter = (self.ball.x + self.ball.width / 2) - (self.paddle.x + self.paddle.width / 2)
  ```

- add the value weighed by a factor to increase its influence

  ```lua
  self.ball.dx = self.ball.dx + deltaCenter * 4
  ```

Given the possible values, always adding `deltaCenter` is already enough to consider the direction of the ball.

| dx  | deltaCenter | incline                    |
| --- | ----------- | -------------------------- |
| > 0 | > 0         | steeper (to the right)     |
| > 0 | < 0         | softer (less to the right) |
| < 0 | > 0         | softer (less to the left)  |
| < 0 | < 0         | steeper (to the left)      |

It's important to note that given enough distance from the center, it's also possible to send the ball the opposite direction from which it came. This in the moment `deltaCenter * 4` more than offsets `dx`.

## Bricks

For the bricks, the trajectory needs to be adjusted depending on where the ball actually hits the shape.

The idea is to here check through a series of conditional statements, considering if the ball hits the brick on the left, right, top or bottom side.

1. check whether the ball is moving to the right/left, to the top/bottom

   Based on this first set of conditionals, you are able to narrow down the possible collisions. If moving to the right and to the bottom, indeed the brick can only be hit on the left or top edge.

2. check the horizontal coordinate of the ball vis a vis the horizontal coordinate of the brick

   This is a simplified AABB test, and it allows to decipher whether the ball hits the brick on its left/right side or on its top/bottom edge. Case in point: if he horizontal coordinate falls within the coordinates provided by the brick, the collision must be on the top/bottom edge. If the horizontal coordinate describe a position before/after the brick, the collision must be on the left/right side.

Barring edge cases, the approach is rather solid. Most importantly, it allows to have the ball estimate with good accuracy the behavior of the ball when it goes atop a row of contiguous bricks. This especially considering a slightly thinner bounding box.

```diff
-isBefore = self.ball.x + self.ball.width < brick.x
+isBefore = self.ball.x + self.ball.width < brick.x + 5

-isAfter = self.ball.x > brick.x + brick.width
+isAfter = self.ball.x > brick.x + brick.width - 5
```

This preference for the top/bottom edge allows to avoid a messy situation in the moment the ball nears two bricks at the same time.
