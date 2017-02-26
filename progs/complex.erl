-module(complex).
-export([operation/3]).

red({A,0,i}) -> 
    A;
red({A,B,i}) -> 
    {A,B,i}.
operation({F, S, i}, {F1, S1, i}, O) ->
   red({ op(F,O,F1), op(S, O, S1), i });
operation({F, S, i}, S2, O) ->
   red({F, op(S,O, S2), i});
operation(F, S, O) ->
   op(F, O, S).
op(S, add, S1) ->
   S + S1;
op(S, sub, S1) ->
   S - S1.
