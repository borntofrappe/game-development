# Minesweeper

[The Coding Train](https://youtu.be/LFU5ZlrR21E) explains the game's logic of the game Minesweeper with the p5.js library. Here I try to take the lessons learned in the video and implement the game with Lua, Love2D, touch controls, and the UI of Minesweeper from the android application _Google Play Games_.

## Notes

A grid of columns and rows.

A cell with a few bits of information

- has a mine

- x, y, size

- is revealed

- number of neighbors

- The data structure is a A 2D array describing the columns first and the cells later

[
[,,,]
[,,,]
[,,,]
]

- position on the basis of the index of the column and row (lua 1 base indexing)

- mechanism to reveal, on click considering the x and y coordinate of the mouse cursor

- how many neighbors have a mine considering the neighbors -1,1; -1, 1 skipping 0 0. Consider only the cells in the grid

- a fixed number of mines; pick a cell, making sure not to pick the same cell twice (array of options, from which you remove the chosen option)

- if a clicked cell has no neighbor, reveal all adjacent cells without a mine, recursively. Flood algorithm whereby you reveal the neighbor and call the function reveal. Make sure not to call the function with a revealed cell

## Game

Similarly to tetris, the size of the window is computed from the number of columns, rows and the sizr of the individual cell
