# Match Three 9 - Levels

Originally, this update was meant to introduce a `LevelState`, reached by the `PlayState` when the score surpassed the arbitrary goal. After a bit of experimentation, I decided to however avoid creating another class, and in its place include a transition in the `PlayState` itself.

Here's the flow of the game:

- the player reaches a certain goal;

- the code stops listening for the key presses used to modify the board, to guarantee that nothing will occur during the transition;

- the same stripe detailing the first level is transitioned from the top of the screen, stops midway and then disappear below the screen. This time around detailing the new level;

- the game starts listening again to find and clear matches.

It seems like a trivial transition, but personally I find it advantageous in comparison of adding a new class. Going to another state, and back, would require an adjustment in which either state is presented (every time the `PlayState` is introduced, for instance, it is introduced with a fade-from-white transition). It would also require a way to manage the countdown timer, stopping and resuming its operation. I still haven't figured out how to implement this last feature, but the approach I took seems to be the most efficient way. Just need to adjust the level and goal and highlight the new level with the colored stripe, already overlayed on top of the content.
