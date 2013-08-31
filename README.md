Stanford iTunesU Winter 2013 - Coding Together, Developing-iPhone-and-iPad-Apps
===============================================================================

####Overview - Homework Assignment #1:

1. Replicate the latest version of the code in lecture.

2. Add 4 cards to the game (for a total of 16).

3. Add a text label somewhere which desribes the results of the last flip. 
    Examples:
    “Matched J♥ & J♠ for 4 points” or “6♦ and J♣ don’t match! 2 point penalty!” and
    simply “Flipped up 8♦” if there is no match or mismatch.
    
4. Add a button called “Deal” which will re-deal all of the cards (i.e. start a new game).
   It should reset the score (and anything else in the UI that makes sense). In a real
   game, we’d probably want to ask the user if he or she is “sure” before aborting the
   game in process to re-deal, but for this assignment, you can assume the user always
   knows what he or she is doing when they hit this button.
   
5. Drag out a switch (UISwitch) or a segmented control (UISegmentedControl) into your
   View somewhere which controls whether the game matches two cards at a time or
   three cards at a time (i.e. it sets “2-card-match mode” vs. “3-card-match mode”).
   Give the user appropriate points depending on how difficult the match is to
   accomplish.

6. Disable the game play mode control (i.e. the UISwitch or UISegmentedControl from
   Required Task #5) when flipping starts and re-enable it when a re-deal happens (i.e.
   the Deal button is pressed).
   
7. Make the back of the card be an image (UIImage) rather than an Apple logo.

Extra Credit:

Add a UISlider to your UI which travels through the history of the currently-beingplayed
game’s flips and display it to the user (moving the slider will modify the contents of
the text label you created for Required Task #3 to show its state over the course of the
game). When you are displaying past flips, you probably want the text label to be grayed
out (with alpha) or something so it’s clear that it’s “the past.” Also, you probably don’t
want that text label from Required Task #3 to ever be blank (except at the very start of
the game, of course). And every time a new flip happens, you probably want to “jump to
the present” in the slider. Implementing this extra credit item will require you to
familiarize yourself with UISlider’s API and to add a data structure to your Controller to
keep track of the history. It can be implemented in fewer than a dozen lines of code.
  
####Solutions: (see screenshots below)

1. Reproduced the latest version of Matchismo that was done in lecture. This was a continuation of the first lecture that can be seen in Homework #0.

2. Added 4 cards(UIButtons) to the game via Interface builder then linked up those to the Outlet Collection.

3. Added the text label which described the results of the last flip. I used NSStringWithFormat to customize the printout of the last flip which was really needed for the 3 card game mode. 

4. Added the "Deal" button that re-deals all the cards and wrote all the code to take care of all the events that need to take place when dealing a new hand (resetting the score, etc).

5. Created a UISegementedControl to support the 2-card and 3-card match mode. Updated the CardMatchingGame model file accordingly. When re-dealing a game I automatically set it to a 2-card game by default.

6. Disabled the game play mode / Enabled game play mode as required.

7. Used an image off of the interwebs for the back of the card instead of the apple logo.

Extra Credit:

Adding the UISlider that would keep up with the flip history. I use the same text label from step #3 and just change the alpha value of the label to 0.3. 


Additional Work - Above and Beyond the Extra Credit. (see comments in the code and screenshots below).

1. Added code to the let the player know when there are no more matches possible. 

  1a. Whenever the player gets a successful match, filter out the number of cards that are playable using a                predicate.
  
  1b. Using the cards from 1a.,  check to see if there are suits or ranks available to play based on the current game
      mode. Write separate predicates to filter out the suits and ranks. Example: If we are in a 3-card game mode          then check to see if there are 3 or more of one suit. If this fails, then check to see if there are 3 or more        of a certain rank (A, 2, 3...K).
      
  1c. If there are not enough suits or ranks then we set a flag in the card matching game model that the game is over
      . The view controller checks after each flip to see if the game is now over and if so, initializing and shows 
      a UIAlertView with an "OK" button to let the player know that there are no more matches possible and that the        game is over.
      
  1d. After the player taps on the "OK" button on the alertView, the alertView dismisses and the remaining cards that       were still playable (even though no more matches were possible) are flipped face up, set to unplayable with an 
      alpha value of 0.3 and a red border is drawn around each of cards. This will let the player easily see and           distinguish between the cards that were already matched and the cards that were leftover. 


####Environment:

iPhone 6.1 Simulator

####Screenshots:

####2-card game

![screenshot](http://geeksweep.files.wordpress.com/2013/08/homework1_1.png)

Selecting the first card - UISlider updates, SegmentedControl Disabled. 
![screenshot](http://geeksweep.files.wordpress.com/2013/08/homework1_2.png)

Got a match!
![screenshot](http://geeksweep.files.wordpress.com/2013/08/homework1_3.png)

Using the UISlider to go "back in time" to look at the last plays in the game.
![screenshot](http://geeksweep.files.wordpress.com/2013/08/homework1_4.png)

UIAlertView lets the player know that there are no more matches possible.
![screenshot](http://geeksweep.files.wordpress.com/2013/08/homework1_5.png

The remaining cards that were left on the board are now face up and are outlined with a red border.
![screenshot](http://geeksweep.files.wordpress.com/2013/08/homework1_6.png)

####3-card game - Lucky with first match right off the bat.

![screenshot](http://geeksweep.files.wordpress.com/2013/08/homework1_7.png)

Now getting matches in spades(no pun intended).
![screenshot](http://geeksweep.files.wordpress.com/2013/08/homework1_8.png)

Using the UISlider to go "back in time" once again.
![screenshot](http://geeksweep.files.wordpress.com/2013/08/homework1_9.png)

UIAlertView once again lets the player know that the game is over with no more matches possible.
![screenshot](http://geeksweep.files.wordpress.com/2013/08/homework1_10.png)

The remaining cards that were left on the board are now face up and are outlined with a red border. 
![screenshot](http://geeksweep.files.wordpress.com/2013/08/homework1_11.png)



