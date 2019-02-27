# Match Three 3 - Update the Board

Once the tiles are set to `nil`, it becomes necessary to update the board, to have the tiles above the matches fall into place. The idea, as mentioned in the previous update, is to loop one column at a time, from the bottom and upwards, shifting tiles when encountering a `nil` value.

