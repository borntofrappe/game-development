# Terrain

Here I explore how to create the terrain for the eventual game.

## Flat line

Render a line by connecting a series of points. This allows to later create holes by modifying the `y` coordinates of consecutive points.

## Trigonometric holes

Include holes in the form of a series of points with varying `y` coordinates. The value is modified through the `sin` function and considering the range `[math.pi, 0]`, describing a counter-clockwise arc.
