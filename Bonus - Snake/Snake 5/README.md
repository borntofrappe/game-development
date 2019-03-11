# Snake 5 - Multiple Items

With update 5 the game begins contemplating not a single item, but multiple instances of the same class. Switching to multiple instances is a matter of including a table of instances instead of a variable referring to one, but keeping track of the logic behind multiple instances requires a few more lines of code.

Currently the idea is as follows: have one item spawn. As the snake collects the item, or as the item itself disappears due to the passing of the pre-established amount of time, have another item appear. And so forth and so on. In this frame of reference there exist only one item on the screen, and multiple instances simply follow one another.

## main.lua

Instead of having one variable referring to one item:

```lua
item = Item:init({
    x = randomCell(),
    y = randomCell(),
    color = randomColor()
  })
```

A table is created to nest all possible items:

```lua
-- create an table for the instance of the item class
items = {}
-- immediately add an instance to have it rendered/updated on the screen
local item = Item:init({
    x = randomCell(),
    y = randomCell(),
    color = randomColor()
  })
table.insert(items, item)
```

Created and immediately populated with one instance of the item class.

In light of this change any call referencing a single item, such as in the update or render function, needs to be modified to consider the items in the table, by looping through the same construct.

For the `render()` function for instance:

```lua
item:render()
```

Becomes:

```lua
for k, item in pairs(items) do
  item:render()
end
```

## Adding items

As it stands, the code renders the single item exactly like in update 4. That being said, including the instance through a table allows to easily expand the structure.

For this occasion I decided to create a custom function to create an instance of the item class and add it to the global table.

```lua
-- function adding an instance of the item class in the items table
function addItem()
  local newItem = Item:init({
    x = randomCell(),
    y = randomCell(),
    color = randomColor()
  })

  table.insert(items, newItem)
end
```

This is helpful as a new item might be added following different occurrences, such as when the snake collides with an item, or when no item is present on the screen.

Indeed in `love.update(dt)` the function is immediately called when the table is empty,

```lua
if #items == 0 then
  addItem()
end
```

## Removing Items

Previously, an item was rendered on the basis of the `inPlay` boolean. While conditionally rendering the item did effectively hide the shape, it did not remove it from consideration. This is especially concerning as more and more items are included through the table. Simply put, you can hide the items with the boolean, but the table becomes ever larger and less maintainable.

Having a table also helps however, as it is now possible to use the `inPlay` boolean not to conditionally render the items, but to effectively remove them from the table.

This immediately means that `Item.lua`, and specifically the `Item:render()` function can be updated to simply render the circle. No `if` statement required.

```lua
function Item:render()
  love.graphics.setColor(self.color.r, self.color.g, self.color.b)
  love.graphics.circle('fill', self.x + self.size / 2, self.y + self.size / 2, self.size/2)
end
```

Indeed `items` as a table is made to hold only those items which have not been collided with or those items which have not yet disappeared. When the snake collides with the items, when the passing of time dictates that the items should disappear, the `inPlay` boolean is always updated, to have it resolve to false.

```lua
function love.update(dt)
  -- for loop
  if snake:collides(item) then
    item.inPlay = false -- switch inPlay to false
    score = score + 50
  end
end
```

```lua
function Item:update(dt)

  if self.inPlay then
    self.currentTime = self.currentTime + dt
    if self.currentTime > self.playTime then
      self.inPlay = false -- switch inPlay to false
      self.currentTime = 0
    end
  end

end
```

In `love.update(dt)` however, the flag is used to have those items signalled no longer to be in play effectivelly removed from the table.

```lua
function love.update(dt)
  -- in the for loop
  if not item.inPlay then
    table.remove(items, k)
  end
end
```

This is rather important: `k` refers to the index of the item in the table, not an identifier behind every item. In other words, if there were 5 items and you were to remove the first one, every item following the first one will be later referred to with a smaller index value (the second item would become the first and so forth). It may not be a huge concern, but something to be knowledgeable about.
