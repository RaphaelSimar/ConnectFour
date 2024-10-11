%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ALIA – 4IF - Approche Logique de l Intelligence Artificielle
%%% CASS RAPH AYA LARA SYSY CLOCLO SAMSAM
%%% Due 12 Nov. 2023
%%% Inspired from : http://www.robertpinchbeck.com/college/work/prolog/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% A Prolog Implementation of Connect 4
%%% using the minimax strategy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*

If single letters are used, they represent :

L - a list
N - a number, position, index, or counter
V - a value (usually a string)
A - an accumulator
H - the head of a list
T - the tail of a list

P - a player number (1 or 2)
B - the board (typically a 7x6 matrix)
    each "cell" on the board can contain one of 3 values: x, o, or e (for empty)
S - the number of a column on the board (1 - 7)
M - a mark in a cell (x or o)
E - the mark used to represent an empty cell ('e').
U - the utility value of a board position
R - a random number
D - the depth of the minimax search tree (for outputting utility values, and for debugging)

Variables with a numeric suffix represent a variable based on another variable.
(e.g. B2 is a new board position based on B)

For predicates, the last variable is usually the "return" value.
(e.g. opponent_mark(P,M), returns the opposing mark in variable M)

There are only two assertions that are used in this implementation:

asserta( board(B) ) - the current board 
asserta( player(P, Type) ) - indicates which players are human/computer.

*/

:-use_module('matrix_processing.pl').
:-use_module('list_processing.pl').
:-use_module('board.pl').
:-use_module('print_board.pl').
:-use_module('transpose.pl').
:-use_module('win.pl').
:-use_module('random_ia.pl').
:-use_module('minmax.pl').
:-use_module('minmax_better.pl').
:-use_module('game_over.pl').
:-use_module('utility_better.pl').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     FACTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

next_player(1, 2).      %%% determines the next player after the given player
next_player(2, 1).

inverse_mark('x', 'o'). %%% determines the opposite of the given mark
inverse_mark('o', 'x').

player_mark(1, 'x').    %%% the mark for the given player
player_mark(2, 'o').    

opponent_mark(1, 'o').  %%% shorthand for the inverse mark of the given player
opponent_mark(2, 'x').

blank_mark('e').        %%% the mark used in an empty square




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     MAIN PROGRAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

run :-
    hello,          %%% Display welcome message, initialize game

    play(1),        %%% Play the game starting with player 1

    goodbye         %%% Display end of game message
    .

run :-
    goodbye
    .

hello :-
    initialize,
    nl,
    nl,
    nl,
    write('Welcome in our awesome game POWER 4 !!!!'),
    read_players,
    output_players
    .


initialize :-
    % set_random(seed(1)), % Uncomment this line in production.
    blank_mark(E),
    create_empty_board(7,6, E, Board),
    asserta(board(Board))
    .

play(P) :-
    board(B), !,
    print_board(B), !,
    not(game_over(B)), !,
    request_and_apply_move(P, B), !,
    next_player(P, P2), !,
    play(P2), !
    .

goodbye :-
    board(B),
    print_board(B),
    nl,
    nl,
    write('Game over: '),
    output_winner(B,M),
    retract(board(_)),
    retract(player(_,_)),
    read_play_again(V), !,
    (V == 'Y' ; V == 'y'), 
    !,
    run
    .

%%%%%%%%%%% gestion de fin du jeu %%%%%%%%%%%
read_play_again(V) :-
    nl,
    nl,
    write('Play again (Y/N)? '),
    read(V),
    (V == 'y' ; V == 'Y' ; V == 'n' ; V == 'N'), !
    .

read_play_again(V) :-
    nl,
    nl,
    write('Please enter Y or N.'),
    read_play_again(V)
    .

read_players :-
    nl,
    nl,
    write('Number of human players? '),
    read(N),
    set_players(N)
    .
%%%%%%%%%%% gestion du debut du jeu %%%%%%%%%%%
% computerRandom pour IA aléatoire, computer pour Minimax normal, computerBetter pour minimax amélioré
set_players(0) :- 
    asserta( player(1, computer) ),
    asserta( player(2, computerBetter) ), !
    .

