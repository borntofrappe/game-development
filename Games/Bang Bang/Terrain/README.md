# Terrain

Here I explore how to create the terrain for the eventual game.

## Hills

Using the function for a normal distribution.

## Holes

Building on top of the terrain created in the previous section, the goal is to create the cavity caused by the eventual cannon ball. Instead of positioning the cavity following the trajectory of a cannon however, these holes are created following the mouse cursor and its horizontal coordinate.

The idea is to track the mouse in its `x` dimension, and following a press, render a hole by modifying the terrain and the points describes in the matching table. The holes are again created trigonometric functions, in order to create a semi-circle facing downwards.
