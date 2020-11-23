# Mazes

Projects created while going through this entertaining book by [**Jamis Buck**](https://twitter.com/jamis): [_Mazes for Programmers Code Your Own Twisty Little Passages_](http://www.mazesforprogrammers.com/).

Starting from a grid with an arbitrary number of rows and columns, each demo also sports a table describing the player. This one is depicted through a circle which moves in the maze considering the available borders and the direction expressed by arrow keys.

## Binary Tree

- visit every cell

- remove a gate north or east

- do not create any exit

The instructions mean that the first row and the last column will have the same pattern for every maze, with an uninterrupted corridor leading up to the top right corner. This feature describes the texture and the bias of the specific maze.

> Texture and bias allow to describe the style and tendency of a maze

It is a simple algorithm, which is yet capable of building useful structure. If the bottom left corner provides a clear-cut solution inspired by the maze's bias, consider a situation in which the starting point is moved elsewhere in the structure.

It is also efficient. To build the maze it is necessary to visit each cell only once. Moreover, it is only necessary to store in memory the value of a single cell at a time.
