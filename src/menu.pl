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
    write('Starting Player vs Player game\n'),
    initBoard(Board),
    retractall(current_player(_)),
    assert(current_player(red)),
    game1(Board).

manageInput(50) :-
    clear,
    write('Choose the CPU level (1 - easy ; 2 - normal):'),nl,repeat,
    get_code(Input),
    manageInputLevelPlayerCPU(Input).

manageInput(51) :-
    clear,
    write('Choose the CPU level (1 - easy ; 2 - normal):'),nl,repeat,
    get_code(Input),
    manageInputLevelCPUPlayer(Input).

manageInput(52) :-
    clear,
    write('Choose CPU levels (1- EASY vs EASY ; 2 - EASY vs HARD ; 3 - HARD vs HARD\n'),nl,repeat,
    get_code(Input),
    manageInputLevelCPUCPU(Input).

manageInputLevelPlayerCPU(49) :-
    write('Starting Player vs CPU in EASY MODE'),nl,
    initBoard(Board),
    retractall(current_player(_)),
    assert(current_player(red)),
    display_game(Board),
    game2(Board).

manageInputLevelPlayerCPU(50) :-
    write('Starting Player vs CPU in HARD MODE'),nl,
    initBoard(Board),
    retractall(current_player(_)),
    assert(current_player(red)),
    display_game(Board),
    game3(Board).

manageInputLevelCPUPlayer(49) :-
    write('Starting CPU vs Player in EASY MODE'),nl,
    initBoard(Board),
    retractall(current_player(_)),
    assert(current_player(red)),
    game6(Board).

manageInputLevelCPUPlayer(50) :-
    write('Starting CPU vs Player in HARD MODE'),nl,
    initBoard(Board),
    retractall(current_player(_)),
    assert(current_player(red)),
    game5(Board).

manageInputLevelCPUCPU(49) :-
    write('Starting EASY CPU vs EASY CPU MODE'),nl,
    initBoard(Board),
    retractall(current_player(_)),
    assert(current_player(red)),
    game5(Board).

manageInputLevelCPUCPU(50) :-
    write('Starting EASY CPU vs HARD CPU MODE'),nl,
    initBoard(Board),
    retractall(current_player(_)),
    assert(current_player(red)),
    game4(Board).

manageInputLevelCPUCPU(51) :-
    write('Starting HARD CPU vs HARD CPU MODE'),nl,
    initBoard(Board),
    retractall(current_player(_)),
    assert(current_player(red)),
    game8(Board).

displayMenu :-
    nl,nl,clear,
    write(' _______________________________________________________ '),nl,
    write('|                                                       |'),nl,
    write('|                  [1]  P  vs  P                        |'),nl,
    write('|                  [2]  P  vs CPU                       |'),nl,
    write('|                  [3]  CPU  vs P                       |'),nl,
    write('|                  [4]  CPU vs CPU                      |'),nl,
    write('|                  [0]  Exit                            |'),nl,
    write('|_______________________________________________________|'),nl,nl.
