# Game Development

The goal of this repo is two-fold:

- go through the games in the [CS50's Intro to Game Development](https://www.youtube.com/playlist?list=PLWKjhJtqVAbluXJKKbCIb4xd7fcRkpzoz) recreating the demos and completing the assignment

  Here's a reference table charting the progress in this direction.

  | Video               | Final | Assignment |
  | ------------------- | :---: | :--------: |
  | Pong                |   x   |     x      |
  | Flappy Bird         |   x   |     x      |
  | Breakout            |   x   |     x      |
  | Match 3             |   x   |     x      |
  | Super Mario Bros    |   x   |     x      |
  | The Legend of Zelda |       |            |
  | Angry Birds         |   x   |     x      |
  | Pokemon             |   x   |     x      |
  | Helicopter          |       |            |
  | Dreadhall           |       |            |
  | Portal              |       |            |

- solidify the lessons learned with additonal games. These are developed in the `Games` folder, taking inspiration from previous titles and actual games

  Here's a reference table listing the games in the order in which they are developed.

  | Game             | Brief                                                            |
  | ---------------- | ---------------------------------------------------------------- |
  | 2 Player Pong    | Pong with a mobile interface and mouse input                     |
  | Bouncing Android | Flappy Bird inspired by the Lollipop OS                          |
  | Space Invaders   | Space invaders inspired by title on the Game Boy Color           |
  | Whirly Bird      | Doodle jump inspired by Google Play pre-installed games          |
  | Asteroids        | Asteroids with shapes from `love.graphics`                       |
  | Snake            | Snake with blocks and step animation                             |
  | Picross          | Picross levels with keyboard and mouse input                     |
  | Tetris           | Tetris leveraging Lua's tables                                   |
  | Box2D Demos      | A series of physics-based experiments                            |
  | Minesweeper      | Minesweeper with mouse input                                     |
  | Alien Jump       | An endless scroller inspired by Chrome's offline game            |
  | Game of Life     | A fullscreen simulation of Conway's game of life                 |
  | Lunar Lander     | Lunar Lander with Box2D and `love.math.noise`                    |
  | Side Pocket      | Billiard with rounded rectangles and Box2D                       |
  | Petri Dish       | Time events and `love.math.noise` to animate irregular particles |
  | Bang Bang        | Fire a cannonball to destroy a target behind a hill              |

## How to run a game

Provided you have installed love2D, launch the games from the command line with the following instruction:

```bash
"C:\Program Files\LOVE\love.exe" "C:\Users\Gabriele\Desktop\Publish\game-development\08 Pokemon\Pokemon 10"
```

The first string describes the location of the executable behind love2D, and the second string details the folder with the customary "main.lua" file.

You can also drag and drop the folder on top of the file describing the executable itself.

## Project structure

### N°n Game

In the numbered folders, I follow the course to recreate the presented games. Following the lecturer's example, the games are developed one feature at a time, and are explained by a dedicated markdown file.

Each game also includes at least two additional folders:

1. `Game — Final`

2. `Game — Assignment`

The first one describes the state of the game at the end of each video lecture, while the second one adds the features requested in the lecture's assignment.

### Games

In the `Games` folder, the games are also developed in increments, but do not mirror the same structure of the titles proposed in the course. Each `README.md` file describes the most salient features, but the folders already contain the files necessary to run the titles in its final state.

## Resources

- [GD50 playlist](https://www.youtube.com/playlist?list=PLWKjhJtqVAbluXJKKbCIb4xd7fcRkpzoz)

- [Lua](https://www.lua.org) and [its reference manual](https://www.lua.org/manual/5.4/)

- [Love2D](https://love2d.org/) and [its wiki page](https://love2d.org/wiki/Main_Page)
