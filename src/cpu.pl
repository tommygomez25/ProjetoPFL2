game2(Board):-

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

        % Switch to the CPU
        other_player(Player, OtherPlayer),
        retractall(current_player(_)),
        assert(current_player(OtherPlayer)),

        make_easy_cpu_move(Board2,OtherPlayer,Board3),
        
        % Switch back to the other player
        other_player(OtherPlayer, Player),
        retractall(current_player(_)),
        assert(current_player(Player)),

        % Continue the game loop
        game2(Board3)
        ;
        % If the piece doesn''t belong to the current player,
        % prompt the user to choose another piece
        format('~nChoose a piece that belongs to you.~n', []),
        game2(Board)).

make_easy_cpu_move(Board,Player,NewBoard) :-
    % Get the list of all the pieces belonging to the CPU
    get_player_pieces(Board, Player, Pieces),
    % Select a random piece from the list
    random_member((OldRow, OldCol), Pieces),
    % Get the valid moves for the selected piece
    (player(Board, _, Player),
    valid_jumper_moves(Board, OldRow, OldCol, Moves1)
    ;
    valid_slipper_moves(Board, OldRow, OldCol, Moves2)),
    % Get all moves
    append(Moves1,Moves2,Moves),
    % Check if the list of valid moves is not empty 
    (list_empty(Moves,false) -> 
        % Select a random move from the list of valid moves
        random_member((NewRow, NewCol), Moves),
        % Make the move
        make_move(Board, Player, OldRow, OldCol, NewRow, NewCol, NewBoard),!
        ;
        NewBoard=Board).




make_easy_cpu_move_test(Board,Player,Moves,NewRow,NewCol,NewBoard) :-
    % Get the list of all the pieces belonging to the CPU
    get_player_pieces(Board, Player, Pieces),
    % Select a random piece from the list
    random_member((OldRow, OldCol), Pieces),
    % Get the valid moves for the selected piece
    (player(Board, _, Player),
    valid_jumper_moves(Board, OldRow, OldCol, Moves1)
    ;
    valid_slipper_moves(Board, OldRow, OldCol, Moves2)),
    % Get all moves
    append(Moves1,Moves2,Moves),
    random_member((NewRow, NewCol), Moves),
    make_move(Board, Player, OldRow, OldCol, NewRow, NewCol, NewBoard).
    
game3(Board) :-
    % Print the playing board
    print_board(Board).

    % Get the current player
    %current_player(Player).

    % Prompt the user to choose a piece



value(Board, Player, Value) :-
    % Find the number of moves available for the current player
    (find_all_moves(Board, Player, PlayerMoves),
    length(PlayerMoves, NumPlayerMoves);
    NumPlayerMoves = 0),

    other_player(Player,OtherPlayer),

    % Find the number of moves available for the other player
    (find_all_moves(Board, OtherPlayer, OtherPlayerMoves),
    length(OtherPlayerMoves, NumOtherPlayerMoves);
    NumOtherPlayerMoves = 0),

    % Calculate the score
    Value is NumPlayerMoves - NumOtherPlayerMoves,!.



aux_best_move_piece(_,_,_,_,[],_,_).

aux_best_move_piece(Board, Player, Row, Col, [(NewRow, NewCol)|Tail], Move, Value):-
    make_move(Board, Player, Row, Col, NewRow, NewCol, Board1),
    value(Board1, Player, Value1),
    Value1 > Value,
    write('depois1'),
    format('value1: ~w~n',[Value1]),
    Move = [(Row,Col),(NewRow, NewCol)],
    aux_best_move_piece(Board, Player, Row, Col, Tail, Move, Value1).

aux_best_move_piece(Board, Player, Row, Col, [(NewRow, NewCol)|Tail], Move,Value):-
    make_move(Board, Player, Row, Col, NewRow, NewCol, Board1),
    value(Board1, Player, Value1),
    Value1 =< Value,
    write('depois2'),
    format('value2: ~w~n',[Value]),
    aux_best_move_piece(Board, Player, Row, Col, Tail, Move,Value).


%get_best_move_for_player(+Board,+Player,+Pieces,-BestMove,-BestValue)
get_best_move_for_player(_,_,[],_,_).

