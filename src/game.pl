
:- dynamic(current_player/1).


/*
% Main game loop
play :-
  % Check if the game is over
  game_over(Winner),
  !,
  % Print the winner and end the game
  format('Game over, winner: ~w~n', [Winner]).
*/
play :-
  initBoard(Board),
  retractall(current_player(_)),
  assert(current_player(black)),
  game(Board).

game(Board):-
  % Print the playing board
  print_board(Board),

  % Get the current player
  current_player(Player),

  % Prompt the user to choose a piece
  get_coordinates(Player, X, Y),

  % Check if the chosen piece belongs to the current player
  (valid_piece(Board, X, Y) ->
    % If the piece belongs to the current player, continue with the game loop
    piece_at(Board, X, Y, Piece),

    % Get the valid moves for the current piece
    (player(Board, Piece, Player),
     valid_jumper_moves(Board, X, Y, Moves1)
     ;
     valid_slipper_moves(Board, X, Y, Moves2)),

    % Display the available moves
    write('Valid moves: '),
    (Moves1 \= [], print_moves(Moves1) ; Moves2 \= [], print_moves(Moves2)),

    % Choose a move
    (Moves1 \= [], choose_move(Player, Moves1, NewRow, NewCol)
     ;
     Moves2 \= [], choose_move(Player,Moves2, NewRow, NewCol)),

    % Make the move
    make_move(Board, Player, X, Y, NewRow, NewCol, Board2),

    % Switch to the other player
    other_player(Player, OtherPlayer),
    retractall(current_player(_)),
    assert(current_player(OtherPlayer)),

    % Continue the game loop
    game(Board2)
    ;
    % If the piece doesn't belong to the current player,
    % prompt the user to choose another piece
    format('~nChoose a piece that belongs to you.~n', []),
    game(Board)).


% Predicate to choose a move from the list of valid moves
choose_move(Player,Moves, Row, Col) :-
  % Prompt the player to choose a move
  format('~nPlayer ~w, choose a move (X Y):~n', [Player]),
  % Read the chosen move from the player
  read_line_to_string(current_input, InputString),
  % Split the string with " " as delimiter
  split_string(InputString, " ", "", [XString, YString]),
  % Convert the atoms to numbers
  atom_number(XString, Row), atom_number(YString, Col),
  % Check if the chosen move is valid
  (member((Row,Col),Moves) -> true ; format('~nChoose a valid more from the list.~n',[]), choose_move(Player,Moves,Row,Col)).

% Predicate to make a move on the board
make_move(Board, Player,OldRow, OldCol, NewRow, NewCol, NewBoard) :-
  % Calculate the between row and col
  JumpRow is (OldRow + NewRow) // 2,
  JumpCol is (OldCol + NewCol) // 2,
  % Check if it is from the other player
  (piece_at(Board, JumpRow, JumpCol, PieceJumped),
   player(Board, PieceJumped, OtherPlayer),
   OtherPlayer \= Player,
   other_player(Player, SlipperColor),
   piece_at(Board, OldRow, OldCol, Piece),
   replace_board_value(Board, OldRow, OldCol, empty, NBoard),
   replace_board_value(NBoard, NewRow, NewCol, Piece, NBoard2),
   replace_board_value(NBoard2, JumpRow, JumpCol, SlipperColor, NewBoard)
   ;
   % If there is no jumper between the old position and the new position,
   % just make the move without removing any piece
   piece_at(Board, OldRow, OldCol, Piece),
   replace_board_value(Board, OldRow, OldCol, empty, NBoard),
   replace_board_value(NBoard, NewRow, NewCol, Piece, NewBoard)).

/*
% Predicate to check if the game is over
game_over(Winner) :-
  % Check if the red player has no more valid moves
  current_player(red),
  \+ valid_moves(red, _),
  !,
  Winner = black.

game_over(Winner) :-
  % Check if the black player has no more valid moves
  current_player(black),
  \+ valid_moves(black, _),
  !,
  Winner = red.
*/
% Predicate to switch to the other player
other_player(red, black).
other_player(black, red).


