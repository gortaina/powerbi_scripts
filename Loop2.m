NamedTables = List.Generate(
    () => [i=-1, table=#table({},{})],  // initialize loop variables
    each [i] < List.Count(Tables),
    each [
        i=[i]+1,
        table=Table.AddColumn(Tables{i}, "TableName", each Names{i})
    ],
    each [table]
),
