# Match Three 7 - Transitions

Before actually incorporating the board and detailing the architecture of the game, in terms of levels and scores, this update sets out to detail the transition between `StartState` and `PlayState`. This making use of the concepts introduced in the **time based events** and **tween between values** folders, not to mention the notion of chaining introduced in **chain functions**.

## The Goal

The transition can be described as follows:

- the player selects 'Start';

- the screen fades to white;

- the screen fades from white to show the board;

- a stripe detailing the current level is shown appearing from the top, stopping midway through and disappearing at the bottom;

- the panel showing the level, score, goal and timer is introduced;

- the player is allowed to interact with the board, effectively playing the game.

The transition explained in the fourth point repeats itself once a new level is reached, but this update is tasked to implement the fade-out, fade-in transition exclusively between `StartState` and `PlayState`. The level state describing how the player has reached a certain goal, will be the subject of a future update.

## Overall Design

Before diving into the transition between states I decided to detail a little better the gameover state, as to include an overlay similar to the one introduced in the play state. I also updated the start state insofar as it introduces a dark layer before every graphic, to effectively darken the underlying background. These might be minor stylistic choices, but they do add up. Moreover, they are in line with the advice of the lecturer given toward the end of the video: _use a limited number of colors_. The consistency across states really helps delivering a good experience.

<!-- ## StartState -->

<!-- ## PlayState -->
