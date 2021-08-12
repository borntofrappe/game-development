# Level 2

## Skip

The idea is to populate an entire column with the tile representing the sky — an empty tile. The lecturer introduces a `goto` statement, but I implemented the feature with a different solution.

In the lecturer's version:

- populate the table with sky tiles only

- loop through the table column by column

- depending on the value of a few flags add bricks at a precise `y` coordinate or skip columns altogether

Here instead:

- loop through the table column by column

- set a height for the sky tiles, changing the value depending on the value of a few flags

- populate the column with the necessary sky and ground ids
