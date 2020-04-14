let

fx = (p as number) as table =>
 
    let
        源 = Web.Page(Web.Contents("http://www.spacechina.com/n25/n142/n152/n657792/c659355/content_"&(Number.ToText(p))&".html")),
        提升的标题 =
        if p = 7 then 
            Table.PromoteHeaders(源{0}[Data], [PromoteAllScalars=true])&Table.PromoteHeaders(源{1}[Data], [PromoteAllScalars=true])
        else 
            Table.PromoteHeaders(源{0}[Data], [PromoteAllScalars=true]),
        
        更改的类型 = 
        if p = 1 then
            
            Table.RenameColumns(
                Table.TransformColumnTypes(提升的标题,{{"发射序号", Int64.Type}, {"运载火箭", type text}, {"发射日期", type date}, {"卫星", type text}, {"发射地点", type text}}),{{"发射地点", "发射基地"}})
        else 
            Table.TransformColumnTypes(提升的标题,{{"发射序号", Int64.Type}, {"运载火箭", type text}, {"发射日期", type date}, {"卫星", type text}, {"发射基地", type text}})
    in
        更改的类型,

    结果 = Table.Combine(List.Transform({1..11},fx)),
    替换的值 = Table.ReplaceValue(结果,"#(cr)#(lf)","",Replacer.ReplaceText,{"发射基地"})
in
    替换的值