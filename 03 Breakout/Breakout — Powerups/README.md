This project starts from _Breakout — Assignment_ to contemplate every powerup as included in the last row.

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
