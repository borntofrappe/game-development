# Tile Collision

With the world created through the `generateLevel` function, it becomes necessary to detect a collision between the character and the ground tiles. This to have the pillars actually work as obstacles and chasms works as pitfalls.

## Detect Collision

Instead of using the AABB detection collision test, which would be rather resource-intensive given the number of tiles and possible collisions, the lecturer introduces a new approach, based on the table of tiles created through the mentioned generate-function.

The approach is explained in the context of the completed game, structured in classes and states. That being said, the reasoning holds true even with `main.lua` encompassing the entirety of the code.

Back to detecting collision, the idea is to create a function, `pointToTile()`, which allows to exactly convert coordinates to tiles. Once converted, it is possible to check if the tiles are solid and act accordingly.

The lecturer provides the possible collision according to how the character behaves in the game. A collision with tiles atop the character can be found only as the character jumps. A collision with tiles left and right only as it moves. A collision with tiles downwards only as it moves or falls.

### pointToTile

This function accepts as argument the `x` and `y` coordinates of a point (like the mentioned coordinates of the character).

Immediately, it checks if the horizontal coordinate of the point exceeds the boundaries of the character, to return `nil`. This is done as a precautionary test.

Following this check, the function returns the tile identified by the coordinate. The exact tile is found by considering the coordinate and the fact that each tile occupies a fixed width.

```lua
return tiles[math.floor(y / TILE_SIZE) + 1][math.floor(x / TILE_SIZE) + 1]
```

Notice how the values are incremented to make up for the tiles being indexed starting at 1.

### main.lua

In my own solution, trying to incorporate the `pointToFile` function, I decided to update the description of each tile. From a table referring to the `id` and the `topper` flag:

```lua
tiles[y][x] = {
  id = tileGround,
  topper = y == groundLevel and true or false
}
```

I decided to include the position in the grid as well, through `x` and `y`.

```lua
tiles[y][x] = {
  x = x,
  y = y,
  id = tileGround,
  topper = y == groundLevel and true or false
}
```

This is done to have a reference specifically to the vertical position of the tile, and will become useful soon enough.

Based on the new function, and in `love.update`, I modified the logic allowing to move the character downwards. Instead of using the constant `MAP_SKY`, I introduced a variable for the ground level, `groundLevel`. This is initialized to the height of the map, to have the character by default move towards the bottom of the screen.

```lua
-- initialize groundLevel to MAP_HEIGHT
-- this means that by default the character moves toward the very bottom of the screen
groundLevel = MAP_HEIGHT

-- update the dy according to gravity
-- dy being a negative value and gravity being a positive one means dy is slowly becoming positive and directing the character downwards
gCharacter.dy = gCharacter.dy + GRAVITY
-- update the vertical coordinate according to dy
gCharacter.y = gCharacter.y + gCharacter.dy * dt
```

It is then used in the conditional stopping the character when it reaches the prescribed vertical coordinate.

```lua
-- set gCharacter.dy back to 0 when reaching the ground level
if gCharacter.y >= groundLevel * TILE_SIZE - CHARACTER_HEIGHT then
  gCharacter.y = groundLevel * TILE_SIZE - CHARACTER_HEIGHT
  gCharacter.dy = 0

  -- set the default animation to the idle state
  currentAnimation = idleAnimation
end
```

This might seem like a trivial change, but the purpose of `groundLevel` is shown before the mentioned conditional.

When `dy` is greater than 0 , the `pointToTile()` function is indeed used to find a ground tile, at the bottom left or bottom right of the character. If one of such tile is found, the logic is to update `groundLevel` to the vertical coordinate of the tile.

```lua
-- if the character is falling
if gCharacter.dy > 0 then
  -- include the falling animation
  currentAnimation = fallingAnimation

  -- find the tiles at the bottom left and bottom right of the character
  bottomLeft = pointToTile(gCharacter.x + 1, gCharacter.y + CHARACTER_HEIGHT + 1)
  bottomRight = pointToTile(gCharacter.x + CHARACTER_WIDTH - 2, gCharacter.y + CHARACTER_HEIGHT + 1)

  -- if there is a tile in the bottom left (not nil) and its id is different than 1, it means a ground tile is found
  if bottomLeft and bottomLeft.id ~= TILE_SKY then
    -- set the ground level to refer to the vertical position of the tile in the grid
    groundLevel = (bottomLeft.y - 1)
  end

  -- same reasoning for the
  if bottomRight and bottomRight.id ~= TILE_SKY then
    groundLevel = (bottomRight.y - 1)
  end
end
```

It may look convoluted, but the logic is sound: have `groundLevel` refer to the bottom of the page or a ground tile, when the character moves downwards.

This covers a collision with the ground. For a collision with bricks atop the character, the logic needs to be reasonably flipped. When `dy` is negative, check for a tile different than a sky tile in the top left and top right corners. If so set `dy` immediately to 0, set `y` to the position of the tile plus the height of the character.

I will accommodate for such a feat once ground tiles are included mid-air.

For the collision with pillars, `pointToTile` is used when the left or right keys are being pressed. The logic is rather straightfoward: when going right, find the tiles in the top right and bottom right corner of the character. If these are sky tiles, allow for movement.

That's it. It is just important to consider the bottom right corner slightly offset from the coordinate of the character plus its height. This because inevitably the bottom right corner of the character touches the ground.

```lua
if love.keyboard.isDown('right') then
  -- update the position of the character, conditional to ground tiles not being present on the right of the character
  topRight = pointToTile(gCharacter.x + CHARACTER_WIDTH, gCharacter.y - 1)
  bottomRight = pointToTile(gCharacter.x + CHARACTER_WIDTH, gCharacter.y + CHARACTER_HEIGHT - 1)

  -- move only if the tiles are sky tiles
  if topRight.id == TILE_SKY and bottomRight.id == TILE_SKY then
    gCharacter.x = gCharacter.x + CHARACTER_SCROLL_SPEED * dt
    currentDirection = 'right'
    if gCharacter.dy == 0 then
      currentAnimation = movingAnimation
    end
  end
end
```

When going left the logic is the same, albeit considering the left side.
