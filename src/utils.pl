piece_at(Row, Col, Piece) :-
  initBoard(Board),
  nth0(Row, Board, RowList),
  nth0(Col, RowList, Piece).

% verifica se as posições novas são permitidas
valid_position(NumRows, NumCols, Row, Col) :-
  Row >= 0,
  Row < NumRows,
  Col >= 0,
  Col < NumCols.


% gera uma lista com todos os moves possíveis para os jumpers
valid_jumper_moves(Row,Col,Moves) :-
    findall([NewRow,NewCol], (
        (jump(Row,Col,NewRow,NewCol);
        move(Row,Col,NewRow,NewCol)),
        piece_at(NewRow,NewCol,empty)
    ), Moves).

% gera uma lista com todos os moves possíveis para os slippers
valid_slipper_moves(Row, Col, Moves) :-
  findall(Move, valid_slipper_move(Row, Col,Move), Moves).

valid_slipper_move(Row, Col, Move) :-
  % Move the slipper one cell to the right
  NewCol is Col + 1,
  \+ member((Row, NewCol), Moves),
  valid_position(10,10,Row,NewCol),
  piece_at(Row, NewCol, empty),
  valid_slipper_moves(Row, NewCol, SubMoves),
  append([(Row, NewCol)], SubMoves, Move).

valid_slipper_move(Row, Col, Move) :-
  % Move the slipper one cell to the left
  NewCol is Col - 1,
  \+ member((Row, NewCol), Moves),
  valid_position(10,10,Row,NewCol),
  piece_at(Row, NewCol, empty),
  valid_slipper_moves(Row, NewCol, SubMoves),
  append([(Row, NewCol)], SubMoves, Move).

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