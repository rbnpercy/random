%% Totally forgot about this, but I made it highly useful (for me, at least)
-spec format_time(non_neg_integer()) -> string().
format_time(Miliseconds) ->
  Sec = Miliseconds div 1000,
  Min = Sec div 60,
  Hour = Min div 60,
  Args = [Hour, Min rem 60, Sec rem 60, Miliseconds rem 1000],
  format("~bh~2.10.0bm~2.10.0bs~3.10.0b", Args).

-spec format_minimal_time(non_neg_integer()) -> string().
format_minimal_time(Miliseconds) ->
  Sec = Miliseconds div 1000,
  Min = Sec div 60,
  Hour = Min div 60,
  Parts = [{"", Miliseconds rem 1000}, {"s", Sec rem 60},
           {"m", Min rem 60}, {"h", Hour}],
  IoList = lists:foldl(fun
    ({_Postfix, 0}, Acc) -> Acc;
    ({Postfix, Value}, Acc) -> [integer_to_list(Value), Postfix | Acc]
  end, [], Parts),
  lists:flatten(IoList).
