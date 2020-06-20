let
    data = List.Generate(
        () => [x=-10, y=100],
        each [x]<=10,
        each [x=[x]+1, y=x*x]
    ),
    output = Table.FromRecords(data)
in output
