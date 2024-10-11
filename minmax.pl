:-module(minmax, [minimax/5]).
:-use_module('win.pl').
:-use_module('utility_better.pl').


maximizing('x').        %%% the player playing x is always trying to maximize the utility of the board position
minimizing('o').        %%% the player playing o is always trying to minimize the utility of the board position


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% IA_MINI_MAX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The minimax algorithm always assumes an optimal opponent.



% D is the depth of the search tree, it must be maximazed to assure the speed of the IA
% M is the mark of the IA
% S is the move returned by the function
% U is the utility value returned by the function

% if the board is empty, the first move is at the center and the utility value is null

max_depth(5).



% Because a checker in the center column allows you to make a Connect 4 in all possible directions, this is the best possible first move.
minimax(D,B,M,S,U) :-  
    board_is_empty(B),
    % nl,
    % nl,
    write('plateau vide'),
    blank_mark(E),
    get_board_center(B,S),
    !
    .


% if the board isnt empty we begin to build the search tree
minimax(D,B,M,S,U) :- 
    % nl,
    % nl,
    D2 is D + 1,
    max_depth(DMax),
    D2 \== DMax,
    available_moves(B,L),  % get the list of available moves
    !,
    best(D2,B,M,L,S,U), % recursively determine the best available move
    !
    .

% if there are no more available moves, 
% then the minimax value is the utility of the given board position

minimax(D,B,M,S,U) :-
    % nl,
    % nl,
    utility(B,U)      
    .

%.......................................
% best
%.......................................
% determines the best move in a given list of moves by recursively calling minimax
%
% if there is only one move left in the list...

best(D,B,M,[S1],S,U) :-
    apply_move(B,S1,M,B2),       % apply that move to the board,
    inverse_mark(M,M2),   % change for the opponent mark
    !,  
    minimax(D,B2,M2,_S,U),  % then recursively search for the utility value of that move.
    S = S1, !,
    output_value(D,S,U),
    !
    .

% if there is more than one move in the list...

best(D,B,M,[S1|T],S,U) :-
    apply_move(B,S1,M,B2),    % apply the first move (in the list) to the board
    inverse_mark(M,M2), 
    !,
    minimax(D,B2,M2,_S,U1),  % recursively search for the utility value of that move
    best(D,B,M,T,S2,U2),     % determine the best move of the remaining moves
    output_value(D,S1,U1),      
    better(D,M,S1,U1,S2,U2,S,U)  % and choose the better of the two moves (based on their respective utility values)
    .

%.......................................
% better
%.......................................
% returns the better of two moves based on their respective utility values.
%
% if both moves have the same utility value, then one is chosen at random.

better(D,M,S1,U1,S2,U2,S,U) :-
    maximizing(M),       % if the player is maximizing
    U1 > U2,              % then greater is better.
    S = S1,
    U = U1,
    !
    .

better(D,M,S1,U1,S2,U2,S,U) :-
    minimizing(M),        % if the player is minimizing,
    U1 < U2,               % then lesser is better.
    S = S1,
    U = U1, 
    !
    .

better(D,M,S1,U1,S2,U2,S,U) :-
    U1 == U2,               % if moves have equal utility,
    random(1, 8,R),  % then pick one of them at random
    better2(D,R,M,S1,U1,S2,U2,S,U),    
    !
    .

better(D,M,S1,U1,S2,U2,S,U) :- 
% otherwise, second move is better
    S = S2,
    U = U2,
    !
    .

%.......................................
% better2
%.......................................
% randomly selects two squares of the same utility value given a single probability
%

better2(D,R,M,S1,U1,S2,U2,S,U) :-
    R < 6,
    S = S1,
    U = U1, 
    !
    .

better2(D,R,M,S1,U1,S2,U2,S,U) :-
    S = S2,
    U = U2,
    !
    .


%.......................................
% utility
%.......................................
% determines the value of a given board position
%

utility(B,U) :-
    win(B,'x'),
    U = 1, 
    !
    .

utility(B,U) :-
    win(B,'o'),
    U = (-1), 
    !
    .

utility(B,U) :-
    U = 0
    .








%.......................................
% debug output_value
%.......................................
% determines the value of a given board position
%

output_value(D,C,U) :-
    D == 1,
    nl,
    write('Column '),
    write(C),
    write(', utility: '),
    write(U), !
    .

output_value(D,Column,U) :- 
    true
    .
