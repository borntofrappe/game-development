# Motion Puzzle

[Motion Puzzle](https://serebii.net/mini/puzzle/#motion) is a game developed for the Pokemon Mini system where you are tasked to swap the pieces of a picture until you complete the original design. The goal of this project is to replicate the basic concept starting from a spritesheet and a couple of levels.

## Sprite Batch

First introduced in `Practice/Excavation`, the concept of a sprite batch helps to efficiently render a series of visuals. In `main.lua`, the feature helps to render the tiles making up the background.

## Levels, frames and puzzle pieces

The idea is to include a nested structure highlighting:

1. the level

2. the frame

3. the puzzle pieces

With this setup a puzzle class should be able to populate a grid of pieces in a random order, and ultimately cinclude the game when the columns and rows of the grid match the columns and row of the pieces.
