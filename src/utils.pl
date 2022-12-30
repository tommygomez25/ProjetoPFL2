list_empty([], true).
list_empty([_|_], false).

piece_at(Board,Row, Col, Piece) :-
  nth1(Row, Board, RowList),
  nth1(Col, RowList, Piece).

valid_position(NumRows, NumCols, Row, Col) :-
  Row >= 1,
  Row < NumRows,
  Col >= 1,
  Col < NumCols.

get_coordinates(Player,X, Y) :-
  repeat,
  format('Player ~w, enter the coordinates of the piece you wish to move (X. Y.): ',[Player]),
  %Read a string from the current input
  %read_line_to_string(current_input, InputString),
  %Split the string with " " as delimiter
  %split_string(InputString, " ", "", [XString, YString]),
  read(X), 
  read(Y).

get_player_pieces(Board,Player,Pieces):-
  setof((Row, Col), (member(Row, [1,2,3,4,5,6,7,8,9,10]), member(Col, [1,2,3,4,5,6,7,8,9,10]), belongs_to_player(Board, Row, Col, Player)), Pieces).

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
  Piece \= black.

player(Board,Piece, black) :-
  piece_at(Board,_, _, Piece),
  Piece \= empty,
  Piece \= red_jumper,
  Piece \= red.

% Helper predicate to check if a piece belongs to a player
belongs_to_player(Board, Row, Col, Player) :-
  piece_at(Board, Row, Col, Piece),
  player(Board, Piece, Player).

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



  