# Game Development

The goal of this repo was to originally go through the games in the [CS50's Intro to Game Development](https://www.youtube.com/playlist?list=PLWKjhJtqVAbluXJKKbCIb4xd7fcRkpzoz), in order to learn game development.

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
| Pokemon             |       |            |
| Helicopter          |       |            |
| Dreadhall           |       |            |
| Portal              |       |            |

With the `Games` folder, however, it has gained a wider purpose to just experiment with game development, creating different experiences from the one proposed in the course.

Here's a short table describing each title with a word or two.

| Game             | Brief                                                        |
| ---------------- | ------------------------------------------------------------ |
| 2 Player Pong    | Pong with a mobile interface and mouse controls              |
| Asteroids        | Asteroids with shapes from `love.graphics`                   |
| Bouncing Android | Flappy Bird inspired by the Lollipop OS                      |
| Snake            | Snake with blocks and step animation                         |
| Space Invaders   | Space invaders inspired by title on the Game Boy Color       |
| Whirly Bird      | Doodle jump concept which comes pre-installed on Google Play |

## How to run a game

Provided you have installed love2D, launch the games from the command line with the following instruction:

```bash
"C:\Program Files\LOVE\love.exe" "C:\Games\Space Invaders"
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
