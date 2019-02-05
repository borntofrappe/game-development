# Pong with Lua

## Preface

The [first video](https://youtu.be/jZqYXSmgDuM) in the playlist behind this repository tackles the lua programming language and the love2d environment with the video game Pong in mind.

The project is structred as follows:

- in this README you find general information on the Pong repository and introductory remarks about Lua and Love2D;

- in the Libraries folder you find the files referenced in each sub-project, to avoid repetition;

- in each separate folder Pong 0, Pong 1 (and so forth and so on) you find an additional README, detailing the lessons learned from the codebase and the actual video. You also find the snippets, the working code for each sub-section, documented as neatly as possible.

## Getting Started

- [Installing Love2D](#installing-love2d)

- [Running a silly program](#running-a-silly-program)

Snippets:

- main.lua

### Installing Love2D

It is first necessary to install the Love2D framework. From [the homepage itself](https://love2d.org/) the installer provides the quickest solution. Once installed, the main reference is [the wiki](https://love2d.org/wiki/Main_Page).

### Running a silly program

In the [getting started](https://love2d.org/wiki/Getting_Started) section, the wiki provides a few ways to run a love2d program. For proof of concept, here's how to print `Hello world` through the framework.

1. create a `main.lua` file. I placed this file in a `Pong` folder, just for context.

1. write the following three lines of code:

   ```lua
   function love.draw()
     love.graphics.print('Hello world', 400, 300)
   end
   ```

   I am not acquainted with the Lua programming language, but it seems to be based on indentation and it seems to shy away from semicolons. VSCode was nice enough to indent each line without need to adjust the line position.

1. drag the folder containing the `main.lua` file on top of the `Love2D` program, or a shortcut to said program. Personally, I created a shortcut and placed it in the root folder, right beside the `Pong` folder.

   This should fire up Love2D and present the hello world string. The two integers seem to be referencing the coordinates of the string. The coordinate system, as explained in the video, works like the coordinate system in SVG land: from the top left corner.

## Introductory concepts

Index:

- [Game Loop](#game-loop)

- [2D Coordinate System](#2d-coordinate-system)

### Game Loop

Infinite loop which continuously:

- listens for input

- updates the game according to the input

- renders whatever has updated <!-- react?! -->.

### 2D Coordinate System

Exactly like with SVG syntax, the coordinate system works top to bottom, left to right.

If you think of a 1x1 square, the following representation highlights this coordinate system

```text
(0, 0) (1, 0)
(0, 1) (1, 1)
```
