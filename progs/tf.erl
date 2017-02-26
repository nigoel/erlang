-module(tf).
-export([stopSignals/0, startSignals/2, cancelfollowLeader/1, showTime/3, followLeader/3, greenTimer/3, yellowTimer/3]).

cancelfollowLeader(E) ->
  E ! {cancel}.

stopSignals() ->
  apply(cancelfollowLeader, registered()).

startSignals(Green, []) ->
  whereis(Green) ! { controller, youlead};

startSignals(Green, [{DirectionName, FollowerDir, N} | DirectionList]) ->
  register(DirectionName, spawn(tf, followLeader, [FollowerDir, DirectionName, N])),
  startSignals(Green, DirectionList).

showTime(DirectionName, Id, N) ->
  io:format("~w", [[DirectionName, Id, N]]).

followLeader(FollowerDir, DirectionName, N) ->
  receive 
	{_, youlead} ->
             greenTimer(DirectionName,FollowerDir,N),
             followLeader(FollowerDir, DirectionName, N);
        {Leader, _, beat, Time} ->
             showTime(DirectionName, red, Time),
             if 
                FollowerDir /= Leader ->
                  whereis(FollowerDir) ! { Leader, DirectionName, beat, N + Time};
                FollowerDir == Leader -> ok
             end,             
	     followLeader(FollowerDir, DirectionName, N);
        {cancel} ->
	      showTime(DirectionName, stop, 0)
  end.

greenTimer(DirectionName, FollowerDir, N)  ->
  receive
	after 1000 -> 
		showTime(DirectionName, green, N -1),
                whereis(FollowerDir) ! {DirectionName, DirectionName, beat, N -1},
                if 
                  N -1 > 5 ->
                      greenTimer(DirectionName, FollowerDir, N -1);
                  N -1 =< 5 ->
                      yellowTimer(DirectionName, FollowerDir, N -1)
                end        
  end.

yellowTimer(DirectionName, NextLeader, N) when N == 0 ->
   whereis(NextLeader) ! {DirectionName,  youlead};

yellowTimer(DirectionName, NextLeader, N) when N /= 0, N =< 5 ->
  receive
        after 1000 -> 
		showTime(DirectionName, yellow, N -1),
                whereis(NextLeader) ! {DirectionName, DirectionName, beat, N -1},
                yellowTimer(DirectionName, NextLeader, N -1)
  end.



