## Lessons learned

Functions like `setColor`, `translate` and `rotate` affect every graphic which follows. Consider the semicircles showing the serving side. Setting the color with a lower alpha channel affects every shape, and it is necessary to set a new value, or reset the previous one after the shapes are drawn.

```lua
love.graphics.setColor(1, 1, 1, 0.05)
-- arc1
love.graphics.setColor(1, 1, 1, 0.2)
-- arc2

-- other shapes
love.graphics.setColor(1, 1, 1, 1)
```
