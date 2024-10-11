%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% MATRIX PROCESSING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- module(matrix_processing, [all_diagonals/2]).

:-use_module('list_processing.pl').


%.......................................
% subMatrix
%.......................................
% Given a length N, extract a submatrix with N rows and N columns 
% from a bigger matrix
%.......................................

pick_elements(List, 0, List_2, List_2).

pick_elements([X|List], Length, List_2, List_3):-
  M is Length-1,
  pick_elements(List, M, List_2, List_4),
  append([X], List_4, List_3)
  .

iteration(Matrix, Length, A, Matrix_2, Matrix_2) :-
  B is Length + 1,
  A = B
  .

iteration(Matrix, Length, A, Old_List, Final_List):-
  get_item(Matrix, A, List),
  pick_elements(List, Length, [], New_List),
  append(Old_List, [New_List], Temp_List),
  A1 is A + 1,
  iteration(Matrix, Length, A1, Temp_List, Final_List)
  .
  
subMatrix(Matrix, Length, M2, Sub_matrix):-
  pick_elements(Matrix, Length, [] , Temp_Matrix),
  iteration(Temp_Matrix, Length, 1, [], Sub_matrix)
  .

  
%.......................................
% all_diagonals
%.......................................
% Extract all diagonals => 4 elements from a board

% extract_element/3
% Extracts an element from a list at a position equal to the length of the second list.
% L is the original list, L1 is the accumulator, and the resulting list is [H|L1].
extract_element(L, L1, [H|L1]):- 
    length(L1, N1), 
    length(L2, N1), 
    append(L2, [H|_], L).

% diagonal2/3
% Extracts a diagonal from a 2D matrix (In) with offset N.
% M2 is a temporary variable (unused), Sous_matrice is a sub-matrix from In.
diagonal2(In, Out, N):- 
    subMatrix(In, N, M2, Sous_matrice),
    reverse(Sous_matrice, In2),
    foldl(extract_element, In2, [], Out).

% diagonals_offset_1/2
% Extracts the diagonal with an offset of 1 cell from the top of a 2D matrix ([X|In]).
% M2 is a temporary variable (unused), Sous_matrice_6 is a sub-matrix from In.
diagonals_offset_1([X|In], Out):-
    subMatrix(In, 6, M2, Sous_matrice_6),
    foldl(extract_element, Sous_matrice_6, [], Res),
    reverse(Res, Out).

% diagonals_offset_2/2
% Extracts the diagonal with an offset of 2 cells from the top of a 2D matrix ([X, Y|In]).
% Similar approach as diagonals_offset_1 but with an offset of 2.
diagonals_offset_2([X, Y|In], Out):-
    subMatrix(In, 5, M2, Sous_matrice_5),
    foldl(extract_element, Sous_matrice_5, [], Res),
    reverse(Res, Out).

% diagonals_offset_3/2
% Extracts the diagonal with an offset of 3 cells from the top of a 2D matrix ([X, Y, Z|In]).
% Similar approach as diagonals_offset_1 but with an offset of 3.
diagonals_offset_3([X, Y, Z|In], Out) :-
    subMatrix(In, 4, M2, Sous_matrice_4),
    foldl(extract_element, Sous_matrice_4, [], Res),
    reverse(Res, Out).

% diagonals_offset/2
% Collects all diagonals with different offsets from a 2D matrix (In).
diagonals_offset(In, Out):-
  diagonals_offset_1(In, Out_1),
  append([], [Out_1], Temp_List_1),
  diagonals_offset_2(In, Out_2),
  append([Out_2], Temp_List_1, Temp_List_2),
  diagonals_offset_3(In, Out_3),
  append([Out_3], Temp_List_2, Out).

% diagonals/2
% Extracts diagonals starting from the top left of a board (In).
diagonals(In, Out):-
  invert_columns(In, In_temp),
  diagonal2(In_temp, Out_1, 4),
  append([], [Out_1], Temp_List_1),
  diagonal2(In_temp, Out_2, 5),
  append([Out_2], Temp_List_1 , Temp_List_2),
  diagonal2(In_temp, Out_3, 6), 
  append([Out_3], Temp_List_2 , Out).

% all_diagonals/2
% Extracts every diagonal from a 2D matrix (In).
all_diagonals(In,Out):-
  diagonals(In, Out_1),
  append([], Out_1, List_Temp_1),
  diagonals_offset(In, Out_2),
  append(List_Temp_1, Out_2, List_Temp_2),
  reverse(In, In_rev),
  diagonals(In_rev, Out_3),
  append(List_Temp_2, Out_3, List_Temp_3),
  diagonals_offset(In_rev, Out_4),
  append(List_Temp_3, Out_4, Out).


% invert_columns/2
% Inverts the columns of a matrix.
%
% Tableau is the original matrix (list of lists) where each inner list represents a column.
% TableauInverse is the resulting matrix with each column inverted (reversed).
%
% The predicate uses maplist/3 to apply invert_list/2 to each column of the matrix.

invert_columns(Tableau, TableauInverse) :-
    maplist(reverse, Tableau, TableauInverse).

