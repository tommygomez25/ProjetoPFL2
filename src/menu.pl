menu :-
    displayMenu,
    write('> Choose an option'),
    nl,
    repeat,
    get_code(Input),
    manageInput(Input).

clear :- write('\33\[2J').

goToMenu(Input) :-
    write('\nPress [0] to go back to MAIN MENU.\n\n'),
    get_code(Input),
    travelBack(Input).

travelBack(48) :-
    menu.

manageInput(48) :-
    write('\n> Exiting SKI JUMPS').

manageInput(49) :-
    clear,
    write('Starting Player vs Player game\n').
    %...

manageInput(50) :-
    clear,
    write('Starting Player vs CPU game in EASY MODE\n').
    %...

manageInput(51) :-
    clear,
    write('Starting Player vs CPU game in NORMAL MODE\n').
    %...

manageInput(52) :-
    clear,
    write('Starting CPU vs CPU game\n').
    %...

displayMenu :-
    nl,nl,clear,
    write(' _______________________________________________________ '),nl,
    write('|                                                       |'),nl,
    write('|                  [1]  P  vs  P                        |'),nl,
    write('|                  [2]  P  vs CPU (Very Easy)           |'),nl,
    write('|                  [3]  P  vs CPU (Normal)              |'),nl,
    write('|                  [4]  CPU vs CPU                      |'),nl,
    write('|                  [0]  Exit                            |'),nl,
    write('|_______________________________________________________|'),nl,nl.