set_players(1) :-
    nl,
    write('Is human playing X or O (X moves first)? '),
    read(M),
    human_playing(M), !
    .

set_players(2) :- 
    asserta( player(1, human) ),
    asserta( player(2, human) ), !
    .

set_players(N) :-
    nl,
    write('Please enter 0, 1, or 2.'),
    read_players
    .

%%%%%%%%%%% Human playing handling %%%%%%%%%%%
% Human chooses its mark
human_playing(M) :- 
    (M == 'x' ; M == 'X'),
    asserta( player(1, human) ),
    asserta( player(2, computerBetter) ), !
    .

human_playing(M) :- 
    (M == 'o' ; M == 'O'),
    asserta( player(1, computerBetter) ),
    asserta( player(2, human) ), !
    .

human_playing(M) :-
    nl,
    write('Please enter X or O.'),
    set_players(1)
    .

%.......................................
% request_and_apply_move
%.......................................
% requests next move from human/computer, 
% then applies that move to the given board
%

request_and_apply_move(P, B) :-
    player(P, Type), % Type = Human or Computer
    request_and_apply_move2(Type, P, B, B2),
    retract( board(_) ),
    asserta( board(B2) )
    .

request_and_apply_move2(human, Player, Board, NewBoard) :-
    nl,
    nl,
    write('Player '),
    write(Player),
    write(' move? '),
    read(S),
    player_mark(Player, M),
    apply_move(Board, S, M, NewBoard ), 
    !
    .

request_and_apply_move2(human, Player, Board, NewBoard) :-
    nl,
    nl,
    length(Board, NumColumns),
    format('Please select a numbered column [1-~w].', [NumColumns]),
    request_and_apply_move2(human,Player,Board,NewBoard)
    .

% ---------------- IA RANDOM ---------------- %
request_and_apply_move2(computerRandom, Player, Board, NewBoard) :-
  nl,
  nl,
  write('Computer (random) is « thinking » about next move...'),
  player_mark(Player, M),
  random_valid_move(Board, S),
  apply_move(Board,S,M,NewBoard),
  nl,
  nl,
  write('Computer (random) places '),
  write(M),
  write(' in column '),
  write(S),
  write('.'),
  nl
  .

% ---------------- IA MINMAX ---------------- %
request_and_apply_move2(computer, Player, Board, NewBoard) :-
    nl,
    nl,
    write('Computer (minmax) is thinking about next move...'),
    player_mark(Player, M),
    % random_valid_move(Board, S),
    minimax(0, Board, M, S, U),
    apply_move(Board,S,M,NewBoard),
    nl,
    nl,
    write('Computer (minmax) places '),
    write(M),
    write(' in column '),
    write(S),
    write('.'),
    nl
    .

% ---------------- IA MINIMAX AMELIOREE ---------------- %
request_and_apply_move2(computerBetter, Player, Board, NewBoard) :-
  nl,
  nl,
  write('Computer (minmax better) is thinking about next move...'),
  player_mark(Player, M),
  % random_valid_move(Board, S),
  minimax_better(0, Board, M, S, U),
  apply_move(Board,S,M,NewBoard),
  nl,
  nl,
  write('Computer (minmax better) places '),
  write(M),
  write(' in column '),
  write(S),
  write('.'),
  nl
  .


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% OUTPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

output_players :- 
    nl,
    player(1, V1),
    write('Player 1 is '),   %%% either human or computer
    write(V1),

    nl,
    player(2, V2),
    write('Player 2 is '),   %%% either human or computer
    write(V2),
    nl,
    !
    .

output_winner(B,_) :-
    win(B,x),
    write('X wins.'),
    !
    .

output_winner(B,M) :-
    win(B,o),
    write('O wins.'),
    !
    .

output_winner(_,_) :-
    write('No winner.')
    .

print_board :-
    board(B),
    print_board(B), !
    .



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% End of program
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
