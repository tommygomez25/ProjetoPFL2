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

symbol(red_j, 'R').
symbol(black_j,'B').
symbol(empty, '|').

game:-
    initBoard(Board),
    print_board(Board).
    

print_board(Board):-
    nl,
    write('     a  b  c  d  e  f  g  h  i  j'),nl,
    write('     |  |  |  |  |  |  |  |  |  |'),nl,
    print_board1(Board, 1).

print_board1([Head|Tail], Line):-
    Line >= 10,
    write(Line), write(' '),
    print_line(Head),
    nl,
    write('     |  |  |  |  |  |  |  |  |  |'),
    Line1 is Line + 1,
    nl,
    print_board1(Tail, Line1)
    ;
    Line < 10,
    write(Line), write('  '),
    print_line(Head),
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
    