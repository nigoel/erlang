-module(sort1).
-export([sort/1]).

insert(E,[]) ->
     [E];
insert(E,[H|T]) when E < H -> 
     [E,H|T];
insert(E, [H|T]) when E > H ->
     [H|insert(E,T)].
sort([]) ->
     [];
sort([First]) ->
     [First];
sort([First | Other]) ->
     insert(First, sort(Other)).
