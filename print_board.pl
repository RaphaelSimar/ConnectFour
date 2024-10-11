:-module(print_board, [print_board/1]).

% :-use_module(library(clpfd)). % transpose
:-use_module('transpose.pl'). % transpose

blank_mark('e').

print_board(Board):-           
    nl,
    transpose(Board, Rows),      % Board stores columns but rows are needed
    reverse(Rows, RevRows),      % Columns are stored upside down. Need to reverse that
    print_column_indices(Board), 
    get_item(Rows, 1, Row),       % Need one row to print separator
    print_separator(Row),        % Print separator after indices
    print_rows(RevRows).         

print_column_indices(Board):-
    length(Board, NumColumns),
    print_column_indices_helper(1, NumColumns).

print_column_indices_helper(Current, NumColumns):-
    Current =< NumColumns,
    format("| ~w ", [Current]),  % Format column number within a cell
    Next is Current + 1,
    print_column_indices_helper(Next, NumColumns).

print_column_indices_helper(Current, NumColumns):-
    Current > NumColumns,       % Base case
    write('|'),                 % Print last vertical bar after column indices
    nl, !.

print_rows([]).                
print_rows([Row|Rows]):-
    print_row(Row),            
    print_separator(Row),
    print_rows(Rows).          

print_separator([]):-
    nl,!.

print_separator([_|Cells]):-
    write('+---'),             % 3 characters for the cell, 1 for separator
    print_separator(Cells).

print_row([]):-                 
    write('|'),                 % Print vertical bar at the end of each row
    nl.

print_row([Cell|Cells]):-
    print_cell(Cell),          
    print_row(Cells).          

print_cell(Cell):-
    blank_mark(Cell), !,
    write('| ~ ').

print_cell(Cell):-
    format("| ~w ", [Cell]).
