game2(Board):-



    % Print the playing board
    display_game(Board),

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
        % If the piece doesn''t belong to the current player,
        % prompt the user to choose another piece
        format('~nChoose a piece that belongs to you.~n', []),
        game2(Board)).
%-------------------------------------------------------------------------------------------------------%

game3(Board):-
    game_over(Board),!.

game3(Board):-

    % Print the playing board
    display_game(Board),

    % Get the current player
    current_player(Player),

    % Prompt the user to choose a piece
    get_coordinates(Player, X, Y),

    % Check if the chosen piece belongs to the current player
    (valid_piece(Board, X, Y) ->
        % If the piece belongs to the current player, continue with the game loop
        piece_at(Board, X, Y, _),

        valid_piece_moves(Board, Player, X, Y,Moves),

        % Display the available moves
        write('Valid moves: '),
        (Moves \= [], print_moves(Moves) ;  list_empty(Moves,true),write('You chose a piece that has no valid moves!'),nl,game3(Board)),

        % Choose a move
        choose_move(Player, Moves, NewRow, NewCol),

        % Make the move
        make_move(Board, Player, X, Y, NewRow, NewCol, Board2),

        % Switch to the CPU
        other_player(Player, OtherPlayer),
        retractall(current_player(_)),
        assert(current_player(OtherPlayer)),

        make_hard_cpu_move(Board2,OtherPlayer,Board3),


        retractall(current_player(_)),
        assert(current_player(Player)),

        % Continue the game loop
        game3(Board3)
        ;
        % If the piece doesn''t belong to the current player,
        % prompt the user to choose another piece
        format('~nChoose a piece that belongs to you.~n', []),
        game3(Board)).

make_easy_cpu_move(Board,Player,NewBoard) :-
    % Get the list of all the pieces belonging to the CPU
    get_player_pieces(Board, Player, Pieces),
    % Select a random piece from the list
    random_member((OldRow, OldCol), Pieces),
    % Get the valid moves for the selected piece
    
    (player(Board, _, Player),
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

    valid_moves(Board, Player, PlayerMoves),
    length(PlayerMoves, NumPlayerMoves),
    
    other_player(Player,OtherPlayer),

    % Find the number of moves available for the other player
    valid_moves(Board, OtherPlayer, OtherPlayerMoves),
    count_jumpers(Board, OtherPlayer, NumJumpersOtherPlayer),
    length(OtherPlayerMoves, NumOtherPlayerMoves),

    % Calculate the score
    Value is NumPlayerMoves - NumOtherPlayerMoves  - NumJumpersOtherPlayer * 2.

get_best_moves(Board, Player, BestMoves) :-
    % Find all the pieces belonging to the given player
    get_player_pieces(Board,Player,Pieces),
    get_best_move_for_all_pieces(Board, Player, Pieces,[], BestMoves).

get_best_move_for_all_pieces(_, _, [], Acc,Acc) :- !.
get_best_move_for_all_pieces(Board, Player, [(Row, Col)|RestPieces],Acc, BestMoves) :-
    % Get the possible moves for the current piece
    (valid_jumper_moves(Board, Player, Row, Col, Moves);
    valid_slipper_moves(Board, Player, Row, Col, Moves)),
    % Find the best move and value for the current piece
    get_best_move_for_piece(Board, Player, Row, Col, Moves, [], -9999, NewBestMove, NewBestValue),
    get_best_move_for_all_pieces(Board,Player,RestPieces,[(NewBestValue,NewBestMove)|Acc],BestMoves),!.
    
get_best_move_for_piece(Board, Player, Row, Col,Moves, BestMove, BestValueSoFar, BestMoveOut,BestValueOut) :-
    % If the list of moves is empty, return the best move and value seen so far
    (Moves = [] -> BestMoveOut = BestMove , BestValueOut = BestValueSoFar;

     Moves = [(NewRow, NewCol)|RestMoves],
    
     make_move(Board, Player, Row, Col, NewRow, NewCol, Board2),

     value(Board2, Player, Value),

     % If the value of the board is higher than the current best value, update the best value and best move
     (Value > BestValueSoFar -> NewBestMove = [(Row,Col),(NewRow, NewCol)], NewBestValue = Value ; NewBestMove = BestMove, NewBestValue = BestValueSoFar),
     % Recursively find the best move for the remaining moves in the list
     
     get_best_move_for_piece(Board, Player, Row, Col, RestMoves,NewBestMove, NewBestValue, BestMoveOut,BestValueOut)
    ).

choose_cpu_hard_move(Moves, OldRow, OldCol, NewRow, NewCol):-
    filterMoves(Moves,FilteredMoves),
    random_member((_,[(OldRow,OldCol),(NewRow, NewCol)]), FilteredMoves).
    
    first_weight([(Weight, _)|_], Weight).
    
filterMoves(List, FilteredList):-
    quicksort(List,SortedList),
    first_weight(SortedList,MaxWeight),
    remove_non_max_weights(SortedList,MaxWeight,[],FilteredList).

make_hard_cpu_move(Board, Player, NewBoard) :-
    get_best_moves(Board, Player, BestMoves),
    (BestMoves = [(-9999,[])] ->
        NewBoard = Board
    ;
        choose_cpu_hard_move(BestMoves, OldRow, OldCol, NewRow, NewCol),
        make_move(Board, Player, OldRow, OldCol, NewRow, NewCol, NewBoard)
    ).

  
        


game4(Board):-
    game_over(Board),!.

game4(Board):-  %CPU HARD VS CPU HARD
    display_game(Board),
    current_player(Player),
    
    make_hard_cpu_move(Board,Player,Board2),
    other_player(Player,OtherPlayer),
    retractall(current_player(_)),
    assert(current_player(OtherPlayer)),
    
    %sleep(1),
    game4(Board2).


%game4(Board):- CPU HARD VS CPU EASY
%    display_game(Board),
%    current_player(Player),
%    
%    make_hard_cpu_move(Board,Player,Board2),
%    other_player(Player,OtherPlayer),
%    retractall(current_player(_)),
%    assert(current_player(OtherPlayer)),
%    make_easy_cpu_move(Board2,OtherPlayer,Board3),
%    retractall(current_player(_)),
%    assert(current_player(Player)),
%    sleep(1),
%    game4(Board3).