% Generate the list of valid moves for a slipper starting from the given position
valid_slipper_moves(Board,Row, Col, Moves) :-
  valid_slipper_move_right(Board,Row, Col, MovesR),
  valid_slipper_move_left(Board,Row, Col, MovesL),
  append(MovesL, MovesR, Moves).

valid_slipper_move_right(Board,Row, Col, Move) :-
  %Move the slipper one cell to the right
  NewCol is Col + 1,
  valid_position(11, 11, Row, NewCol),
  piece_at(Board,Row, NewCol, empty),
  valid_slipper_move_right(Board,Row, NewCol, SubMoves),
  append([(Row, NewCol)], SubMoves, Move),
  !.

% Generate a list of valid moves for a slipper
valid_slipper_move_right(Board,Row, Col, Move):-
  NewCol is Col + 1,
  \+piece_at(Board,Row, NewCol, empty),
  reverse(Move, Move).

valid_slipper_move_right(_,_, _, Move):-
  append([],[],Move).


valid_slipper_move_left(Board,Row, Col, Move) :-
  % Move the slipper one cell to the left
  NewCol is Col - 1,
  valid_position(11, 11, Row, NewCol),
  piece_at(Board,Row, NewCol, empty),
  valid_slipper_move_left(Board,Row, NewCol, SubMoves),
  append(SubMoves, [(Row, NewCol)], Move),
  !.

% Generate a list of valid moves for a slipper
valid_slipper_move_left(Board,Row, Col, Move):-
  NewCol is Col - 1,
  \+piece_at(Board,Row, NewCol, empty),
  reverse(Move, Move).

valid_slipper_move_left(_,_, _, Move):-
  append([],[],Move).




% Generate the list of valid moves for a jumper starting from the given position
valid_jumper_moves(Board,Row, Col, Moves) :-
  piece_at(Board,Row, Col, red_jumper),
  valid_jumper_move_right(Board,Row, Col, MovesR),
  valid_jumper_move_left(Board,Row, Col, MovesL),
  append(MovesL, MovesR, MovesT),
  EnemyRow is Row + 1,
  EmptyRow is Row + 2,
  % If the piece below is a piece from the other team, check if the other one is empty and then append the possible move to the list of moves. Otherwise, the list doesnt change
  (   once((piece_at(Board,EnemyRow, Col, black_jumper);
  piece_at(Board,EnemyRow, Col, black)))
  ->  once(piece_at(Board,EmptyRow, Col, empty)),
      append(MovesT,[(EmptyRow, Col)], Moves)
  ;   Moves = MovesT
  ).

valid_jumper_moves(Board,Row, Col, Moves) :-
  piece_at(Board,Row, Col, red_jumper),
  valid_jumper_move_right(Board,Row, Col, MovesR),
  valid_jumper_move_left(Board,Row, Col, MovesL),
  append(MovesL, MovesR, MovesT),
  EnemyRow is Row - 1,
  EmptyRow is Row - 2,
  % If the piece above is a piece from the other team, check if the other one is empty and then append the possible move to the list of moves. Otherwise, the list doesnt change
  (   once((piece_at(Board,EnemyRow, Col, black_jumper);
  piece_at(Board,EnemyRow, Col, black)))
  ->  once(piece_at(Board,EmptyRow, Col, empty)),
      append(MovesT,[(EmptyRow, Col)], Moves)
  ;   Moves = MovesT
  ).

