# Flappy Bird 0 - Images

### love.graphics.newImage()

To add images to the game you need to leverage the `love.graphics.newImage()` function. It takes as argument the path to the image and creates an asset you can later include in the game. A drawable, if I have heard correctly.

```lua
local background = love.graphics.newImage('Resources/background.png')
local ground = love.graphics.newImage('Resources/ground.png')
```

Just remember to create those variables not in the `load` function, but in the global scope, alongside the window's width and height.

Both are stored in a `local` variable, which means that they are accessible only within the file in which they are created (`main.lua`).

### love.graphics.draw()

To actually paint the image in the game, you make use of the `love.graphics.draw()` function. It accepts as argument:

- a drawable;

- the coordinates (x, y) at which to include the asset.

And includes it in the window. There's still an issue to be resolved as it relates to sizes, namely the size of the assets vis a vis the size of the window, and also the virtual window. More research is warranted as this is a rather essential aspect.

### Small Notes

The images are drawn on the screen and represent a solid layer on the screen. This means that if you print a string before the images, it would be hidden behind them.
