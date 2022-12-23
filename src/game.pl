
:- dynamic(current_player/1).


% Initialize the board and the current player
init_game :-
  initBoard(Board),
  retractall(current_player(_)),
  assert(current_player(red)).

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
  % Get the current player
  current_player(Player),
  % Prompt the user to choose a piece
  format('Choose a piece(red_jumper/red_slipper/black_jumper/black_slipper):~n',[]),
  read(Piece),
  valid_piece(Piece),
  % Get a list with all pieces on the board and filter it to only have the input piece
  findall(P,piece_at(_,_,P),Pieces),
  filter(Pieces,Piece,NewPieces),
  print_pieces(NewPieces),
  % Prompt the user to choose a piece from the available pieces
  format('Choose a ~w:~n',[Piece]),
  read(PieceNumber),
  valid_piece_number(PieceNumber,NewPieces),
  % Get the valid moves for the current piece
  valid_moves(Piece, Moves),
  % Choose a move
  choose_move(Player, Moves, Row, Col),
  % Make the move
  make_move(Player, Row, Col),
  % Switch to the other player
  other_player(Player, OtherPlayer),
  retractall(current_player(_)),
  assert(current_player(OtherPlayer)),
  % Continue the game loop
  play.


% Predicate to choose a move from the list of valid moves
choose_move(Player, Moves, Row, Col) :-
  % Prompt the player to choose a move
  format('Player ~w, choose a move:~n', [Player]),
  % Display the valid moves
  maplist(write, Moves),
  % Read the chosen move from the player
  read((Row, Col)),
  % Check if the chosen move is valid
  member((Row, Col), Moves).

% Predicate to make a move on the board
make_move(Player, Row, Col) :-
  % Place the piece on the board
  piece_at(Row, Col, empty),
  retract(piece_at(Row, Col, empty)),
  assert(piece_at(Row, Col, Player)).
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


% Generate the list of valid moves for the given player
valid_moves(Player, Moves) :-
  findall(Move, valid_piece_move(Player, Move), Moves).

% Generate the list of valid moves for a jumper
valid_piece_move(Player, Move) :-
  piece_at(Row, Col, Player),
  valid_jumper_moves(Row, Col, Move).

% Generate the list of valid moves for a slipper
valid_piece_move(Player, Move) :-
  piece_at(Row, Col, Player),
  valid_slipper_moves(Row, Col, Move).
  
% Generate the list of valid moves for a slipper starting from the given position
valid_slipper_moves(Row, Col, Moves) :-
  valid_slipper_move_right(Row, Col, MovesR),
  valid_slipper_move_left(Row, Col, MovesL),
  append(MovesL, MovesR, Moves).

valid_slipper_move_right(Row, Col, Move) :-
  %Move the slipper one cell to the right
  NewCol is Col + 1,
  valid_position(10, 10, Row, NewCol),
  piece_at(Row, NewCol, empty),
  valid_slipper_move_right(Row, NewCol, SubMoves),
  append([(Row, NewCol)], SubMoves, Move),
  !.

% Generate a list of valid moves for a slipper
valid_slipper_move_right(Row, Col, Move):-
  NewCol is Col + 1,
  \+piece_at(Row, NewCol, empty),
  reverse(Move, Move).

valid_slipper_move_right(_, _, Move):-
  append([],[],Move).


valid_slipper_move_left(Row, Col, Move) :-
  % Move the slipper one cell to the left
  NewCol is Col - 1,
  valid_position(10, 10, Row, NewCol),
  piece_at(Row, NewCol, empty),
  valid_slipper_move_left(Row, NewCol, SubMoves),
  append(SubMoves, [(Row, NewCol)], Move),
  !.

% Generate a list of valid moves for a slipper
valid_slipper_move_left(Row, Col, Move):-
  NewCol is Col - 1,
  \+piece_at(Row, NewCol, empty),
  reverse(Move, Move).

valid_slipper_move_left(_, _, Move):-
  append([],[],Move).
