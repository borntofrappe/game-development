# Pong with Lua

The [first video](https://youtu.be/jZqYXSmgDuM) in the playlist behind this repository tackles the lua programming language and the love2d environment with the video game Pong in mind.

The project is organized as follows:

- in this `README.md` you find introductory remarks about Lua and Love2D;

- in the `Resources` folder you find the libraries, fonts and sound files used in each iteration, as to avoid repeating them in each update.

- in each separate folder, `Pong 0`, `Pong 1`, and so forth and so on, you find the game developed one feature at a time. Following the video itself, you find dedicated `README.md` files, detailing the change in the codebase as well as the lessons learned throughout the development, and you find also `.lua` files, with the actual working code documented as neatly as possible.

**Index**

- [Getting Started](#getting-started)

  - [Installing Love2D](#installing-love2d)

  - [Running a silly program](#running-a-silly-program)

  - [Game Loop](#game-loop)

  - [2D Coordinate System](#2d-coordinate-system)

- [Update](#update)

  - [Pong 13](#pong-13)

  - [Assignment](#assignment)

## Getting Started

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

## Update

### Pong 13

As mentioned in the folder, the video completes itself on Update 12. That being said, I chose to include Update 13 as a way to save for posterity the final, complete project. The files which are described in Pong 13 allow to play a full-fledged game of Pong in which both paddles are moved following user input.

### Assignment

Introduced as the [AI Update](https://cs50.harvard.edu/games/2019/spring/assignments/0/), the final project as created throughout the video is expanded to have one paddle moving on its own. I decided to have the right paddle move followin user input, and I implemented the feature as follows:

- in the `update(dt)` function I check for the horizontal coordinate of the ball;

- once the ball is in the half of the screen where the paddle of the computer resides, compute where the ball will land. This is done by calculating the time it takes for the ball to go to the left edge as well as the vertical space covered during said time.

- move the paddle with the constant speed until it reaches the designated point.

This solution is rather nifty, as it allows for some exchange between paddles, but definitely allows the player to win. The speed is the same for both paddles, and this means that if the vertical distance is greater than the space the computer can make up, the player will score.

The approach is a tad more complex than described above, but it boils down to use very simple math (speed = space / time). Most importatly, it boils down to compute the exact vertical coordinate of where the ball will end only as the ball goes past the half of the screen. **Or** when the ball hits the top or bottom edge. Indeed, as it is computed, the final coordinate doesn't consider a possible bounce. I decided to leave in this detail to make for a less AI-looking approach, as the paddle moves toward the ball, before adjusting its coordinate appropriately.

One last note: I also updated the description of the serving of winner player, as to fittingly describe whether the serving/winning side is the computer or the player.
