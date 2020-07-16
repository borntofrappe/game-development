# Snake 3 - Item

Moving on from the refactoring update, update 3 covers an essential feature of the game: have items which can be collected by the snake as it moves within the boundaries of the grid. One important aspect of the game is a scoring system keeping track of these items being picked up, not to mention a level structure which allows to have the snake becoming longer and longer. Both of these aspects will be however covered at a later stage.

To ease the transition toward the finished game, the current update sets out to include only one item at a time and have it appear for a brief amount of time.

## Item Class

Each item is made to resemble the snake, in the coordinate, size and shape it assumes. Beside including a square, the class also defines a color table, in which to specify rgb codes. Comes the instantiation of every item, the idea is to have a random set of hexes influence a random hue on the square.

Beside this small addition, the class is originally a dumbed down version of the Snake class.

```lua
Item = {
  x = 0,
  y = 0,
  width = ITEM_WIDTH,
  height = ITEM_HEIGHT,
  color = {
    r = 1,
    g = 1,
    b = 1
  }
}
```

The render function is also and basically a copy of the snake counterpart.

```lua
function Item:render()
  love.graphics.setColor(self.color.r, self.color.g, self.color.b)
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
```

## main.lua

With _Item.lua_ as described above, _main.lua_ is able to include the square for the item much similarly to how it incorporates the snake.

- create an instance of the class.

  ```lua
  item = Item:init({
      x = randomCell(),
      y = randomCell(),
      color = randomColor()
    })
  ```

  Notice how the the color is dictated through another function. There's nothing special about this function, as it just returns a table for the specified rgb format.

- render the item through the matching function.

  ```lua
  item:render()
  ```

  I decided to include the item **before** the square making up the snake, as the idea is to have the item disappear as the snake overlaps on the shape in question.

## inPlay

With the current setup, a square of a slightly random color appears on the screen, at a random cell in the makeshift grid. To add the first feature of the item, the ability to appear and disappear after a small interval, a boolean is introduced on the item class. Through _inPlay_ it is possible to conditionally render the square only when the boolean resolves to true.

```lua
if self.inPlay then
  love.graphics.setColor(self.color.r, self.color.g, self.color.b)
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
```


Ultimately I envision a table collecting instances of _Item_ classes, and this table could be responsible for including only those items with the boolean set to true, but for starters it is immediately effective to have the condition set up in the render function.

Through _self.inPlay_ it is possible to show/hide the item. To have it spawn for a brief amount of time however, two more variables are necessary:

- a variable describing the amount of time the item should remain on the screen;

- a variable keeping track of the passing of time, and compared to the first variable to establish when the described amount of time has indeed passed.

I decided to have both variables in the declaration of the _Item_ class, with the idea that each item is responsible for its own lifecycle.

```lua
Item = {
  x = 0,
  y = 0,
  width = ITEM_WIDTH,
  height = ITEM_HEIGHT,
  color = {
    r = 1,
    g = 1,
    b = 1
  },
  inPlay = true,
  -- time variables to have the items spawn for a selected amount of time
  playTime = 10,
  currentTime = 0
}
```

To add variation comes initiation time, it is possible to alter `playTime` when instantiating the `Item` class, but it is also possible to change its value in the `:init` function, when setting up the fields of the `o` table.

```lua
-- initialize the item instance
function Item:init(o)
  o = o or {}
  -- set a random number of seconds for playTime
  if not o.playTime then
    o.playTime = math.random(5, 10)
  end
  self.__index = self
  setmetatable(o, self)
  return o
end
```

When a class is created, and unless a value has already been specified, the item is generated with a different time value.

With the variables set up, updating the appearance of the item is a matter of keeping track of the passing of time in the update function. In here we ultimately use the current and play time values to have the boolean `inPlay` toggle to false.

```lua
-- switch the inPlay boolean to false after currentTime reaches playTime, considering the passting of time through dt
function Item:update(dt)

  if self.inPlay then
    self.currentTime = self.currentTime + dt
    if self.currentTime > self.playTime then
      self.inPlay = false
      self.currentTime = 0
    end
  end

end
```

One final, essential note: following the completion of the `Item` class it is necessary to include the call to the `update(dt)` function to have the instance of the item actually change over time.

```lua
function love.update(dt)
  item:update(dt) -- update the item
  snake:update(dt)
end
```

## Item Shape

Instead of having the item rendered as a square I ultimately decided to pick up another `love.graphics` function, to have the items visually different from the snake.

I opted for drawing a circle through `love.graphics.circle`, and simplified the item class by removing the width and height and consider a single value in the size of the circle.

```lua
love.graphics.circle('fill', self.x + self.size / 2, self.y + self.size / 2, self.size/2)
```
