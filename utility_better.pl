%.......................................
% utility_better
%.......................................
% determines the value of a given board position
%
:-module(utility_better, [utility_better/2]).
:-use_module('transpose.pl').
:-use_module('matrix_processing.pl').
:-use_module('list_processing.pl').

utility_better(B,U) :-
    win(B,'x'),
    U = 100, 
    !
    .

utility_better(B,U) :-
    win(B,'o'),
    U = (-100), 
    !
    .

utility_better(B,U) :-
    calculate_score(B, U)
    .

%%%%%%%%%% SCORE TOTAL %%%%%%%%%%
% Regle pour calculer le score d un plateau
calculate_score(Board, Score) :-
    calculate_score(Board, 1, XScore), % Calcule le score pour les 'x',
    calculate_score(Board, 2, OScore), % Calcule le score pour les 'o',
    Score is XScore - OScore.      % Soustrait le score des 'o' du score des 'x'.

% Règle pour calculer le score pour un joueur donné
calculate_score(Board, Player, Score) :-
    player_mark(Player, PlayerMark),
    evaluate_columns(Board, PlayerMark, ColumnScore),
    evaluate_rows(Board, PlayerMark, RowScore),
    evaluate_diagonals(Board, PlayerMark, DiagonalScore),
    Score is ColumnScore + RowScore + DiagonalScore.
    % DEBUG (ne pas oublier d enlever le point)
    % format('-------Scores JOUEUR ~w-------~n', [Player]),
    % format('Score Colonnes : ~w~n', [ColumnScore]),
    % format('Score Lignes : ~w~n', [RowScore]),
    % format('Score Diagonales : ~w~n', [DiagonalScore]).


%%%%%%%%%% SCORE COLONNES %%%%%%%%%%
% Évalue les colonnes du plateau
evaluate_columns(Board, PlayerMark, ColumnScore) :-
    evaluate_columns(Board, PlayerMark, 0, ColumnScore).

% Condition de fin
evaluate_columns([], _, ColumnScore, ColumnScore). % Il n y a plus de colonnes

evaluate_columns([Column|Rest], PlayerMark, CurrentScore, ColumnScore) :-
    evaluate_column(Column, PlayerMark, ColumnScoreColumn), % Calcule le score de la colonne courante
    NewScore is CurrentScore + ColumnScoreColumn, % Ajoute le score de la colonne courante au score total
    evaluate_columns(Rest, PlayerMark, NewScore, ColumnScore). % Passe à la colonne suivante

% Evalue UNE colonne
evaluate_column(Column, PlayerMark, ColumnScore) :-
    (
      is_sublist([PlayerMark, PlayerMark, PlayerMark, e], Column), ColumnScore = 5, !;
      is_sublist([e, PlayerMark, PlayerMark, PlayerMark], Column), ColumnScore = 5, !;
      
      is_sublist([PlayerMark, PlayerMark, e, e], Column), ColumnScore = 1, !;
      is_sublist([PlayerMark, PlayerMark, e, PlayerMark], Column), ColumnScore = 1, !;
      is_sublist([e, e, PlayerMark, PlayerMark], Column), ColumnScore = 1, !;
      is_sublist([PlayerMark, e, PlayerMark, PlayerMark], Column), ColumnScore = 1, !;
      is_sublist([e, PlayerMark, PlayerMark, e], Column), ColumnScore = 1, !;
      
      is_sublist([e, e, PlayerMark, e ,e], Column), ColumnScore = 1, !; % Cette disposition permet de "piéger" potentiellement l adversaire et est donc dangereuse
      ColumnScore = 0
    ).

%%%%%%%%%% SCORE LIGNES %%%%%%%%%%
% Évalue les lignes du plateau
evaluate_rows(Board, PlayerMark, RowScore) :-
    transpose(Board, TransposedBoard), % on transpose la matrice
    evaluate_columns(TransposedBoard, PlayerMark, 0, RowScore). % on évalue les colonnes qui correspondent maintenant au lignes


%%%%%%%%%% SCORE DIAGONALES %%%%%%%%%%
evaluate_diagonals(Board, PlayerMark, DiagonalScore) :-
    all_diagonals(Board, Diagonals), % on récupère les diagonales du plateau
    evaluate_columns(Diagonals, PlayerMark, DiagonalScore).
    


