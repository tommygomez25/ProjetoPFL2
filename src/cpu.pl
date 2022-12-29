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
    (player(Board, Piece, Player),
    valid_jumper_moves(Board, OldRow, OldCol, Moves1)
    ;
    valid_slipper_moves(Board, OldRow, OldCol, Moves2)),
    % Get all moves
    append(Moves1,Moves2,Moves),
    random_member((NewRow, NewCol), Moves),
    make_move(Board, Player, OldRow, OldCol, NewRow, NewCol, NewBoard).
    