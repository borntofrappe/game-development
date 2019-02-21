# Match Three

For the fourth installment in the introduction to game development @cs50, the game is **Match Three**. The dynamic behind the game may appear basic in nature (clear blocks when three of the same color as side by side), but the project promises plenty of challenges.

## Topics

The lecture promises to delve in the following topics:

- anonymous functions, essential part of the language;

- tweening, interpolating between two values, for instance to animate objects;

- timers, using a library to more efficiently tackle time-based events;

- clearing matches, concerning the actual dynamic of the game;

- procedural grids, regarding the creation of levels;

- sprite art and palettes, creating the actual assets.

## Goal

The game is structured as follows:

- title screen, introducing the game through an animated visual;

- level screen, transitioning the game from the title to the play screen, again with an animated visual;

- play screen, where the game actually unfolds.

The idea in the play screen is to have a timer and a goal. Clear the goal before the timer reache zero and you are prompted with a new level. Let the timer hit zero and the game is over.
