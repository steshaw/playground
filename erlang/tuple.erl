-module(tuple).

-export([fst/1, snd/1]).

fst({X, _}) -> X.

snd({_, Y}) -> Y.
