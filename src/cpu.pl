
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
        valid_jumper_moves(Board, Player,X, Y, Moves1)
        ;
        valid_slipper_moves(Board,Player, X, Y, Moves2)),

        % Display the available moves
        write('Valid moves: '),
        (Moves1 \= [], print_moves(Moves1) ; Moves2 \= [], print_moves(Moves2); list_empty(Moves1,true),list_empty(Moves2,true),write('You chose a piece that has no valid moves!'),nl,game2(Board)),

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
        % If the piece doesn't belong to the current player,
        % prompt the user to choose another piece
        format('~nChoose a piece that belongs to you.~n', []),
        game2(Board)).

make_easy_cpu_move(Board,Player,NewBoard) :-
    % Get the list of all the pieces belonging to the CPU
    get_player_pieces(Board, Player, Pieces),
    % Select a random piece from the list
    random_member((OldRow, OldCol), Pieces),
    % Get the valid moves for the selected piece
    (player(Board, Piece, Player),
    valid_jumper_moves(Board, Player,OldRow, OldCol, Moves1)
    ;
    valid_slipper_moves(Board, Player,OldRow, OldCol, Moves2)),
    % Get all moves
    append(Moves1,Moves2,Moves),
    write('Moves CPU can chose from: '),
    print_moves(Moves),
    % Check if the list of valid moves is not empty 
    (list_empty(Moves,false) -> 
        % Select a random move from the list of valid moves
        random_member((NewRow, NewCol), Moves),
        % Make the move
        make_move(Board, Player, OldRow, OldCol, NewRow, NewCol, NewBoard),!
        ;
        NewBoard=Board).

value(Board, Player, Value) :-
    % Find the number of moves available for the current player
    find_all_moves(Board, Player, PlayerMoves),
    length(PlayerMoves, NumPlayerMoves),

    other_player(Player,OtherPlayer),

    % Find the number of moves available for the other player
    find_all_moves(Board, OtherPlayer, OtherPlayerMoves),
    length(OtherPlayerMoves, NumOtherPlayerMoves),

    % Calculate the score
    Value is NumPlayerMoves - NumOtherPlayerMoves.
/*
get_best_move(Board, Player, BestMove, BestValue) :-
    % Initialize the best value to a very low number
    BestValue = -9999,
    % Get the list of pieces belonging to the given player
    get_player_pieces(Board, Player, Pieces),
    % Iterate through the list of pieces and find the best move for each piece
    forall(member((Row, Col), Pieces),
            (
                % Find the best move for the current piece
                get_best_move_for_piece(Board, Player, Row, Col, Move, Value),
                % If the value of the board is higher than the current best value, update the best value and best move
                (Value > BestValue -> BestValue = Value, BestMove = Move ; true)
            )
    ).


get_best_move_for_piece(Board,Player,Row,Col,BestMove,BestValue) :-
    % Get the possible moves for the current piece
    valid_jumper_moves(Board,Player,Row,Col,Moves1),
    valid_slipper_moves(Board,Player,Row,Col,Moves2),
    append(Moves1,Moves2,Moves),
    print_moves(Moves),
    % Iterate through the possible moves for the current piece and find the best evaluated
    forall(member((NewRow, NewCol),Moves),
    (
        copy_board(Board, BoardCopy),
        make_move(BoardCopy, Player, Row, Col, NewRow, NewCol, BoardCopy2),
        value(BoardCopy2, Player, Value),
        format('~w',[Value]),
        (Value > BestValue -> BestValue is Value, BestMove = (NewRow, NewCol) ; true)
    )
),!.
*/
get_best_move(Board, Player, BestMoves) :-
    % Find all the pieces belonging to the given player
    get_player_pieces(Board,Player,Pieces),
    get_best_move_for_all_pieces(Board, Player, Pieces, BestMoves,BM).

get_best_move_for_all_pieces(_, _, [], Acc,Acc) :- !.
get_best_move_for_all_pieces(Board, Player, [(Row, Col)|RestPieces],BestMoves,Acc) :-
    % Get the possible moves for the current piece
    valid_jumper_moves(Board, Player, Row, Col, Moves1),
    valid_slipper_moves(Board, Player, Row, Col, Moves2),
    append(Moves1, Moves2, Moves),
    % Find the best move and value for the current piece
    get_best_move_for_piece(Board, Player, Row, Col, Moves, [], -9999, NewBestMove, NewBestValue),
    append(Acc,[(NewBestValue,NewBestMove)],NewAcc),
    get_best_move_for_all_pieces(Board,Player,RestPieces,BestMoves,NewAcc),!.
    


get_best_move_for_piece(Board, Player, Row, Col,Moves, BestMove, BestValueSoFar, BestMoveOut,BestValueOut) :-
    % If the list of moves is empty, return the best move and value seen so far
    (Moves = [] -> BestMoveOut = BestMove , BestValueOut = BestValueSoFar;
     % Otherwise, get the first move in the list
     Moves = [(NewRow, NewCol)|RestMoves],
     % Make a copy of the board and make the move on the copy
     copy_board(Board, BoardCopy),
     make_move(BoardCopy, Player, Row, Col, NewRow, NewCol, BoardCopy2),
     % Calculate the value of the board after the move
     value(BoardCopy2, Player, Value),
     % If the value of the board is higher than the current best value, update the best value and best move
     (Value > BestValueSoFar -> NewBestMove = [(Row,Col),(NewRow, NewCol)], NewBestValue = Value ; NewBestMove = BestMove, NewBestValue = BestValueSoFar),
     % Recursively find the best move for the remaining moves in the list
     get_best_move_for_piece(Board, Player, Row, Col, RestMoves,NewBestMove, NewBestValue, BestMoveOut,BestValueOut)
    ).
