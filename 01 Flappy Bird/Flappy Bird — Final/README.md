# Flappy Bird — Final

With respect to the last increment, `Flappy Bird 12`:

- add mouse controls to move between states

  The structure mirrors that of the keyboard so that you have a table, `love.mouse.button_pressed`, to keep track of which button was pressed in the previous frame, and `love.mouse.waspressed()`, a function which receives a button and returns whether or not the button is true in the original table

- in the play state, have the bird jump on mouse press regardless of the mouse coordinates

- ensure that the pipes do not exceed the window's top and bottom edges

- spawn a pipe pair immediately instead of waiting for the first iteration of the interval
