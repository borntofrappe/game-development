# Pong 12

Index:

- [Resize](#resize)

Snippet:

- main.lua

## Resize

This looks like a minor update, so I'll be short: in the options detailed when setting up the screen (both through `setMode` and later through the `push` library and `push:setupScreen()`), the window was set with a fixed width and height. `resizable` was indeed set to `false`.

This update tries to introduce the possibility of resiing the window. Immediately, by switching that flag to true and later by updating the 'projection' made by the `push` library when the window itself is resized.

`love.resize` is here the function which is overriden to detail the desired behavior. `push.resize()` is then the function which takes the new width and height and resizes the projection.

```lua
function love.resize(w, h)
    push:resize(w, h)
end
```
