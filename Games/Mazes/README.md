# Mazes

With this folder I set out to implement a series of algorithms to create perfect mazes, mazes in which any two cells can be connected by one path. It is inspired by the book [_Mazes for Programmers Code Your Own Twisty Little Passages_](http://www.mazesforprogrammers.com/), and specifically the first part of the volume.

There is no game, currently, but a series of demos creating mazes with the different algorithms. A circle represents the player, but its only feature is the ability to walk in the maze constrained by the existing gates.

## Algorithms

### Binary Tree

- visit every cell

- remove a gate north or east

- do not create any exit

The instructions mean that the first row and the last column will have the same pattern for every maze, with an uninterrupted corridor leading up to the top right corner. This feature describes the texture and the bias of the specific maze.

It is a simple algorithm, which is yet capable of building useful structure. If the bottom left corner provides a clear-cut solution inspired by the maze's bias, consider a situation in which the starting point is moved elsewhere in the structure.

It is also efficient. To build the maze it is necessary to visit each cell only once. Moreover, it is only necessary to store in memory the value of a single cell at a time.

### Sidewinder

- visit every cell, traversing each row left to right

- pick a gate east or north. When picking the north side, however, pick the gate of one of the visited, available cells in the current row

- do not create any exit

In detail, and as you traverse the grid, one row at a time and from the left to the right, you select a gate east or north.

If east, remove the gate.

If north, consider the current cell with the ones coming earlier in the row. Pick one at random and from only this one clear the north gate. Once you do this, close the cells. This means that going forward, these cells won't be affected by another cell in the same row.

This slightly more complex algorithm has a bias toward the top of the maze. In the first row, you find an uninterrupted corridor.

Unlike the binary tree algorithm, there's no guarantee that the last column will provide an uninterrupted corridor. This because the last cell could very well select north and pick a gate from the previous cells.

### Simplified Dijkstra

This is a first attempt at describing the path between a point and any other point in the grid. In the spirit of making the experience more interactive, the demo waits for a key press on the enter key, and then proceeds to populate the grid with the distance from the selected cell.

The function works as follows:

- accept a cell as well as a distance. This value begins at `0`

- mark the current cell with the distance value

- look for accessible neighbords. That is neighbors which can be visited, without a gate between the two cells

- call the function again, for the neighboring cell, and for an incremented distance value

To illustrate the recursive process even further, I've decided to include a `Timer` utility. The idea is to here add a delay between successive function calls, and show the different steps taken through Dijkstra's algorithm.

_Please note_: the demo creates a maze with the sidewinder algorithm, but any algorithm modifying the grid would work.

### Aldous-Broder Algorithm

- pick a cell in the grid

- choose a neighbor at random

- if not visited, link to it by removing the connecting border

- if visited, do nothing

- move to the selected cell and repeat from step 2, selecting a new neighbor

- repeat until every cell has been visited

This algorithm allows to remove any bias, at the price of slower runtime.

### Wilson Algorithm

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

### Hunt and Kill Algorithm

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

### Recursive Backtracker

The algorithm is similar to Hunt and Kill (and therefore Aldous-Broder), but it does differ in the way it seeks an unvisited cell. Faced against a visited cell, it goes through the previous cells (backtracking its way on the beaten path), and looks for unvisited neighbors cell by cell.

It is based on the concept of a stack, a data structure where you add items to and remove items from the end. In lua, with `table.insert` and `table.remove`.

- pick a cell at random and add it to the stack (above)

- from the top of the stack, pick a neighbor at random

- if the neighbor has not already been visited, connect the current cell to said neighbor

  - visit the neighbor

  - add the neighbor to the stack

- if the neighbor has already been visited, backtrack the cells in the stack

  - loop through the stack removing cells one at a time

  - look for unvisited neighbors

  - connect the already visited cell with one of its unvisited neighbors

  - add the neighbor to the stack

- continue until the stack is empty

## Shapes

### Masking

The idea is to alter the default structure provided by a regular, complete grid. The effect is achieved by having some of the cells initialized with a `nil` value, and by modifying the algorithm so that, when it considers the possible connections, it disregards the same value.

```lua
if
  -- previous conditions
  or not grid.cells[cell.column + connections[i].dc][cell.row + connections[i].dr]
  then
  table.remove(connections, i)
end
```

_Please note_: unlike the previous demos, using the constants `COLUMNS` and `ROWS`, the project aptly considers the columns and rows on the basis of the mask and its length.

_Please note_: the demo uses the algorithm developed in the project _Recursive Backtracker_, but other algorithms would work as well. All except the binary tree and sidewinder algorithm, which rely on the grid having non-nil cells.

### Circle Maze

The `love.graphics` module provides the `arc` function to the different cells around the center. The function accepts an optional second argument for the arc type which embodies the desired result.

```lua
love.graphics.arc("line", "open", 0, 0, 20, 0, math.pi / 2)
```

Without specifying the type as `open`, the result is that the function draws two straight lines connecting the arc to the center of the grid.

Past this detail, the folder implements a circular shape with polar coordinates and the recursive backtracker algorithm. The structure of the grid is modified from one using columns and rows to one using rings and slices of each ring.

_Please note_: the rings have an equal number of slices, which leads to the maze having a rather uneven structure. This is fixed in a different demo fully implementing a theta maze. I decided to preserve this project as well to illustrate how the code changes from the grid-based demos.

### Polar Mae

Building on top of the previous project, the game tries to make a more realistic maze, one in which the cells are not excessively disparate in size. This is achieved by doubling the number of slices every other ring, and requires a few adjustments to the codebase.

In `Grid.lua`, `count` is used to keep track of the number of slices in the ring. The idea is to double this measure according to the modulo operator, and when the ring describes an even ring (second, fourth and so forth).

```lua
local count = ringsCount
for ring = 1, rings do
  if ring % 2 == 0 then
    count = count * 2
  end
end
```

The same measure is then used not only to describe how many arcs should be in the specific ring, but also the angle of the mentioned arcs.

```lua
local angle = 2 * math.pi / count
for ringCount = 1, count do
  -- add ring
end
```

This takes care of populating a grid with more cells as the structure progresses outwards. It does not, however, solve the way the recursive backtracker algorithm works. Now the cells have more than four neighbors, or at least the cells in the odd ring have more than four neighbors (five). To fix this, `connections` considers an addditional connection.

```lua
if cell.ring % 2 ~= 0 then
  table.insert(
    connections,
    {
      ["gates"] = {"up", "down"},
      ["dr"] = 1,
      ["dc"] = -1
    }
  )
end
```

The idea is to consider two neighbors in the outer ring. Since the the number of cells in ring changes however, it is necessary to double the counter variable describing the individual slice.

```lua
if cell.ring % 2 ~= 0 and connection.dr == 1 then
  ringCount = cell.ringCount * 2 + connection.dc
end
```

This takes care of the outer ring. However, going inwards, it is necessary to consider the instance in which the destination ring has half the number of arcs. In this instance, and conversely to the previous operation, the counter is halved.

```lua
if cell.ring % 2 == 0 and connection.dr == -1 then
  ringCount = math.ceil(cell.ringCount / 2) + connection.dc
end
```

_Please note_: `connection.dc` is `0`, so it is actually unnecessary to add the measure

_Please note_: this is but one approach to solving the problem. An alternative, perhaps more declarative approach adds a field to the `Cell` class which describes the neighbors, and picks from one of said neighbors at each iteration.
