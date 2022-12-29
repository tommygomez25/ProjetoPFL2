:- consult('menu.pl').
:- consult('table.pl').
:- consult('utils.pl').
:- consult('game.pl').
:- consult('moves.pl').
:- use_module(library(lists)).
:- use_module(library(readutil)).

play :-
    menu.
