:-module(random_ia, [random_valid_move/2]).

:-use_module('board.pl').


%.......................................
% random_valid_move
%.......................................
% Obtient un coup aléatoire valide
%
random_valid_move(Board, Move) :-
  length(Board, NumColumns),
  M is NumColumns +1,
    random(1, M, Move),
    get_item(Board, Move, Column),
    can_play_in_column(Column), 
    !
    .

% Si le coup nest pas valide, réessayez
%
random_valid_move(Board, Move) :-
    random_valid_move(Board, Move)
    . 
