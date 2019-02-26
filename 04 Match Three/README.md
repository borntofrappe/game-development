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

## Project Structure

The game isn't developed in the same manner as Pong, Flappy Bird or Breakout. Instead of developing the game continuously, one step at a time, the video proceeds by introducing the different concepts behind the game, such as the timer or tweening, and only later develop the actual game. In light of this change, the organization of the repository is also modified: you find the concepts into their own folder and later you find the game with the same naming convention used for the first three games (you will therefore find folders labeled 'Timer', 'Tweening', and only later 'Match Three 0', 'Match Three 1' and so forth and so on).

Small update: I decided to label the folders describing the founding concept with the **Prep** prefix. Following up from the code developed in each one of them, the game is developed in increments following the mentioned convention.