get_best_move_for_player(Board,Player,[(Row,Col)|Tail], BestMove, BestValue):-
    valid_slipper_moves(Board,Player,Row,Col,Moves),
    aux_best_move_piece(Board, Player, Row, Col, Moves, Move, Value),
    Value >= BestValue,
    get_best_move_for_player(Board,Player,Tail, Move, Value).

get_best_move_for_player(Board,Player,[(Row,Col)|Tail], BestMove, BestValue):-
    valid_jumper_moves(Board,Player,Row,Col,Moves),
    aux_best_move_piece(Board, Player, Row, Col, Moves, Move, Value),
    Value >= BestValue,
    get_best_move_for_player(Board,Player,Tail, Move, Value).

get_best_move_for_player(Board,Player,[(Row,Col)|Tail], BestMove, BestValue):-
    valid_jumper_moves(Board,Player,Row,Col,Moves),
    aux_best_move_piece(Board, Player, Row, Col, Moves, _, Value),
    Value < BestValue,
    get_best_move_for_player(Board,Player,Tail, BestMove, BestValue).

get_best_move_for_player(Board,Player,[(Row,Col)|Tail], BestMove, BestValue):-
    valid_slipper_moves(Board,Player,Row,Col,Moves),
    aux_best_move_piece(Board, Player, Row, Col, Moves, _, Value),
    Value < BestValue,
    get_best_move_for_player(Board,Player,Tail, BestMove, BestValue).










get_best_move(Board, Player, BestMove, BestValue) :-
    % Find all the pieces belonging to the given player
    findall((Row, Col), belongs_to_player(Board, Row, Col, Player), Pieces),
    % Initialize the best move and best value to very low numbers
    BestMove = [],
    BestValue = -9999,
    % Iterate through all the pieces and find the best move and value for each piece
    get_best_move_for_all_pieces(Board, Player, Pieces, BestMove, BestValue).



get_best_move_for_all_pieces(_, _, [], BestMove, BestValue).

get_best_move_for_all_pieces(Board, Player, [(Row, Col)|RestPieces], BestMove, BestValue) :-
    valid_jumper_moves(Board, Player, Row, Col, Moves);
    valid_slipper_moves(Board, Player, Row, Col, Moves),
    get_best_move_for_piece(Board, Player, Row, Col, Moves, [], -9999, NewBestMove, NewBestValue),
    NewBestValue > BestValue,
    get_best_move_for_all_pieces(Board, Player, RestPieces, NewBestMove, NewBestValue).

get_best_move_for_all_pieces(Board, Player, [(Row, Col)|RestPieces], BestMove, BestValue) :-
    valid_jumper_moves(Board, Player, Row, Col, Moves);
    valid_slipper_moves(Board, Player, Row, Col, Moves),
    get_best_move_for_piece(Board, Player, Row, Col, Moves, [], -9999, NewBestMove, NewBestValue),
    NewBestValue =< BestValue,
    get_best_move_for_all_pieces(Board, Player, RestPieces, BestMove, BestValue).


get_best_move_for_piece(Board, Player, Row, Col,Moves, BestMove, BestValueSoFar, BestMoveOut,BestValueOut) :-
    % If the list of moves is empty, return the best move and value seen so far
    (Moves = [] -> BestMoveOut = BestMove , BestValueOut = BestValueSoFar;
     % Otherwise, get the first move in the list
     Moves = [(NewRow, NewCol)|RestMoves],
     % Make a copy of the board and make the move on the copy
     make_move(Board, Player, Row, Col, NewRow, NewCol, BoardCopy2),
     % Calculate the value of the board after the move
     value(BoardCopy2, Player, Value),
     % If the value of the board is higher than the current best value, update the best value and best move
     (Value > BestValueSoFar -> NewBestMove = [(Row,Col),(NewRow, NewCol)], NewBestValue = Value ; NewBestMove = BestMove, NewBestValue = BestValueSoFar),
     % Recursively find the best move for the remaining moves in the list
     get_best_move_for_piece(Board, Player, Row, Col, RestMoves,NewBestMove, NewBestValue, BestMoveOut,BestValueOut)
    ),!.