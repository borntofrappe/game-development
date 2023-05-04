# Pong 0

## LOVE2D

1. [Install LOVE2D](https://love2d.org/#download)

2. create a `main.lua` file

3. add the following three lines of code

   ```lua
   function love.draw()
     love.graphics.print('Hello world', 400, 300)
   end
   ```

To run the program you have at least two options:

1. drag **the folder** containing the `main.lua` file on top of the application `love.exe`, or a shortcut to said program

2. run the application from the command line

   ```bash
   # "application" "path to the folder containing main.lua"
   "C:\Program Files\LOVE\love.exe" "C:\game-development\00 Pong\Pong 0"
   ```

3. (VSCode) install [love-launcher](https://marketplace.visualstudio.com/items?itemName=JanW.love-launcher)

## 2D Coordinate System

The coordinate system works top to bottom, left to right.

If you think of a 1x1 square, the following representation highlights this coordinate system

```lua
--[[
  (0, 0) (1, 0)
  (0, 1) (1, 1)
]]
```
