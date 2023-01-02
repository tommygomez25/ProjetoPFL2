initBoard([[empty, empty, empty, empty, empty, empty, empty, empty, red_jumper, empty],
             [empty, empty, empty, empty,empty,empty, empty, empty, empty, empty],
             [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
             [black, empty, empty, empty,empty, empty, empty, empty, empty,empty],
             [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
             [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
             [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
             [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
             [empty, empty, empty, empty, empty, empty, empty, empty, empty,empty],
             [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty]]).

initBoard1([[black, red_jumper, empty, empty, empty, empty, empty, empty, empty, empty],
                [empty, empty, empty, empty,empty,empty, empty, empty, empty, empty],
                [red_jumper, empty, empty, red_jumper, empty, empty, empty, empty, empty, empty],
                [empty, empty, empty, empty, empty, empty, empty, empty, empty,empty],
                [red_jumper, empty, empty, empty, empty, empty, empty, empty, empty, empty],
                [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
                [red_jumper, empty, empty, empty, empty, empty, empty, empty, empty, empty],
                [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
                [red_jumper, empty, empty, empty, empty, empty, empty, empty, empty,empty],
                [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty]]).
initBoard2([[empty, red_jumper, empty, empty, empty, empty, empty, empty, empty, black_jumper],
    [empty, empty, empty, empty,empty,empty, empty, empty, empty, empty],
    [red_jumper, empty, empty, red_jumper, empty, empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty, empty, empty, empty, empty,empty],
    [red_jumper, empty, empty, empty, empty, empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
    [red_jumper, empty, empty, empty, empty, empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
    [red_jumper, empty, empty, empty, empty, empty, empty, empty, empty,empty],
    [empty, empty, empty, empty, black, empty, empty, empty, empty, empty]]).

initBoard3(
    [[empty, empty, red_jumper, empty, empty, empty, empty, empty, empty, black_jumper],
    [empty, empty, empty, empty,empty,empty, empty, empty, empty, empty],
    [red_jumper, empty, empty, empty, empty, empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty, empty, empty, empty, empty,empty],
    [red_jumper, empty, empty, empty, empty, empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
    [red_jumper, empty, empty, empty, empty, empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
    [red_jumper, empty, empty, empty, empty, empty, empty, empty, empty,empty],
    [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty]]
    ).


symbol(red_jumper, 'R').
symbol(black_jumper,'B').
symbol(empty, '+').
symbol(red,'D').
symbol(black,'K').

print_letters(Size, Size).

print_letters(Index, Size):-
    Size >= Index,
    write('  '),
    Letter is Index + 97,
    put_code(Letter),
    Index1 is Index + 1,
    print_letters(Index1, Size).


print_header([Head|_]):-
    length(Head, S1),
    write('   '),
    print_letters(0, S1).

display_game(Board):-
    nl,
    print_header(Board),nl,
    nl,
    display_game1(Board, 1).

display_game1([[First|Rest]|[]], Line):-
    Line >= 10,
    write(Line), write(' '),
    symbol(First, S),
    format('  ~s', [S]),
    print_line(Rest),
    nl
    ;
    Line < 10,
    write(Line), write('  '),
    symbol(First, S),
    format('  ~s', [S]),
    print_line(Rest),
    nl.

display_game1([[First|Rest]|Tail], Line):-
    Line >= 10,
    write(Line), write(' '),
    symbol(First, S),
    format('  ~s', [S]),
    print_line(Rest),
    nl,
    write('     |  |  |  |  |  |  |  |  |  |'),
    Line1 is Line + 1,
    nl,
    display_game1(Tail, Line1)
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
    display_game1(Tail, Line1).

print_line([]).
print_line([Head|Tail]):-
    symbol(Head, S),
    format('--~s', [S]),
    print_line(Tail).
    
