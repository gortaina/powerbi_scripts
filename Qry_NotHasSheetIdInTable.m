(SheetId, TableName) => 
let
    Fonte = Excel.CurrentWorkbook(){[Name=TableName]}[Content],
    #"Colunas Filtro"    = Table.SelectRows(Fonte, each [SHEET] = SheetId),
  //  #"Colunas Filtro2"   = Table.First(#"Colunas Filtro")
    #"Colunas Filtro3"   =  if(Table.IsEmpty(#"Colunas Filtro")) then false else true
   
in
    #"Colunas Filtro3"
