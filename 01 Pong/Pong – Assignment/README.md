## Assignment

With the [AI Update](https://cs50.harvard.edu/games/2019/spring/assignments/0/), the final project is expanded to have one paddle moving on its own. I decided to have the right paddle move according to user input, and I implemented the feature as follows:

- in the `update(dt)` function check for the horizontal coordinate of the ball

- once the ball is closer than an arbitrary threshold, compute where the ball will land. This is done by calculating the time it takes for the ball to go to the left edge as well as the vertical space covered during said time.

- move the paddle with the constant speed until it reaches the designated point

This solution is rather nifty, as it allows for some exchange between paddles, but definitely allows the player to win. The speed is the same for both paddles, and this means that if the vertical distance is greater than the space the computer can make up, the player will score.

## Code

Ultimately, the approach is a tad more complex than described above, but it boils down to use basic physics (speed = space / time). Most importatly, it boils down to compute the exact vertical coordinate of where the ball will end only as the ball goes past the half of the screen. **Or** when the ball hits the top or bottom edge. Indeed, as it is computed, the final coordinate doesn't consider a possible bounce. I decided to leave in this detail to make for a less AI-looking approach, as the paddle moves toward the ball, before adjusting its coordinate appropriately.

One small note: I also updated the description of the serving of winner player, as to fittingly describe whether the serving/winning side is the computer or the player.

Finally, I decided to update the code as to allow for increasing difficulty and also variable behavior on the computer side. I added `startingX` to describe where the AI will consider the ball, instead of always using the half of the screen's width. `startingX` begins randomly, between the center and three fourths of the screen, and is updated again at random whenever the ball hits the paddle of the player. It is a minor addition, which could be expanded to consider the passing of time, or the speed of the ball, but already a change which quite improves the gameplay.
