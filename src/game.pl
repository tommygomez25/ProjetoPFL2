
:- dynamic(current_player/1).

game1(Board):-

  game_over(Board),!;

  % Print the playing board
  display_game(Board),

  % Get the current player
  current_player(Player),

  % Prompt the user to choose a piece
  get_coordinates(Player, X, Y),
  format('row: ~w col: ~w ~n',[X,Y]),

  % Check if the chosen piece belongs to the current player
  (valid_piece(Board, X, Y) ->
    % If the piece belongs to the current player, continue with the game loop
    piece_at(Board, X, Y, Piece),

    % Get the valid moves for the current piece
    (player(Board, Piece, Player),
     valid_jumper_moves(Board, Player,X, Y, Moves1)
     ;
     valid_slipper_moves(Board,Player, X, Y, Moves2)),

    % Display the available moves
    write('Valid moves: '),
    (Moves1 \= [], print_moves(Moves1) ; Moves2 \= [], print_moves(Moves2); list_empty(Moves1,true),list_empty(Moves2,true),write('You chose a piece that has no valid moves!'),nl,game1(Board)),

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
    game1(Board2)
    ;
    % If the piece doesn''t belong to the current player,
    % prompt the user to choose another piece
    format('~nChoose a piece that belongs to you.~n', []),
    game1(Board)).


current_player(red).

game_over(Board) :-
  current_player(Player),
  other_player(Player,OtherPlayer),
  valid_moves(Board,OtherPlayer,AllMoves),
  list_empty(AllMoves,true),
  format('GAME OVER, WINNER: ~w',[Player]),!.

game_over(Board) :-
  current_player(Player),
  valid_moves(Board,Player,AllMoves),
  list_empty(AllMoves,true),
  other_player(Player,OtherPlayer),
  format('GAME OVER, WINNER: ~w',[OtherPlayer]),!.


% Predicate to choose a move from the list of valid moves
choose_move(Player,Moves, Row, Col) :-

  format('~nPlayer ~w, choose a move (X Y):~n', [Player]),

  write('Row [1-10]: '),
  read(Row), 
  write('Column [a-j]: '),
  read(Y),
  letter_to_number(Y,Col).

  (member((Row,Col),Moves) -> true ; format('~nChoose a valid move from the list.~n',[]), choose_move(Player,Moves,Row,Col)).


% Predicate to make a move on the board
make_move(Board, _,OldRow, OldCol, _, 11, NewBoard) :-

  piece_at(Board, OldRow, OldCol, _),
  replace_board_value(Board, OldRow, OldCol, empty, NewBoard),!.

% Predicate to make a move on the board
make_move(Board, _,OldRow, OldCol, _, 0, NewBoard) :-

  piece_at(Board, OldRow, OldCol, _),
  replace_board_value(Board, OldRow, OldCol, empty, NewBoard),!.

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
   replace_board_value(NBoard2, JumpRow, JumpCol, SlipperColor, NewBoard),!
   ;
   % If there is no jumper between the old position and the new position,
   % just make the move without removing any piece
   piece_at(Board, OldRow, OldCol, Piece),
   replace_board_value(Board, OldRow, OldCol, empty, NBoard),
   replace_board_value(NBoard, NewRow, NewCol, Piece, NewBoard)),!.


% Predicate to switch to the other player
other_player(red, black).
other_player(black, red).
