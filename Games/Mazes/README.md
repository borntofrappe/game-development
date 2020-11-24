# Mazes

Projects created while going through this entertaining book by [**Jamis Buck**](https://twitter.com/jamis): [_Mazes for Programmers Code Your Own Twisty Little Passages_](http://www.mazesforprogrammers.com/).

Starting from a grid with an arbitrary number of rows and columns, each demo also sports a table describing the player. This one is depicted through a circle which moves in the maze considering the available borders and the direction expressed by arrow keys.

## Binary Tree Algorithm

- visit every cell

- remove a gate north or east

- do not create any exit

The instructions mean that the first row and the last column will have the same pattern for every maze, with an uninterrupted corridor leading up to the top right corner. This feature describes the texture and the bias of the specific maze.

> Texture and bias allow to describe the style and tendency of a maze

It is a simple algorithm, which is yet capable of building useful structure. If the bottom left corner provides a clear-cut solution inspired by the maze's bias, consider a situation in which the starting point is moved elsewhere in the structure.

It is also efficient. To build the maze it is necessary to visit each cell only once. Moreover, it is only necessary to store in memory the value of a single cell at a time.

## Sidewinder Algorithm

- visit every cell, traversing each row left to right

- pick a gate east or north. North of one of the visited, available cells in the current row (explained with a few more words below)

- do not create any exit

As you traverse the grid, one row at a time and from the left to the right, you select a gate east or north.

If east, remove the gate.

If north, consider the current cell with the ones coming earlier in the row. Pick one at random and from only this one clear the north gate. Once you do this, close the cells. This means that going forward, these cells won't be affected by another cell in the same row.

This slightly more complex algorithm has a bias toward the top of the maze. In the first row, you find an uninterrupted corridor.

Unlike the binary tree algorithm, there's no guarantee that the last column will provide an uninterrupted corridor. This because the last cell could very well select north and pick a gate from the previous cells.

## Simplified Dijkstra

This is a first attempt at describing the path between a point and any other point in the grid. In the spirit of making the experience more interactive, the demo waits for a key press on the enter key, and then proceeds to populate the grid with the distance from the selected cell-

The function works as follows:

- accept a cell as well as a level of depth. This value begins at `0`

- mark the current cell with the depth value

- look for accessible neighbords. That is neighbors which can be visited, without a gate between the two cells

- call the function again, for the neighboring cell, and for an incremented depth value

To illustrate the recursive process even further, I've decided to include a `Timer` utility. The idea is to here add a delay between successive function calls, and show the different steps taken through Dijkstra's algorithm.

## Aldous-Broder Algorithm

- pick a cell in the grid

- choose a neighbor at random

- if not visited, link to it by removing the connecting border

- if visited, do nothing

- move to the selected cell and repeat from step 2, selecting a new neighbor

- repeat until every cell has been visited

This algorithm allows to remove any bias, at the price of slower runtime.

In the demo, I illustrate how the algorithm works with the `Timer` utility, and by calling the `aldousBroder` function with a delay.
