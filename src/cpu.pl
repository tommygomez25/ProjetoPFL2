/*
game2(+Board)
Game loop for Player vs CPU in easy mode
*/
game2(Board) :-
    game_over(Board),!.


game2(Board):-

    display_game(Board),

    current_player(Player),

    get_coordinates(Player, X, Y),

    % Check if the chosen piece belongs to the current player
    (valid_piece(Board, X, Y) ->
        % If the piece belongs to the current player, continue with the game loop
        piece_at(Board, X, Y, Piece),

        (player(Board, Piece, Player),
        valid_jumper_moves(Board, Player,X, Y, Moves1)
        ;
        valid_slipper_moves(Board,Player, X, Y, Moves2)),

        write('Valid moves: '),
        (Moves1 \= [], print_moves(Moves1) ; Moves2 \= [], print_moves(Moves2); list_empty(Moves1,true),list_empty(Moves2,true),write('You chose a piece that has no valid moves!'),nl,game2(Board)),


        (Moves1 \= [], choose_move(Player, Moves1, NewRow, NewCol)
        ;
        Moves2 \= [], choose_move(Player,Moves2, NewRow, NewCol)),

        
        make_move(Board, Player, X, Y, NewRow, NewCol, Board2),

        other_player(Player, OtherPlayer),
        retractall(current_player(_)),
        assert(current_player(OtherPlayer)),

        choose_cpu_move(Board2,OtherPlayer,1,Board3),
        
        % Switch back to the other player
        other_player(OtherPlayer, Player),
        retractall(current_player(_)),
        assert(current_player(Player)),

        % Continue the game loop
        game2(Board3)
        ;
        % If the piece doesn't belong to the current player, prompt the user to choose another piece
        format('~nChoose a piece that belongs to you.~n', []),
        game2(Board)).
%-------------------------------------------------------------------------------------------------------%

/*
game3(+Board)
Game loop for Player vs CPU in hard mode
*/
game3(Board):-
    game_over(Board),!.

game3(Board):-

    display_game(Board),

    current_player(Player),

    get_coordinates(Player, X, Y),

    % Check if the chosen piece belongs to the current player
    (valid_piece(Board, X, Y) ->
        % If the piece belongs to the current player, continue with the game loop
        piece_at(Board, X, Y, _),

        valid_piece_moves(Board,Player,X,Y,Moves),

        write('Valid moves: '),
        (Moves \= [], print_moves(Moves) ;  list_empty(Moves,true),write('You chose a piece that has no valid moves!'),nl,game3(Board)),

        choose_move(Player, Moves, NewRow, NewCol),

        make_move(Board, Player, X, Y, NewRow, NewCol, Board2),

        % Switch to the CPU
        other_player(Player, OtherPlayer),
        retractall(current_player(_)),
        assert(current_player(OtherPlayer)),

        choose_cpu_move(Board2,OtherPlayer,2,Board3),


        retractall(current_player(_)),
        assert(current_player(Player)),

        % Continue the game loop
        game3(Board3)
        ;
        % If the piece doesn''t belong to the current player, prompt the user to choose another piece
        format('~nChoose a piece that belongs to you.~n', []),
        game3(Board)).


/*
Game loop for CPU Hard vs CPU Hard
*/
game8(Board):-
    game_over(Board),!.

game8(Board):- 
    display_game(Board),
    current_player(Player),
    
    choose_cpu_move(Board,Player,2,Board2),
    other_player(Player,OtherPlayer),
    retractall(current_player(_)),
    assert(current_player(OtherPlayer)),
    
    %sleep(1),
    game8(Board2).


/*
CPU HARD VS CPU EASY
*/
game4(Board) :-
    game_over(Board),!.

game4(Board):- 
    display_game(Board),
    current_player(Player),
    
    choose_cpu_move(Board,Player,2,Board2),
    other_player(Player,OtherPlayer),
    retractall(current_player(_)),
    assert(current_player(OtherPlayer)),
    choose_cpu_move(Board2,OtherPlayer,1,Board3),
    retractall(current_player(_)),
    assert(current_player(Player)),
    %sleep(1),
    game4(Board3).

/*
EASY vs EASY
*/
game5(Board) :-
    game_over(Board),!.
game5(Board):- 
    display_game(Board),
    current_player(Player),
    
    choose_cpu_move(Board,Player,1,Board2),
    other_player(Player,OtherPlayer),
    retractall(current_player(_)),
    assert(current_player(OtherPlayer)),
    choose_cpu_move(Board2,OtherPlayer,1,Board3),
    retractall(current_player(_)),
    assert(current_player(Player)),
    %sleep(1),
    game5(Board3).

/*
EASY vs Player
*/
game6(Board):-
    game_over(Board),!.

