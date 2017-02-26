-module(msg).
-export([start/0, add/2, sendMsg/4, listner/1]).
-import(maps, [new/0, put/3, get/3]).

listner(User) ->
   receive
      {From, Msg} -> 
           io:format("~p", [["Message From:", From, " ", Msg]]),
      listner(User)
   end.

start() ->
  maps:new().
add(User, Index) -> 
  maps:put(User, spawn(msg, listner, [User]), Index).

sendMsg(From, To, Index, Msg) ->
   maps:get(To, Index, -1) ! {From,Msg}.
