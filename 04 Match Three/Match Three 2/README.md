# Match Three 2 - Removing Matches

Once `self.matches` stores all those adjacent tiles resulting in an match, it is necessary to remove them. Remove them from view and from the table of tiles. This also means that the table needs to be re-populated with new tiles, but one step at a time.

Upon removing the tiles it is indeed necessary to adjust the existing display, to re-allocate the remaining tiles in the places left by the cleared squares.

The approach can be described as follows:

- remove the tiles;

- loop from the bottom up, considering the grid one column at a time. It is indeed necessary to account only for gravity in the vertical dimension;

- upon finding a tile, do nothing;

- when finding a hole, left by a cleared tile, proceed upwards to find the next existing tile. If finding one of such type, bring it back down where the hole is found.

- repeat for every cell, for every column and bottom up.
