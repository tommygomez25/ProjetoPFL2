piece_at(Board,Row, Col, Piece) :-
  nth1(Row, Board, RowList),
  nth1(Col, RowList, Piece).

valid_position(NumRows, NumCols, Row, Col) :-
  Row >= 1,
  Row < NumRows,
  Col >= 1,
  Col < NumCols.

get_coordinates(Player,X, Y) :-
    write('Enter the coordinates of the piece you wish to move (X Y): '),
    % Read a string from the current input
    read_string(current_input,"\n", "\r\t ",End,InputString),
    % Split the string with " " as delimiter
    split_string(InputString, " ", "", [XString, YString]),
    % Convert the atoms to numbers
    atom_number(XString, X), atom_number(YString, Y).

% Check if the given piece is valid
valid_piece(Board,X,Y) :-
  % Check if the given coordinates are within the board borders
  valid_position(11,11,X,Y),
  % Check if the piece is on the board
  piece_at(Board,X, Y, Piece),
  % Check if the piece belongs to the current player
  current_player(Player),
  player(Board,Piece, Player).

% Check if the given piece belongs to the given player
player(Board,Piece, red) :-
  piece_at(Board,_, _, Piece),
  Piece \= empty,
  Piece \= black_jumper,
  Piece \= black_slipper.

player(Board,Piece, black) :-
  piece_at(Board,_, _, Piece),
  Piece \= empty,
  Piece \= red_jumper,
  Piece \= red_slipper.

% Print the list of pieces
print_pieces(Pieces) :-
  format('Pieces:~n',[]),
  maplist(print_piece,Pieces).

% Print a piece
print_piece(Piece) :-
  format('~w~n',[Piece]).

filter([], _, []). % base case: if the list is empty, the filtered list is also empty
filter([X|Xs], Y, [X|Zs]) :- % recursive case: if X is equal to Y,
  X = Y,
  filter(Xs, Y, Zs).
filter([X|Xs], Y, Zs) :- % recursive case: if X is not equal to Y,
  X \= Y,
  filter(Xs, Y, Zs).

print_moves([]).
print_moves([(X,Y)|T]) :-
  write(' ('), write(X), write(','),write(Y),write(') '),
  print_moves(T).


replace_board_value_row([_|Tail],1,Value,[Value|Tail]).

replace_board_value_row([Head|Tail],Column,Value,[Head|NewTail]) :-
    % write('\ndentro do replace_board_value_row\n'),
    Column > 1,
    Column1 is Column - 1,
    replace_board_value_row(Tail,Column1,Value,NewTail).

replace_board_value([Head|Tail],1,Column,Value,[NewHead|Tail]) :-
    % write('\ndentro do replace_board_value com row a 0\n'),
    % write(Column),nl,
    replace_board_value_row(Head,Column,Value,NewHead).

replace_board_value([Head|Tail],Row,Column,Value,[Head|NewTail]) :-
    % write('\ndentro do replace_board_value\n'),
    Row > 1,
    Row1 is Row - 1,
    replace_board_value(Tail,Row1,Column,Value,NewTail).

  
read_line_to_string(Stream, String) :-
  read_string(Stream, '\n', '\r', Sep, String0),
  (   Sep \== -1
  ->  String = String0
  ;   String0 == ""
  ->  String = end_of_file
  ;   String = String0
  ).


  