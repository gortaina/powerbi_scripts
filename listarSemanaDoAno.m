let
    Source = (dataInicio, dataFim) =>
let
    semana1 = Date.WeekOfYear(dataInicio),
    semana2 = Date.WeekOfYear(dataFim),
    //Teste
    //semana1 = Date.WeekOfYear(#date(2020,05,29)),
    //semana2 = Date.WeekOfYear(#date(2020,07,12)),
    listaSemanaDoAno = List.Alternate({semana1..semana2}, 0)
in
    listaSemanaDoAno
in
    Source