game6(Board):-

    current_player(Player),

    choose_cpu_move(Board,Player,1,Board2),


    % Switch to Player mode
    other_player(Player, OtherPlayer),
    retractall(current_player(_)),
    assert(current_player(OtherPlayer)),

    player_prompt(Board2,OtherPlayer,easy).

/*
HARD vs Player
*/
game7(Board):-
    game_over(Board),!.

game7(Board):-

    current_player(Player),

    choose_cpu_move(Board,Player,2,Board2),


    % Switch to Player mode
    other_player(Player, OtherPlayer),
    retractall(current_player(_)),
    assert(current_player(OtherPlayer)),

    player_prompt(Board2,OtherPlayer,hard).


player_prompt(Board,Player,easy) :-

    display_game(Board),

    get_coordinates(Player, X, Y),

    % Check if the chosen piece belongs to the current player
    (valid_piece(Board, X, Y) ->
        % If the piece belongs to the current player, continue with the game loop
        piece_at(Board, X, Y, _),

        
        (player(Board, _, Player),
            valid_jumper_moves(Board, Player,X, Y, Moves1)
            ;
            valid_slipper_moves(Board,Player, X, Y, Moves2)),

        write('Valid moves: '),
        (Moves1 \= [], print_moves(Moves1) ; Moves2 \= [], print_moves(Moves2); list_empty(Moves1,true),list_empty(Moves2,true),write('You chose a piece that has no valid moves!'),nl,player_prompt(Board,Player,easy)),


        (Moves1 \= [], choose_move(Player, Moves1, NewRow, NewCol)
        ;
        Moves2 \= [], choose_move(Player,Moves2, NewRow, NewCol)),

        make_move(Board, Player, X, Y, NewRow, NewCol, Board2),

        % Switch to the CPU
        other_player(Player, OtherPlayer),
        retractall(current_player(_)),
        assert(current_player(OtherPlayer)),

        % Continue the game loop
        game6(Board2)
        ;
        % If the piece doesn''t belong to the current player, prompt the user to choose another piece
        format('~nChoose a piece that belongs to you.~n', []),
        player_prompt(Board,Player,easy)).


player_prompt(Board,Player,hard) :-

    display_game(Board),

    get_coordinates(Player, X, Y),

    % Check if the chosen piece belongs to the current player
    (valid_piece(Board, X, Y) ->
        % If the piece belongs to the current player, continue with the game loop
        piece_at(Board, X, Y, _),

        
        (player(Board, _, Player),
            valid_jumper_moves(Board, Player,X, Y, Moves1)
            ;
            valid_slipper_moves(Board,Player, X, Y, Moves2)),

        write('Valid moves: '),
        (Moves1 \= [], print_moves(Moves1) ; Moves2 \= [], print_moves(Moves2); list_empty(Moves1,true),list_empty(Moves2,true),write('You chose a piece that has no valid moves!'),nl,player_promt(Board,Player,hard)),


        (Moves1 \= [], choose_move(Player, Moves1, NewRow, NewCol)
        ;
        Moves2 \= [], choose_move(Player,Moves2, NewRow, NewCol)),

        make_move(Board, Player, X, Y, NewRow, NewCol, Board2),

        % Switch to the CPU
        other_player(Player, OtherPlayer),
        retractall(current_player(_)),
        assert(current_player(OtherPlayer)),

        % Continue the game loop
        game6(Board2)
        ;
        % If the piece doesn''t belong to the current player, prompt the user to choose another piece
        format('~nChoose a piece that belongs to you.~n', []),
        player_prompt(Board,Player,hard)).

/*
choose_cpu_move(+Board,+Player,+Level,-NewBoard)
Makes a move for the CPU according to the Level. If level = 1 -> easy move , Level = 2 -> hard move
*/
choose_cpu_move(Board,Player,1,NewBoard) :-
    make_easy_cpu_move(Board,Player,NewBoard).

choose_cpu_move(Board,Player,2,NewBoard) :-
    make_hard_cpu_move(Board,Player,NewBoard).
/*
make_easy_cpu_move(+Board,+Player,-NewBoard)
Selects a random move from the current player available moves and return the new board state after the move
*/
make_easy_cpu_move(Board,Player,NewBoard) :-
    get_player_pieces(Board, Player, Pieces),

    random_member((OldRow, OldCol), Pieces),
    
    (player(Board, _, Player),
    valid_jumper_moves(Board, Player,OldRow, OldCol, Moves1)
    ;
    valid_slipper_moves(Board, Player,OldRow, OldCol, Moves2)),

    append(Moves1,Moves2,Moves),
    write('Moves CPU can chose from: '),
    print_moves(Moves),

    (list_empty(Moves,false) -> 

        random_member((NewRow, NewCol), Moves),

        make_move(Board, Player, OldRow, OldCol, NewRow, NewCol, NewBoard),!
        ;
        NewBoard=Board).

