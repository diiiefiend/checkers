#Console Checkers

##Install
Just need to have the colorize gem installed, using:
* gem install colorize

Then can run in command line using:
* ruby game.rb

##Play
Currently initialized with 2 computer players (in game.rb > Game >  initialize), with their moves printed at the bottom of the board. The computer is capable of recognizing double-jump moves and taking advantage of them with
* players.rb > ComputerPlayer > chain_jump

Includes crowning logic when a piece crosses the board.

Easily enough configured to allow for 1 or 2 human players by changing the code on line 13/14 of game.rb to **HumanPlayer.new**.
