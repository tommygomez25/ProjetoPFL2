:- consult('menu.pl').
:- consult('table.pl').
:- consult('utils.pl').
:- consult('game.pl').
:- consult('moves.pl').
:- consult('cpu.pl').
:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(system)).


play :-
    menu.
