# Breakout 4 - Collision Update

How we react when detecting a collision can be modified to make the game more realistic.

## Paddle collision

For the paddle, we don't want to simply negate the `dy` value. We want to also adjust also `dx` according to where the ball actually hits the paddle. The idea is to compute the distance between the center of the paddle and the hit region and scale the value based on that factor.

```text
 hit  center
<-x------x-------->
```

With this simple frame of reference, the larger the distance from the center, the steeper the change in `dx`.

The solution provided by the lecturer accounts for a collision with the paddle on the left and right section, but only when hitting such an area in one direction (to the left and to the side respectively). I wanted to also account for the opposite occurrence, when a paddle goes to the left and hits the paddle on the right, so here's my approach:

- consider the distance from the center;

- consider the direction;

If the two match in sign (both positive or both negative), it means the paddle is moving toward the hit area (left left, righ right). In this instance increase how steep the horizontal movement is (higher absolute values of `dx`). If the two don't match, well accordingly the hit area is opposite to the direction of the ball. In this instance, decrease how steep the horizontal movement is, softening the trajectory of the projectile.

It may not be the best approach, and it is questionable how much to influence the change in direction, but with a bit of trial and error, it might be a reasonable enough set of assumptions.

Thinking through the possible scenarios when considering the two assumptions, it turns out the approach is both effective and rather simple to implement.

1. compute the distance from the center:

```lua
deltaCenter = (self.ball.x + self.ball.width / 2) - (self.paddle.x + self.paddle.width / 2)
```

1. add the value weighed by a factor to increase its influence:

```lua
self.ball.dx = self.ball.dx + deltaCenter * 4
```

Given the interplay between the two values, and specifically the interplay between the values's signs, always adding `deltaCenter` works as to increase `dx` in absolute terms, when the two match in direction, and decrease it in absolute terms, when the two don't match.

It also means that given enough distance from the center, it is possible to send the ball the opposite direction from which it came.

## Brick collision

For the bricks, the game currently removes the them, but the movement of the ball is unaffected. The trajectory of the projectile needs to be adjusted and this value depends on where the ball actually hits the bricks.

The idea is to here check through a series of conditional statements if the ball hits the brick on the left, right, top or bottom side.

Here's the approach with which I went in the end. It mirrors the logic saw in the video, but I crafted each conditional to make evident the underlying reasoning:

1. check whether the ball is moving to the right/left, to the top/bottom.

Based on this first set of conditionals, you are able to narrow down the possible collisions. If moving to the right and to the bottom, indeed the brick can only be hit on the left or top edge.

1. once you are able to narrow down your options, check the horizontal coordinate of the ball vis a vis the horizontal coordinate of the brick. The idea is that if the ball hits the brick on the left or right side, the ball is right outside of the horizontal dimension making up the brick. If it falls within the brick (horizontally), it is then presumed that the collision is on the top or bottom edge.

Barring edge cases, the approach is rather solid. Most importantly, it allows me to have the ball estimate with good accuracy the behavior of the ball when it goes atop a row of contiguous bricks.
