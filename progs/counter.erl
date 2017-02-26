-module(counter).
-export([start/0,loop/1,increment/1,value/1,stop/1]).
%% First the interface functions.
start() ->
	spawn(counter, loop, [0]).
increment(Counter) ->
	Counter ! increment.
value(Counter) ->
	Counter ! {self(),value},
	receive
		{Counter,Value} ->
		Value
	end.
stop(Counter) ->
	Counter ! stop.

%% The counter loop.
loop(Val) ->
	receive
		increment ->
                        io:format("~w", [increment]),
			loop(Val + 1);
		{From,value} ->
                        io:format("~w", [[value,Val]]),
			From ! {self(),Val},
			loop(Val);
		stop ->
				% No recursive call here
			true;
		Other ->
				% All other messages
			loop(Val)
	end.