/*
value(+Board,+Player,-Value)
Predicate to evaluate the current board state.
*/
value(Board, Player, Value) :-
    % Find the number of moves available for the current player

    valid_moves(Board, Player, PlayerMoves),
    length(PlayerMoves, NumPlayerMoves),
    
    other_player(Player,OtherPlayer),

    % Find the number of moves and jumpers available for the other player

    valid_moves(Board, OtherPlayer, OtherPlayerMoves),
    count_jumpers(Board, OtherPlayer, NumJumpersOtherPlayer),
    length(OtherPlayerMoves, NumOtherPlayerMoves),

    Value is NumPlayerMoves - NumOtherPlayerMoves  - NumJumpersOtherPlayer * 2.

/*
get_best_moves(+Board,+Player,-BestMoves)
Returns a list of the best move of each piece of the current player
*/
get_best_moves(Board, Player, BestMoves) :-

    get_player_pieces(Board,Player,Pieces),
    get_best_move_for_all_pieces(Board, Player, Pieces,[], BestMoves).
/*
get_best_move_for_all_pieces(+Board,+Player,+Pieces,-Acc,-BestMoves)
Calculates the best move for each piece given in the Pieces variable
*/
get_best_move_for_all_pieces(_, _, [], Acc,Acc) :- !.
get_best_move_for_all_pieces(Board, Player, [(Row, Col)|RestPieces],Acc, BestMoves) :-

    (valid_jumper_moves(Board, Player, Row, Col, Moves);
    valid_slipper_moves(Board, Player, Row, Col, Moves)),

    get_best_move_for_piece(Board, Player, Row, Col, Moves, [], -9999, NewBestMove, NewBestValue),
    get_best_move_for_all_pieces(Board,Player,RestPieces,[(NewBestValue,NewBestMove)|Acc],BestMoves),!.

/*
get_best_move_for_piece(+Board,+Player,+Row,+Col,+Moves,+BestMove,+BestValueSoFar,-BestMoveOut,-BestValueOut)
Returns the best move and its respetive value for a specific piece
*/
get_best_move_for_piece(Board, Player, Row, Col,Moves, BestMove, BestValueSoFar, BestMoveOut,BestValueOut) :-
    % If the list of moves is empty, return the best move and value seen so far
    (Moves = [] -> BestMoveOut = BestMove , BestValueOut = BestValueSoFar;

     Moves = [(NewRow, NewCol)|RestMoves],
    
     make_move(Board, Player, Row, Col, NewRow, NewCol, Board2),

     value(Board2, Player, Value),


     (Value > BestValueSoFar -> NewBestMove = [(Row,Col),(NewRow, NewCol)], NewBestValue = Value ; NewBestMove = BestMove, NewBestValue = BestValueSoFar),
     
     get_best_move_for_piece(Board, Player, Row, Col, RestMoves,NewBestMove, NewBestValue, BestMoveOut,BestValueOut)
    ).
/*
choose_cpu_hard_move(+Moves,-OldRow,-OldCol,-NewRow,-NewCol)
Chooses the best move possible and returns the coordinates in the variables OldRow,OldCol,NewRow,NewCol
OldRow and OldCol are the coordinates of the piece that is going to move
NewRow and NewCol are the coordinates where the piece is going to move
*/
choose_cpu_hard_move(Moves, OldRow, OldCol, NewRow, NewCol):-
    filterMoves(Moves,FilteredMoves),
    random_member((_,[(OldRow,OldCol),(NewRow, NewCol)]), FilteredMoves).
    
    first_weight([(Weight, _)|_], Weight).

/*
filterMoves(+List,-FilteredList)
From a list with this form [(Weight,Move)] it returns only the ones with the best Weight 
*/
filterMoves(List, FilteredList):-
    quicksort(List,SortedList),
    first_weight(SortedList,MaxWeight),
    remove_non_max_weights(SortedList,MaxWeight,[],FilteredList).

/*
make_hard_cpu_move(+Board,+Player,-NewBoard)
Gets the best move and changes the board according to the move chosen
*/
make_hard_cpu_move(Board, Player, NewBoard) :-
    get_best_moves(Board, Player, BestMoves),
    (BestMoves = [(-9999,[])] ->
        NewBoard = Board
    ;
        choose_cpu_hard_move(BestMoves, OldRow, OldCol, NewRow, NewCol),
        make_move(Board, Player, OldRow, OldCol, NewRow, NewCol, NewBoard)
    ).
      

