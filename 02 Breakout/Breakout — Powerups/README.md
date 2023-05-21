# Breakout — Powerups

The project starts from `Breakout — Assignment` to contemplate every powerup found in the last row of the `breakout.png` graphic.

## Powerups

The powerups are included with a certain probability in the `LevelMaker` class.

```lua
spawnPowerup = math.random(POWERUP_ODDS) == 1
```

In terms of gameplay, they introduce more variety by modifying the game as in the following table.

| Number | Effect             | Change             |
| ------ | ------------------ | ------------------ |
| 1      | Shrink paddle      | Paddle width       |
| 2      | Grow paddle        | Paddle width       |
| 3      | Add a heart        | Health, max health |
| 4      | Remove a heart     | Health             |
| 5      | Make balls faster  | Ball dx and dy     |
| 6      | Make balls slower  | Ball dx and dy     |
| 7      | Make balls lighter | Ball dy (negative) |
| 8      | Make balls heavier | Ball dy (positive) |
| 9      | Add ball           | Balls table        |

The tenth powerup is reserved for the `LockedBrick` class, but otherwise, the `Powerup` class initializes a random powerup between the mentioned nine.

```lua
function Powerup:init(x, y, powerup)
    -- ...
    self.powerup = powerup or math.random(POWERUPS)
end
```

It is worth mentioning that the change in the size of the paddle, the change in the number of hearts are now tied to a powerup and not to the score or losing a life, as in the assignment.
