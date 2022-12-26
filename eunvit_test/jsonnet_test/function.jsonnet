local map(func, arr) =
    if std.length(arr) == 0 then
        []
    else
        [func(arr[0])] + map(func, arr[1:])
    ;


map(function(i) i * 3, [0, 4, 20])