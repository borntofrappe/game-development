# Minesweeper

[The Coding Train](https://youtu.be/LFU5ZlrR21E) explains the game's logic of the game Minesweeper with the p5.js library. Here I try to take the lessons learned in the video and implement the game with Lua, Love2D, touch controls, and the UI of Minesweeper from the android application _Google Play Games_.

## Notes

- cell in its various states: dark, revealed, mine, neighboring mines

- grid populating a 2d grid

- window sized according to the number of columns and rows

- 1 based indexing

- on click reveal the cell corresponding to the x,y coordinates

- populate grid with a fixed number of mines. `mines` and `minesCoords` with a `repeat ... until` loop in the initialization of the grid

- add hints by looping through the grid and count the number of neighboring mines. Only for non-mine cells. `math.min` and `math.max` help to constrain the cells to the existing columns and rows. Tilde character `~` to check for inequality `~=`

---

- a fixed number of mines; pick a cell, making sure not to pick the same cell twice (array of options, from which you remove the chosen option)

- if a clicked cell has no neighbor, reveal all adjacent cells without a mine, recursively. Flood algorithm whereby you reveal the neighbor and call the function reveal. Make sure not to call the function with a revealed cell
