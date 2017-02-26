-module(quickSort).
-export([qSort/1,partition/2]).

partition(E, []) -> 
   {[],[]};
partition(E, [H|T]) ->
   {L1,L2} = partition(E,T),
   if 
      H < E ->
        {[H|L1],L2};
      H >= E ->
        {L1, [H|L2]}
   end.
qSort([]) -> 
   [];
qSort([H|T]) ->
   {L1,L2} = partition(H, T),
   lists:append(qSort(L1), [H|qSort(L2)]).
