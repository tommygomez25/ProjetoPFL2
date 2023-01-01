valid_moves(Board, Player, AllMoves) :-
    % Only call get_all_moves if there are available Pieces for the current Player
    (setof((Row, Col), (member(Row, [1,2,3,4,5,6,7,8,9,10]), member(Col, [1,2,3,4,5,6,7,8,9,10]), belongs_to_player(Board, Row, Col, Player)), Pieces)
    -> get_all_moves(Board, Pieces, AllMoves),!
    ; AllMoves = []).
  
get_all_moves(_, [], []).
get_all_moves(Board, [(Row, Col)|Coords], Moves) :-
    % Get the valid moves for the current piece
    (player(Board, Piece, Player),
     valid_jumper_moves(Board, Player,Row, Col, Moves1)
     ;
     valid_slipper_moves(Board, Player,Row, Col, Moves2)),
    % Add the valid moves for the current piece to the list of moves
    append(Moves1, Moves2, PieceMoves),
    % Recursively find the valid moves for the remaining pieces
    get_all_moves(Board, Coords, RemainingMoves),
    % Add the moves for the remaining pieces to the list of moves
    append(PieceMoves, RemainingMoves, Moves).    

% Generate the list of valid moves for a slipper starting from the given position
valid_slipper_moves(Board,red,Row, Col, Moves) :-
    valid_slipper_move_right(Board,Row, Col, Moves),!.

% Generate the list of valid moves for a slipper starting from the given position
valid_slipper_moves(Board,black,Row, Col, Moves) :-
    valid_slipper_move_left(Board,Row, Col, Moves),!.

valid_slipper_move_right(Board,Row, 10, Move) :-
        %Move the slipper one cell to the right
        valid_position(12, 12, Row, 11),
        append([(Row,11 )], [], Move),
        !.
    
valid_slipper_move_right(Board,Row, Col, Move) :-
    %Move the slipper one cell to the right
    NewCol is Col + 1,
    valid_position(12, 12, Row, NewCol),
    piece_at(Board,Row, NewCol, empty),
    valid_slipper_move_right(Board,Row, NewCol, SubMoves),
    append([(Row, NewCol)], SubMoves, Move),
    !.

valid_slipper_move_right(_,_, _, Move):-
    append([],[],Move).
  
  
valid_slipper_move_left(Board,Row, Col, Move) :-
    % Move the slipper one cell to the left
    NewCol is Col - 1,
    valid_position(12, 12, Row, NewCol),
    piece_at(Board,Row, NewCol, empty),
    valid_slipper_move_left(Board,Row, NewCol, SubMoves),
    append(SubMoves, [(Row, NewCol)], Move),
    !.

 valid_slipper_move_left(Board,Row, 1, Move) :-
        %Move the slipper one cell to the right
        valid_position(12, 12, Row, 0),
        append([(Row,0 )], [], Move),
        !. 
  
  valid_slipper_move_left(_,_, _, Move):-
    append([],[],Move). 
 

% Generate the list of valid moves for a jumper starting from the given position
valid_jumper_moves(Board,red,Row, Col, Moves) :-
    piece_at(Board,Row, Col, red_jumper),
    valid_jumper_move_right(Board,Row, Col, MovesR),
    %valid_jumper_move_left(Board,red,Row, Col, MovesL),
    valid_jumper_move_up(Board,red,Row,Col,MovesU),
    valid_jumper_move_down(Board,red,Row,Col,MovesD),
    append(MovesU,MovesD,MovesV),
    append(MovesR,MovesV,Moves),
    !.

% Generate the list of valid moves for a jumper starting from the given position
valid_jumper_moves(Board,black,Row, Col, Moves) :-
    piece_at(Board,Row, Col, black_jumper),
    valid_jumper_move_left(Board,Row, Col, MovesL),
    valid_jumper_move_up(Board,black,Row,Col,MovesU),
    valid_jumper_move_down(Board,black,Row,Col,MovesD),
    append(MovesU,MovesD,MovesV),
    append(MovesL,MovesV,Moves),
    !.

