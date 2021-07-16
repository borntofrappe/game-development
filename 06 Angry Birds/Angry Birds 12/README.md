# Angry Birds 12

## Trajectory

The course introduces a rather complex mathematical formula based on [a tutorial](https://www.iforce2d.net/b2dtut/projected-trajectory) explaining projected trajectories with Box2D through the C++ language.

```lua
for i = 0, 90, 10 do
  local point = {
    ["x"] = x + i / 60 * impulseX,
    ["y"] = y + i / 60 * impulseY + 0.5 * (i * i + i) * GRAVITY.y / 3600
  }
end
```

Instead of the launch area described in the previous update, the idea is to include a series of circles describing where the player will move in the moment the mouse cursor is released. This explains the additional table `self.trajectory`, which allows to store the points and render them in `PlayState:render` as semi-transparent circles.

```lua
love.graphics.setColor(0, 0, 0, 0.4)
for k, point in pairs(self.trajectory) do
  love.graphics.circle("fill", point.x, point.y, 4)
end
```

### Issues

The computed trajectory tends to overshoot the actual path, and I believe the problem stems with the damping introduced on the body of the player.

```lua
player.body:setLinearDamping(0.25)
player.body:setAngularDamping(0.8)
```

Introduced to slow down the player and avoid running the simulation too long before a new launch, the code has the side effect of modifying the eventual trajectory.

I decided to remove the two lines from the initial definition of the player, and introduce the damping only when the player collides with one of the edges.

```lua
if (userData["Player"] and userData["Edge"]) then
  player.body:setLinearDamping(0.25)
  player.body:setAngularDamping(0.8)
end
```

## Minor Touches

I've decided to reduce the restitution on the fixture describing the player. This doesn't affect the trajectory, but overall feel of the game, and especially how long the player will be updated before eventually stopping.
