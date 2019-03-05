# Character

With the scrolling of the camera implemented, the character is drawn through the image found in **character.png**. The file describes multiple versions of the characters, multiple stances actually. The idea is to use the different versions to animate the character, as it moves, jumps and reacts to the surrounding environment.

## Update 0 - character.lua

With the first update the application is updated to include the character.

This allows to practice once more with the quad function and most prominently with the coordinate system of Love2D. Indeed the character needs to be included atop the tiles making up the ground, and this is achieved by placing in a variable the number of tiles making up the sky.

After a bit of experimentation and taking stock of the lessons learned with SVG syntax, including the character at the desired vertical coordinate is a matter of acknowledging how the tiles and the character are drawn top to bottom, left to right.

## Update 1 - moving.lua

The second update allows to move the character left and right. This is achieved much alike the camera scroll, through a constant variable describing the speed and a cumuative variable changing the `x` coordinate of the shape being drawn.

I decided to take the concept a bit further and already include a small animation, by changing the quad being drawn in the page, but that will be covered in a later update. I started by including separate variables, and then create a table centralizing all the values held by the character. In the end it might be best to have a separate class, `Character`, which handles the entire logic through proprietary values.

Also: I temporarily disabled the scroll of the camera. Ultimately, it will stroll alongside the character, but at different speeds (less) to allow for the character to continue throughout the level.

## Update 2 - main.lua

With update 2 the application is modified as to move the character in the context of the camera. The idea is to have the character always centered in the middle of the screen. The feat is achieved by having `cameraScroll` refer to the character.

The table I created in `moving.lua` is updated to consider the horizontal and vertical coordinate of the characters in two fields.

```lua
gCharacter = {
  -- horizontally centered
  ['x'] = (VIRTUAL_WIDTH / 2) - (CHARACTER_WIDTH / 2),
  -- vertically right atop the ground tiles
  ['y'] = (MAP_SKY - 1) * TILE_SIZE - CHARACTER_HEIGHT
}
```

By default the character is shown in the middle of the screen and exactly where the ground tiles begin.

In `love.update()` the position of the character is then modified through the constant of `CHARACTER_SPEED`.

```lua
if love.keyboard.isDown('right') then
  -- uodate the position of the character
  gCharacter.x = gCharacter.x + CHARACTER_SCROLL_SPEED * dt
end
```

Instead of modifying the camera according to another constant however, the scroll of the perspective is tied to the coordinate of the character.

```lua
cameraScroll = gCharacter.x - (VIRTUAL_WIDTH / 2) + CHARACTER_WIDTH / 2
```

This to have the camera always centerd on the character.

Relevant update: as to avoid having the character moving past the left edge of the screen (which is unwanted behavior), it is possible to clamp the coordinate of the character to 0.

```lua
gCharacter.x = math.max(0, gCharacter.x - CHARACTER_SCROLL_SPEED * dt)
```

Likewise, and to highlight how the left edge of the screen is a hard border, it is possible to clamp the scroll of the camera.

The feature achieved by the update is then moving the character perfectly centered on the screen and having the left edge as an insurmountable obstacle. The character seems to reach the left edge, but it is actually the position of the grid which is clamped.
