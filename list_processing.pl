%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LIST PROCESSING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:- module(list_processing, [set_item/4, get_item/3, is_sublist/2,consecutive_elements/3]).

%.......................................
% set_item
%.......................................
% Given a list L, replace the item at position N with V
% return the new list in list L2
%

set_item(L, N, V, L2) :-
    set_item2(L, N, V, 1, L2)
    .

set_item2( [], N, _, _, L2) :- 
    N == -1, 
    L2 = []
    .

set_item2( [_|T1], N, V, A, [V|T2] ) :- 
    A = N,
    A1 is N + 1,
    set_item2( T1, -1, V, A1, T2 )
    .

set_item2( [H|T1], N, V, A, [H|T2] ) :- 
    A1 is A + 1, 
    set_item2( T1, N, V, A1, T2 )
    .

%.......................................
% get_item
%.......................................
% Given a list L, retrieve the item at position N and return it as value V
%

get_item(L, N, V) :-
    get_item2(L, N, 1, V)
    .

get_item2( [], _N, _A, V) :- 
    V = [], !,
    fail
    .

get_item2( [H|_T], N, A, V) :- 
    A = N,
    V = H
    .

get_item2( [_|T], N, A, V) :-
    A1 is A + 1,
    get_item2( T, N, A1, V)
    .


%.......................................
% is_sublist
%.......................................
% TRUE si SubList est une sous-liste de List

is_sublist(SubList, List) :-
    append(_, SubListWithRest, List),
    append(SubList, _, SubListWithRest).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Elements consecutifs dans une liste 1D

% Verifie si List contient au moins N elements consecutifs X.
consecutive_elements(List, X, N) :-
    consecutive_elements(List, X, N, 0). % on appelle la regle avec un compteur a 0

% Cas de base : si N elements consecutifs de X ont ete trouves, on reussit
consecutive_elements(_, _, N, N) :- !.

% Parcourt la liste et compte les elements consecutifs de X
consecutive_elements([X | Rest], X, N, CurrentCount) :-
    NextCount is CurrentCount + 1,
    consecutive_elements(Rest, X, N, NextCount).

% Si on rencontre un element different de X, on reinitialise le compteur.
consecutive_elements([Y | Rest], X, N, _) :-
    X \= Y,
    consecutive_elements(Rest, X, N, 0).
