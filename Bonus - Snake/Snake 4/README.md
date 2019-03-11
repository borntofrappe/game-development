# Snake 4 - Collision

With the included `Item` class, the game should detect a collision between snake and item(s), as to award points and at a later stage elongate the snake itself. Collision is scheduled to be detected from the perspective of the snake, as it is the square the shape actually changing over time and more practically the only shape of its kind. It also make sense as it is the snake actively seeking the items and not the other way around.

A `snake:collides` function can be set up to leverage an AABB detection collision test with the item(s), and return true when the two shapes overlap. A more refined version might consider the roundness of the item(s) but immediately it is possible to work with the bounding box. Also and most importantly, the movement of the snake means that collision is always and either vertical or horizontal, so that even considering a circle there is always an overlap between the shapes.

## Snake:collides()

The function implements an AABB detection collision test by checking if the snake can overlap with the item. Here's the logic:

- checking the horizontal coordinate, verify that the snake is either to the left or to the right of the item. If so, given that the two are continuous, regular shapes, the two cannot be overlapping. Return false.

- checking the vetical coordinate, repeat the logic, but verify that the snake is either above or below the item. In this instance, the same conclusion is reached. The two cannot be overlapping. Return false.

- if both conditions don't resolve, there's only one alternative: the two are overlapping a collision is detected.

```lua
-- function detecting a collision with an item
function Snake:collides(item)
  -- check if the snake and item cannot overlap
  if self.x  + self.width < item.x + ITEM_OVERLAP or self.x > item.x + item.size - ITEM_OVERLAP then
    return false
  end
  if self.y + self.height < item.y + ITEM_OVERLAP or self.y > item.y + item.size - ITEM_OVERLAP then
    return false
  end

  -- if they cannot not being overlapping, they overlap
  return true
end
```

Notice the use of `ITEM_OVERLAP`. This is introduced to avoid detecting a collision as the snake is exactly on the side of the item, which inevitably occurs given the grid-based structure of the game. By having the collision-area smaller than the actual shape of the item it is possible to detect a collision only when the snake is on the same cell.

## main.lua

With the function implemented, its logic is included in `main.lua` and in the update function specifically.

```lua
function love.update(dt)
  item:update(dt)
  snake:update(dt)

  if snake:collides(item) then
    item.inPlay = false
    score = score + 50
  end
end
```

Once the collision is detected, the item is made disappearing through the `inPlay` boolean. In addition, a made-up integer describing the score is updated to have visual confirmation of the actual collision.

Bear in mind: setting the boolean to false prevents the item from being drawn on the screen, but a collision is still detected when the coordinate match. With the following update the code will be modified to include a table of instances of item classes instead of a single item, and in light of this the items can be added/removed as needed, but immediately it is possible to fix this annoyance by checking for a collision when an item is also into play.

```lua
function love.update(dt)
  item:update(dt)
  snake:update(dt)

  if snake:collides(item) and item.inPlay then -- collision **and** inPlay set to true
    item.inPlay = false
    score = score + 50
  end
end
```
