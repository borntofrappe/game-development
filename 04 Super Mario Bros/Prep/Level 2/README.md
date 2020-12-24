Add variety in the form of chasm.

## Skip

The idea is to populate an entire column with the tile representing the sky — an empty tile. The lecturer introduces a `goto` statement, but in the version of this update, such a construct is necessary. In the lecturer's version:

- populate the table with sky tiles only

- loop through the table column by column

- depending on the value of certain flags, add bricks, or skip columns altogether.

In this version however:

- loop through the table column by column

- set a height for the sky tiles

- change the height depending on the value of the flags
