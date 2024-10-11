:-module(win, [win/1, win/2]).
:-use_module('transpose.pl').
:-use_module('list_processing.pl').
:-use_module('matrix_processing.pl').

empty_mark('e').

win(Board) :-
  win(Board, _).

win(Board, WinnerMark) :-
(win_for_mark(Board, 'x') -> WinnerMark = 'x'; 
 win_for_mark(Board, 'o') -> WinnerMark = 'o'; 
 fail).


win_for_mark(B, M) :- 
    not(blank_mark(M)),
    win_vertical(B, M).

win_for_mark(B, M) :-
    win_horizontal(B, M).

win_for_mark(B, M) :-
  win_diagonal(B, M).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Verification des colonnes

win_vertical([Column|_], Mark) :-
  consecutive_elements(Column, Mark, 4).

win_vertical([Column|RestBoard], Mark) :-
  not(consecutive_elements(Column, Mark, 4)),
  win_vertical(RestBoard, Mark).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Verification des lignes

win_horizontal(B,M) :-
  not(blank_mark(M)),
  transpose(B, TransposedB),
  win_vertical(TransposedB, M).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Verification des diagonales

win_diagonal(B,M):-
  all_diagonals(B, Out),
  win_vertical(Out, M).

