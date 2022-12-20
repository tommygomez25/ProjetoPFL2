piece_at(Row, Col, Piece) :-
  initBoard(Board),
  nth0(Row, Board, RowList),
  nth0(Col, RowList, Piece).

valid_position(NumRows, NumCols, Row, Col) :-
  Row >= 0,
  Row < NumRows,
  Col >= 0,
  Col < NumCols.

% Check if the given piece is valid
valid_piece(Piece) :-
  % Check if the jumper is on the board
  piece_at(Row, Col, Piece),
  % Check if the jumper belongs to the current player
  current_player(Player),
  player(Piece, Player).

% Check if the given piece belongs to the given player
player(Piece, red) :-
  piece_at(_, _, Piece),
  Piece \= black_jumper,
  Piece \= black_slipper.
player(Piece, black) :-
  piece_at(_, _, Piece),
  Piece \= red_jumper,
  Piece \= red_slipper.

% Print the list of pieces
print_pieces(Pieces) :-
  format('Pieces:~n',[]),
  maplist(print_piece,Pieces).

% Print a piece
print_piece(Piece) :-
  format('~w~n',[Piece]).

% Check if the given number is a valid piece number
valid_piece_number(PieceNumber, Pieces) :-
  PieceNumber >= 0,
  length(Pieces,Length),
  PieceNumber < Length.

filter([], _, []). % base case: if the list is empty, the filtered list is also empty
filter([X|Xs], Y, [X|Zs]) :- % recursive case: if X is equal to Y,
  X = Y,
  filter(Xs, Y, Zs).
filter([X|Xs], Y, Zs) :- % recursive case: if X is not equal to Y,
  X \= Y,
  filter(Xs, Y, Zs).
/*
% jumper move down
jump(Row, Col, NewRow, NewCol) :-
  NewRow is Row + 2,
  NewCol is Col,
  valid_position(10, 10, NewRow, NewCol).
  BetweenRow is Row + 1,
  BetweenCol is Col,
  piece_at(BetweenRow ,BetweenCol, Piece),
  Piece \= empty.

%jumper move up
jump(Row, Col, NewRow, NewCol) :-
  NewRow is Row - 2,
  NewCol is Col,
  valid_position(10, 10, NewRow, NewCol).
  BetweenRow is Row - 1,
  BetweenCol is Col,
  piece_at(BetweenRow ,BetweenCol, Piece),
  Piece \= empty.
*/
  