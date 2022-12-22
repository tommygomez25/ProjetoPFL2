initBoard([[red_j, empty, empty, empty, empty, empty, empty, empty, empty, empty],
             [empty, empty, empty, empty, empty, empty, empty, empty, empty, black_j],
             [red_j, empty, empty, empty, empty, empty, empty, empty, empty, empty],
             [empty, empty, empty, empty, empty, empty, empty, empty, empty, black_j],
             [red_j, empty, empty, empty, empty, empty, empty, empty, empty, empty],
             [empty, empty, empty, empty, empty, empty, empty, empty, empty, black_j],
             [red_j, empty, empty, empty, empty, empty, empty, empty, empty, empty],
             [empty, empty, empty, empty, empty, empty, empty, empty, empty, black_j],
             [red_j, empty, empty, empty, empty, empty, empty, empty, empty, empty],
             [empty, empty, empty, empty, empty, empty, empty, empty, empty, black_j]]).

%piece(X, Y, type).
piece(0,0, red_j). piece(9,1, black_j).
piece(0,2, red_j). piece(9,3, black_j).
piece(0,4, red_j). piece(9,5, black_j).
piece(0,6, red_j). piece(9,7, black_j).
piece(0,8, red_j). piece(9,9, black_j).

symbol(red_j, 'R').
symbol(black_j,'B').
symbol(empty, '|').

game:-
    initBoard(Board),
    print_board(Board).

%generate_board(-Board)
generate_board(Board):-
    


print_letters(Size, Size).

print_letters(Index, Size):-
    Size >= Index,
    write('  '),
    Letter is Index + 65,
    put_code(Letter),
    Index1 is Index + 1,
    print_letters(Index1, Size).


print_header([Head|_]):-
    length(Head, S1),
    write('   '),
    print_letters(0, S1).

print_board(Board):-
    nl,
    print_header(Board),nl,
    nl,
    print_board1(Board, 1).

print_board1([[First|Rest]|[]], Line):-
    Line >= 10,
    write(Line), write(' '),
    symbol(First, S),
    format('  ~s', [S]),
    print_line(Rest),
    Line1 is Line + 1,
    nl
    ;
    Line < 10,
    write(Line), write('  '),
    symbol(First, S),
    format('  ~s', [S]),
    print_line(Rest),
    Line1 is Line + 1,
    nl.

print_board1([[First|Rest]|Tail], Line):-
    Line >= 10,
    write(Line), write(' '),
    symbol(First, S),
    format('  ~s', [S]),
    print_line(Rest),
    nl,
    write('     |  |  |  |  |  |  |  |  |  |'),
    Line1 is Line + 1,
    nl,
    print_board1(Tail, Line1)
    ;
    Line < 10,
    write(Line), write('  '),
    symbol(First, S),
    format('  ~s', [S]),
    print_line(Rest),
    nl,
    write('     |  |  |  |  |  |  |  |  |  |'),
    Line1 is Line + 1,
    nl,
    print_board1(Tail, Line1).

print_line([]).
print_line([Head|Tail]):-
    symbol(Head, S),
    format('--~s', [S]),
    print_line(Tail).
    