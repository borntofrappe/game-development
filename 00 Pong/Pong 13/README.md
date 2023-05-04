# Pong 13

_Please note:_ `main.lua` depends on `push.lua`, `class.lua`, `font.ttf` and the sound files in a `sound` folder being available a `res` folder

## Resize

In the options detailed when setting up the screen (both through `setMode` and later through the `push` library and `push:setupScreen()`), the window was set with a fixed width and height. `resizable` was also set to `false`.

Setting the flag to `true` allows to resize the window, but it is necessary to update the projection whenever the size changes.

```lua
push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = true,
    vsync = true
  })
```

Love2D calls `love.resize` whenever the window changes in size, with the new width and height. Override the function to resize the projection per the push library and `push.resize()`.

```lua
function love.resize(width, height)
    push:resize(width, height)
end
```
