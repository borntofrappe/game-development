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

## Wilson Algorithm

Instead of a purely random walk, such as the one described in the previous algorithm, Wilson's approach leverages a loop-erased random walk. It has the same benefit of Aldous Broder, in being unbiased, but is suffers from a similar drawback, being slow (technically slow to start, as will be explained briefly).

You can break down the algorithm's logic in two phases:

- immediately, pick a cell at random and mark it as visited

- recursively, proceed to create connection with a random walk:

  - pick an unvisited cell, and take note of its position

  - pick a neighbor at random. Note its position while moving to the cell

  - continue picking neighboring cells until you reach a visited cell

  - when you reach a visited cell, remove the gates of the noted cells in the manner described by the path

  - if the noted cells create a loop, erase said loop

  - repeat the random walk until every cell has been visited

As you progress and find visited cells, it becomes easier and easier to find a path, meaning the algorithm is slow to start, and increases in speed once there are a few visited cells.

## Hunt and Kill Algorithm

The algorithm is similar to Aldous-Broder, performing a random walk from cell to cell. However, unlike the previous approach, the algorithm changes in the moment it finds a cell which has already been visited. In this instance, it performs a search for an unvisited cell with a visited neighbor.

In detailed steps:

- pick a cell and mark it as visited

- pick a neighbor at random

- if the neighbor has not already been visited, connect the two and visit the cell

- if the neighbor has already been visited, "hunt" for an unvisited cell

  - loop through the grid top to bottom, left to right

  - look for the first unvisited cell with a visited neighbor

  - connect the cell with the neighbor, and visit the same cell

  - resume the random walk picking a neighbor at random

In the implementation, I rely on a `goto` statement to break out of the nested loop.

_Please note_: the demo includes the `Timer` utility to show the different steps and through the `highlight` variable. For the purposes of the algorithm, it is however unnecessary.

## Recursive Backtracker

The algorithm is similar to Hunt and Kill (and therefore Aldous-Broder), but it does differ in the way it seeks an unvisited cell. Faced against a visited cell, it goes through the previous cells (backtracking its way on the beaten path), and looks for unvisited neighbors cell by cell.

In detailed steps:

- create a stack

- pick a cell, visit it and add it to the stack

- pick a neighbor at random

- if the neighbor has not already been visited, connect to the neighbor, visit it and add it to the stack

- if the neighbor has already been visited, backtrack the cells in the stack

  - loop through the stack removing cells one at a time

  - look for unvisited neighbors

  - connect the already visited cell with one of its unvisited neighbors

  - add the neighbor to the stack

  - resume the random walk

_Please note_: the demo includes the `Timer` utility to show the different steps and through the `highlight` variable. For the purposes of the algorithm, it is however unnecessary.
