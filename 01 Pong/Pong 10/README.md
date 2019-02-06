# Pong 10

Index:

- [Victory](#victory)

Snippet:

- main.lua

## Victory

With this update the game is set to conclude itself as somebody reaches ten points. This is assured by a conditional statement, directly checking the score of either player, and it is hown with a string boldly and atop the scores themselves.

It is important to note how the presence of a winning condition introduces a new state, for the victorious outcome of the game. The code therefore needs to account for changes to and from this state as well.

My solution <!-- might be updated as I go through the code with fresher eyes -->:

- in the `love.keypressed()` function and when pressing the `enter` key, check for a winning state, and in this instance set the game back to `playing` and reset the points for both paddles. This means that when pressing enter on the winning state, a new game will begin posthaste;

- in the `update()` function and when checking the different game states, account for the winning state by resetting the position of the ball. Additionally and most importantly, check for the score reaching an arbitrary amount, at which point, trigger the winning state.

  ```lua
  -- scoring a point
  if player1.points >= 10 then
    gameState = 'victory'

  if player2.points >= 10 then
    gameState = 'victory'
  ```

  Use also the `servingPlayer` and a newly created variable in `winningPlayer` to identify both sides.

  ```lua
  -- scoring a point
  if player1.points >= 10 then
    gameState = 'victory'
    winningPlayer = 1
    servingPlayer = 2

  if player2.points >= 10 then
    gameState = 'victory'
    winningPlayer = 2
    servingPlayer = 1
  ```

- finally and in the `draw()` function, show the winning side once such a game state is made available. I chose to use the same font used for the score, and therefore included the `printf` function following the `setFont` function describing the score typeface.
