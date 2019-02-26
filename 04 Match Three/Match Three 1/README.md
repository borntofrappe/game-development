# Match Three 1 - Calculating Matches

With the swap feature implemented, it is a matter of recognizing a match: when three or more tiles of the same color are side by side.

The algorithm presented in the lecture is simple, yet effective:

- analyse the grid row by row;

- for each row, consider the color of the first tile;

- considering the color of the tile which follow, check if the two match;

- if the two match, increase a variable counting the number the matching colors;

- if the two don't match, reset the counter variable. Additionally, check if the counter is greater than or equal than three, in which case a match is found. In this instance, store all tiles with the same color in a dedicated table.

- repeat the operation for all rows;

- repeat the entire process analysing the grid column by column.

At the end of this lengthy process the table describes the tiles making up matches, if any. It is then possible to use said table to implement the games' features, like clearing the matching tiles and increasing the score.
