Here you run a `.lua` script in the love2d engine.

You also learn about the game loop and the coordinate system.

## Installing Love2D

It is first necessary to install the Love2D framework. From [the homepage itself](https://love2d.org/) the installer provides the quickest solution. Once installed, the main reference is [the wiki](https://love2d.org/wiki).

## Running a program

In the [getting started](https://love2d.org/wiki/Getting_Started) section, the wiki provides a few ways to run a love2d program. For proof of concept, here's how to print `Hello there` with the engine.

1. create a `main.lua` file

2. add the following three lines of code:

   ```lua
   function love.draw()
     love.graphics.print('Hello there', 400, 300)
   end
   ```

3. drag **the folder** containing the `main.lua` file on top of the `Love2D` program, or a shortcut to said program

This is already enough to have Love2D open a window to show the arbitrary string.

## Theory

### Game loop

A game is an infinite loop. In this loop, we continuously go through a series of steps

- listen for input

- update the game according to the input

- render whatever was updated

### 2D Coordinate System

Exactly like with SVG syntax, the coordinate system works top to bottom, left to right.

If you think of a 1x1 square, the following representation highlights this coordinate system

```text
(0, 0) (1, 0)
(0, 1) (1, 1)
```