valid_jumper_move_up(Board,red,Row,Col,Moves) :-
    piece_at(Board,Row, Col, red_jumper),
    EnemyRow is Row - 1,
    EmptyRow is Row - 2,
    % If the piece below is a piece from the other team, check if the other one is empty and then append the possible move to the list of moves. Otherwise, the list doesnt change
    (   once((piece_at(Board,EnemyRow, Col, black_jumper);
    piece_at(Board,EnemyRow, Col, black)))
    ->  once(piece_at(Board,EmptyRow, Col, empty)),
        append([],[(EmptyRow, Col)], Moves)
    ;   Moves = []
    ),!. 

valid_jumper_move_up(Board,black,Row,Col,Moves) :-
    piece_at(Board,Row, Col, black_jumper),
    EnemyRow is Row - 1,
    EmptyRow is Row - 2,
    % If the piece below is a piece from the other team, check if the other one is empty and then append the possible move to the list of moves. Otherwise, the list doesnt change
    (   once((piece_at(Board,EnemyRow, Col, red_jumper);
    piece_at(Board,EnemyRow, Col, red)))
    ->  once(piece_at(Board,EmptyRow, Col, empty)),
        append([],[(EmptyRow, Col)], Moves)
    ;   Moves = []
    ),!. 

valid_jumper_move_down(Board,black,Row,Col,Moves) :-
    piece_at(Board,Row, Col, black_jumper),
    EnemyRow is Row + 1,
    EmptyRow is Row + 2,
    % If the piece below is a piece from the other team, check if the other one is empty and then append the possible move to the list of moves. Otherwise, the list doesnt change
    (   once((piece_at(Board,EnemyRow, Col, red_jumper);
    piece_at(Board,EnemyRow, Col, red)))
    ->  once(piece_at(Board,EmptyRow, Col, empty)),
        append([],[(EmptyRow, Col)], Moves)
    ;   Moves = []
    ),!.

valid_jumper_move_down(Board,red,Row,Col,Moves) :-
    piece_at(Board,Row, Col, red_jumper),
    EnemyRow is Row + 1,
    EmptyRow is Row + 2,
    % If the piece below is a piece from the other team, check if the other one is empty and then append the possible move to the list of moves. Otherwise, the list doesnt change
    (   once((piece_at(Board,EnemyRow, Col, black_jumper);
    piece_at(Board,EnemyRow, Col, black)))
    ->  once(piece_at(Board,EmptyRow, Col, empty)),
        append([],[(EmptyRow, Col)], Moves)
    ;   Moves = []
    ),!.


 valid_jumper_move_right(Board,Row, 10, Move) :-
    %Move the jumper one cell to the right
    valid_position(12, 12, Row, 11),
    append([(Row, 11)], [], Move),
    !.

valid_jumper_move_right(Board,Row, Col, Move) :-
    %Move the jumper one cell to the right
    NewCol is Col + 1,
    valid_position(12, 12, Row, NewCol),
    piece_at(Board,Row, NewCol, empty),
    valid_jumper_move_right(Board,Row, NewCol, SubMoves),
    append([(Row, NewCol)], SubMoves, Move),
    !.
  
  valid_jumper_move_right(_,_, _, Move):-
    append([],[],Move).
  

    valid_jumper_move_left(Board,Row, 1, Move) :-
        %Move the jumper one cell to the right
        valid_position(12, 12, Row, 0),
        append([(Row, 0)], [], Move),
        !.

valid_jumper_move_left(Board,Row, Col, Move) :-
    % Move the jumper one cell to the left
    NewCol is Col - 1,
    valid_position(12, 12, Row, NewCol),
    piece_at(Board,Row, NewCol, empty),
    valid_jumper_move_left(Board,Row, NewCol, SubMoves),
    append(SubMoves, [(Row, NewCol)], Move),
    !.

  
valid_jumper_move_left(_,_, _, Move):-
    append([],[],Move).
  