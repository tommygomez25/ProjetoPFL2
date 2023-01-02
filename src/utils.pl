list_empty([], true).
list_empty([_|_], false).

/*
piece_at(+Board,+Row,+Col,?Piece)
Returns the piece at the given Row and Col in the Board
*/
piece_at(Board,Row, Col, Piece) :-
  nth1(Row, Board, RowList),
  nth1(Col, RowList, Piece).

/*
valid_position(+NumRows,+NumCols,+Row,+Col)
Checks if a given coordenate (Row,Col) is within the board borders
*/
valid_position(NumRows, NumCols, Row, Col) :-
  Row >= 0,
  Row < NumRows,
  Col >= 0,
  Col < NumCols.

letter_to_number(x,0).
letter_to_number(a,1).
letter_to_number(b,2).
letter_to_number(c,3).
letter_to_number(d,4).
letter_to_number(e,5).
letter_to_number(f,6).
letter_to_number(g,7).
letter_to_number(h,8).
letter_to_number(i,9).
letter_to_number(j,10).
letter_to_number(z,11).

/*
get_coordinates(+Player,-X,-Y) 
Prompts the user to choose the coordinates of the piece it wishes to move */
get_coordinates(Player,X, Y) :-
  repeat,
  format('Player ~w, enter the coordinates of the piece you wish to move: ',[Player]),
  %Read a string from the current input
  %read_line_to_string(current_input, InputString),
  %Split the string with " " as delimiter
  %split_string(InputString, " ", "", [XString, YString]),
  write('Row [1-10]: '),
  read(X), 
  write('Column [a-j]: '),
  read(Col),
  letter_to_number(Col,Y).

/*
get_player_pieces(+Board,+Player,-Pieces)
Returns a list of the available pieces of the given Player in the current Board state
*/
get_player_pieces(Board,Player,Pieces):-
  setof((Row, Col), (member(Row, [1,2,3,4,5,6,7,8,9,10]), member(Col, [1,2,3,4,5,6,7,8,9,10]), belongs_to_player(Board, Row, Col, Player)), Pieces).

/*
valid_piece(+Board,+X,+Y)
Checks if a piece in the coordinates (X,Y) is valid and if it is from the current player that chose it 
*/
valid_piece(Board,X,Y) :-

  valid_position(12,12,X,Y),

  piece_at(Board,X, Y, Piece),
  % Check if the piece belongs to the current player
  current_player(Player),
  player(Board,Piece, Player).

/*
player(+Board,+Piece,+Player)
Check if the given piece belongs to the given player
*/
player(Board,Piece, red) :-
  piece_at(Board,_, _, Piece),
  Piece \= empty,
  Piece \= black_jumper,
  Piece \= black.

player(Board,Piece, black) :-
  piece_at(Board,_, _, Piece),
  Piece \= empty,
  Piece \= red_jumper,
  Piece \= red.

% Helper predicate to check if a piece belongs to a player
belongs_to_player(Board, Row, Col, Player) :-
  piece_at(Board, Row, Col, Piece),
  player(Board, Piece, Player).

/*
print_moves(+Moves)
Prints the moves in the form (X,Y)
*/
print_moves([]).
print_moves([(X,Col)|T]) :-
  letter_to_number(Y,Col),
  write(' ('), write(X), write(','),write(Y),write(') '),
  print_moves(T).

/*
replace_board_value(+Board,+Row,+Col,+Value,-NewBoard)
Replace a value in the board
*/
replace_board_value([Head|Tail],1,Column,Value,[NewHead|Tail]) :-
  replace_board_value_row(Head,Column,Value,NewHead).

replace_board_value([Head|Tail],Row,Column,Value,[Head|NewTail]) :-
  Row > 1,
  Row1 is Row - 1,
  replace_board_value(Tail,Row1,Column,Value,NewTail).

/*
replace_board_value_row(+Board,+Column,+Value,-NewBoard)
Helper predicate to replace a value in the board
*/
replace_board_value_row([_|Tail],1,Value,[Value|Tail]).

replace_board_value_row([Head|Tail],Column,Value,[Head|NewTail]) :-
    Column > 1,
    Column1 is Column - 1,
    replace_board_value_row(Tail,Column1,Value,NewTail).

/*
quicksort(+Moves,-SortedMoves)
Quick sort algorithm implementation to sort a list of Moves in the form (Weight,[(OldRow,OldCol),(NewRow,NewCol)]) by descending order of Weight
*/
quicksort([], []).
quicksort([(Weight, Value)|Tail], SortedList) :-
    split(Tail, (Weight, Value), Left, Right),
    quicksort(Left, SortedLeft),
    quicksort(Right, SortedRight),
    append(SortedRight, [(Weight, Value)|SortedLeft], SortedList).

% Helper predicate to QuickSorte algorithm
split([], _, [], []).
split([(Weight, Value)|Tail], (PivotWeight, PivotValue), [(Weight, Value)|Left], Right) :-
    Weight @=< PivotWeight,
    split(Tail, (PivotWeight, PivotValue), Left, Right).
split([(Weight, Value)|Tail], (PivotWeight, PivotValue), Left, [(Weight, Value)|Right]) :-
    Weight @> PivotWeight,
    split(Tail, (PivotWeight, PivotValue), Left, Right).

/*
remove_non_max_weights(+Moves,+MaxWeight,+Acc,-FilteredMoves)
*/
remove_non_max_weights([], _, Result, Result).
remove_non_max_weights([(Weight, Value)|Tail], MaxWeight, Acc, Result) :-
    Weight =:= MaxWeight,
    remove_non_max_weights(Tail,MaxWeight,[(Weight,Value)|Acc],Result).

remove_non_max_weights([(Weight, _)|Tail], MaxWeight, Acc, Result) :-
    Weight @< MaxWeight,
    remove_non_max_weights(Tail,MaxWeight,Acc,Result).

/*
count_jumpers(+Board,+Player,-Count)
Returns the jumpers count of a given Player in the current Board state
*/
count_jumpers(Board,Player,Count):-
  setof((Row, Col), (member(Row, [1,2,3,4,5,6,7,8,9,10]), member(Col, [1,2,3,4,5,6,7,8,9,10]), belongs_to_player(Board, Row, Col, Player), piece_at(Board,Row,Col,Piece), is_jumper(Piece)), Pieces),
  length(Pieces, Count),!.

count_jumpers(_, _, 0).


is_jumper(red_jumper).
is_jumper(black_jumper).