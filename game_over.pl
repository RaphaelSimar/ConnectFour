:-module(game_over, [game_over/1, is_stalemate/1]).

use_module('board.pl'). 
use_module('win.pl'). 

%.......................................
% game_over
%.......................................
% determines when the game is over


% Game over if any player wins
game_over(B):-
  win(B).

% le tableau est plein - personne ne peut jouer 
game_over(B) :- 
    board_is_full(B)
    . 


% Full board with no winner
is_stalemate(B):-
   board_is_full(B),
   not(win(B)).


  