valid_jumper_moves(Board,Row, Col, Moves) :-
  piece_at(Board,Row, Col, black_jumper),
  valid_jumper_move_right(Board,Row, Col, MovesR),
  valid_jumper_move_left(Board,Row, Col, MovesL),
  append(MovesL, MovesR, MovesT),
  EnemyRow is Row + 1,
  EmptyRow is Row + 2,
  % If the piece below is a piece from the other team, check if the other one is empty and then append the possible move to the list of moves. Otherwise, the list doesnt change
  (   once((piece_at(Board,EnemyRow, Col, red_jumper);
  piece_at(Board,EnemyRow, Col, red)))
  ->  once(piece_at(Board,EmptyRow, Col, empty)),
      append(MovesT,[(EmptyRow, Col)], Moves)
  ;   Moves = MovesT
  ).

  valid_jumper_moves(Board,Row, Col, Moves) :-
    piece_at(Board,Row, Col, black_jumper),
    valid_jumper_move_right(Board,Row, Col, MovesR),
    valid_jumper_move_left(Board,Row, Col, MovesL),
    append(MovesL, MovesR, MovesT),
    EnemyRow is Row - 1,
    EmptyRow is Row - 2,
    % If the piece above is a piece from the other team, check if the other one is empty and then append the possible move to the list of moves. Otherwise, the list doesnt change
    (   once((piece_at(Board,EnemyRow, Col, red_jumper);
    piece_at(Board,EnemyRow, Col, red)))
    ->  once(piece_at(Board,EmptyRow, Col, empty)),
        append(MovesT,[(EmptyRow, Col)], Moves)
    ;   Moves = MovesT
    ).

/*
valid_jumper_moves(Board,Row, Col, Moves) :-
  (piece_at(Board,Row, Col, red_jumper);
  piece_at(Board,Row, Col, black_jumper)),
  valid_jumper_move_right(Board,Row, Col, MovesR),
  valid_jumper_move_left(Board,Row, Col, MovesL),
  append(MovesL, MovesR, Moves).
  
*/
valid_jumper_move_right(Board,Row, Col, Move) :-
  %Move the jumper one cell to the right
  NewCol is Col + 1,
  valid_position(11, 11, Row, NewCol),
  piece_at(Board,Row, NewCol, empty),
  valid_jumper_move_right(Board,Row, NewCol, SubMoves),
  append([(Row, NewCol)], SubMoves, Move),
  !.

% Generate a list of valid moves for a jumper
valid_jumper_move_right(Board,Row, Col, Move):-
  NewCol is Col + 1,
  \+piece_at(Board,Row, NewCol, empty),
  reverse(Move, Move).

valid_jumper_move_right(_,_, _, Move):-
  append([],[],Move).


valid_jumper_move_left(Board,Row, Col, Move) :-
  % Move the jumper one cell to the left
  NewCol is Col - 1,
  valid_position(11, 11, Row, NewCol),
  piece_at(Board,Row, NewCol, empty),
  valid_jumper_move_left(Board,Row, NewCol, SubMoves),
  append(SubMoves, [(Row, NewCol)], Move),
  !.

% Generate a list of valid moves for a jumper
valid_jumper_move_left(Board,Row, Col, Move):-
  NewCol is Col - 1,
  valid_position(11, 11, Row, NewCol),
  \+piece_at(Board,Row, NewCol, empty),
  reverse(Move, Move).

valid_jumper_move_left(_,_, _, Move):-
  append([],[],Move).

/*
% Generate the list of valid moves for the given player
valid_moves(Player, Moves) :-
  findall(Move, valid_piece_move(Player, Move), Moves).

% Generate the list of valid moves for a jumper
valid_piece_move(red_jumper, Move) :-
  piece_at(Row, Col, red_jumper),
  valid_jumper_moves(Row, Col, Move).

valid_piece_move(black_jumper, Move) :-
  piece_at(Row, Col, black_jumper),
  valid_jumper_moves(Row, Col, Move).

% Generate the list of valid moves for a slipper
valid_piece_move(, Move) :-
  piece_at(Row, Col, red_slipper),
  valid_slipper_moves(Row, Col, Move).

valid_piece_move(black_slipper, Move) :-
  piece_at(Row, Col, black_slipper),
  valid_slipper_moves(Row, Col, Move).
  */