# [Assignment](https://docs.cs50.net/ocw/games/assignments/4/assignment4.html)

## Solid ground

> Program it such that when the player is dropped into the level, they’re always done so above solid ground

## Key and lock block

> In `LevelMaker.lua`, generate a random-colored key and lock block (taken from `keys_and_locks.png` in the `graphics` folder of the distro). The key should unlock the block when the player collides with it, triggering the block to disappear

## Goal post

> Once the lock has disappeared, trigger a goal post to spawn at the end of the level. Goal posts can be found in `flags.png`; feel free to use whichever one you’d like! Note that the flag and the pole are separated, so you’ll have to spawn a `GameObject` for each segment of the flag and one for the flag itself.

## New level

> When the player touches this goal post, we should regenerate the level, spawn the player at the beginning of it again (this can all be done via just reloading `PlayState`), and make it a little longer than it was before. You’ll need to introduce `params` to the `PlayState:enter` function that keeps track of the current level and persists the player’s score for this to work properly.
