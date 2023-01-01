
:- dynamic(current_player/1).

game1(Board):-

  game_over(Board);

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
    % If the piece doesn't belong to the current player,
    % prompt the user to choose another piece
    format('~nChoose a piece that belongs to you.~n', []),
    game1(Board)).

game_over(Board) :-
  current_player(Player),
  other_player(Player,OtherPlayer),
  find_all_moves(Board,OtherPlayer,AllMoves),
  list_empty(AllMoves,true),
  format('GAME OVER, WINNER: ~w',[Player]).

game_over(Board) :-
  current_player(Player),
  find_all_moves(Board,Player,AllMoves),
  list_empty(AllMoves,true),
  other_player(Player,OtherPlayer),
  format('GAME OVER, WINNER: ~w',[OtherPlayer]).

find_all_moves(Board, Player, AllMoves) :-
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
  (member((Row,Col),Moves) -> true ; format('~nChoose a valid move from the list.~n',[]), choose_move(Player,Moves,Row,Col)).


% Predicate to make a move on the board
make_move(Board, Player,OldRow, OldCol, NewRow, 11, NewBoard) :-
  % Calculate the between row and col
  %JumpRow is (OldRow + NewRow) // 2,
  %JumpCol is (OldCol + 11) // 2,
  % Check if it is from the other player
  piece_at(Board, OldRow, OldCol, Piece),
  replace_board_value(Board, OldRow, OldCol, empty, NewBoard),!.

% Predicate to make a move on the board
make_move(Board, Player,OldRow, OldCol, NewRow, 0, NewBoard) :-
  % Calculate the between row and col
  %JumpRow is (OldRow + NewRow) // 2,
  %JumpCol is (OldCol + 11) // 2,
  % Check if it is from the other player
  piece_at(Board, OldRow, OldCol, Piece),
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
