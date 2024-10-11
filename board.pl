:-module(board, [create_empty_board/4, square/4, can_play_in_column/1, can_play_somewhere_on_board/1, column_is_empty/1, board_is_empty/1, board_is_full/1, apply_move/4, available_moves/2, get_board_center/2]).

:-use_module('list_processing.pl').

blank_mark('e').

%---------------------------------
% Board creation
%---------------------------------

% Predicate to create an empty board (filled with EmptyMark) given the number of columns and lines
create_empty_board(NumCols, NumLines, EmptyMark, Board) :-
    findall(Column, (between(1, NumCols, _), create_column(NumLines, EmptyMark, Column)), Board).

% Predicate to create a single empty column
create_column(NumLines, EmptyMark, Column) :-
    length(Column, NumLines),
    maplist(=(EmptyMark), Column).


%---------------------------------
% Access element at position (C,L)
%---------------------------------
square(B, C_index, L_index, M):- % renvoie l element present a la colonne C_index et ligne L_index
  get_item(B, C_index, C),
  get_item(C, L_index, M).


%---------------------------------------
% Can we play in a column or on the board?
%---------------------------------------

% Checks if a move can be made at the top of the column.
can_play_in_column([X|_]):-
    blank_mark(X).

% Checks further down the column if a move can be made.
can_play_in_column([_|RestColumn]):-
    can_play_in_column(RestColumn).

% Checks if a move can be made in at least one column of the board.
can_play_somewhere_on_board([Column|_]):-
    can_play_in_column(Column).

% Checks the rest of the board columns if a move can be made.
can_play_somewhere_on_board([_|RestBoard]):-
    can_play_somewhere_on_board(RestBoard).


% can_play_at_index(Board, index).
% TODO

%---------------------------------------
% Is the column or board empty or full?
%---------------------------------------

% Checks if a column is completely empty.
column_is_empty([]).

column_is_empty([X|RestColumn]):-
    blank_mark(X), 
    column_is_empty(RestColumn).

% Checks if the entire board is empty.
board_is_empty([]).

board_is_empty([Column|BoardRest]):-
    column_is_empty(Column), 
    board_is_empty(BoardRest).

column_is_full([X]) :-
    not(blank_mark(X)), !.

column_is_full([X|Rest]) :-
    not(blank_mark(X)),
    column_is_full(Rest).

board_is_full([Column]) :-
    column_is_full(Column), !.

board_is_full([Column|RestBoard]) :-
    column_is_full(Column),
    board_is_full(RestBoard).



%---------------------------------------
% Applying a move
%---------------------------------------

% Plays a mark at the topmost available cell in a column.
play_mark_in_column(Mark, [X|RestColumn], [Mark|RestColumn]) :-
    blank_mark(X).

% If the current cell is occupied, continues down the column.
play_mark_in_column(Mark, [X|RestColumn], [X|NewRestColumn]) :-
    \+ blank_mark(X),
    play_mark_in_column(Mark, RestColumn, NewRestColumn).


% Makes a move in the specified column on the board.
apply_move(Board, NumColumn, Mark, NewBoard):-
    get_item(Board, NumColumn, Column),
    can_play_in_column(Column),
    play_mark_in_column(Mark, Column, NewColumn),
    set_item(Board, NumColumn, NewColumn, NewBoard).

%---------------------------------------
% Getting available moves
%---------------------------------------

% Base case: Stops once we have checked all columns.
available_moves(_, [], N, MaxN) :- 
    N > MaxN, !.

% If move can be made in column N, adds it to the list.
available_moves(Board, [N|Rest], N, MaxN) :-
    get_item(Board, N, Column),
    can_play_in_column(Column),
    N1 is N + 1,
    available_moves(Board, Rest, N1, MaxN).

% If column N is full, checks the next column.
available_moves(Board, Moves, N, MaxN) :-
    get_item(Board, N, Column),
    \+ can_play_in_column(Column),
    N1 is N + 1,
    available_moves(Board, Moves, N1, MaxN).

% Entry point: Retrieves the list of columns where moves can be made.
available_moves(Board, Moves) :-
    length(Board, MaxN),
    available_moves(Board, Moves, 1, MaxN).  % Start from column 1


%---------------------------------------
% Get board center
%---------------------------------------

% Returns the center column if the number of columns is odd. 
% Else, randomly chooses between the two center columns.

get_board_center(Board, CenterColumnIndex):-
    length(Board, NumColumns),
    (   odd(NumColumns) 
    ->  CenterColumnIndex is (NumColumns + 1) // 2
    ;   Middle1 is NumColumns // 2,
        Middle2 is Middle1 + 1,
        random_member(CenterColumnIndex, [Middle1, Middle2])
    ).

% Predicate to check if a number is odd
odd(N) :- N mod 2 =:= 1.
