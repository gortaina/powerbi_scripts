(tbl as table, reorderedColumns as list, offset as number, excludeColumns as list) as table =>
let
    removido = List.RemoveItems(reorderedColumns, excludeColumns),
    QTDremovido = List.Count(removido),
    Textremovido = Text.From(QTDremovido),
    a=if(Table.HasColumns(tbl, reorderedColumns))
        then
          Table.ReorderColumns
          (
            tbl,
            List.InsertRange
            (
              List.Difference
                (
                  Table.ColumnNames(tbl),
                  reorderedColumns
                ),
              offset,
              reorderedColumns
            )
        )
        else
        (  
          Table.ReorderColumns
            (
              tbl,
              List.InsertRange
              (
                List.Difference
                  (
                    Table.ColumnNames(tbl),
                    (List.InsertRange(removido,QTDremovido-1,{"Column"&Textremovido}))
                  ),
                offset,
                (List.InsertRange(removido,QTDremovido-1,{"Column"&Textremovido}))
              )
            )
        ),
     b=Table.DemoteHeaders(a)
in
  b
