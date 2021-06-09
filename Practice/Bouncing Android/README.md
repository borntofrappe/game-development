# Bouncing Android

The goal of this project is to create the game inspired by flappy bird and included as an easter egg in the lollipop version of the android operating system.

Consider this a follow up of `01 Flappy Bird`, to rehearse procedural generation and state machines in particular.

## Resources

In the `res` folder you find:

- `lib/class.lua` to work with object oriented programming

- `fonts/font.ttf` to include the font [Lato](https://fonts.google.com/specimen/Lato) in its bold variant

- several images in the `graphics` folder to provide the background, player and otherwise world assets. Take notice of the size of the images, especially that of the background, which implies a window size of `400` by `500`

## StateMachine

- title: overlapping, colorful circles, press the center for an arbitrary amount of time before entering the game

- waiting: scroll, no android

- playing: pop android into existence, introduce lollipops

- gameover: stop scroll and movement altogether
