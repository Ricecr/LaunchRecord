# 发射记录

Web.Contents处理网页，

[发射记录]: http://www.spacechina.com/n25/n142/n152/n657792/	"发射记录"

将网页表格处理成本地 .xlsx 格式，有如下问题使用PowerQuery解决：

## 多页获取

通过定义一个函数，此处p代表页码；

```
fx = (p as number) as table =>
```

在url链接的页码位置使用以下内容代替。

```
"&(Number.ToText(p))&"
```

## 第七页有两个表格

使用if .. then .. else ..处理，即当页码符合存在两个表格这个条件时，先提升标题然后合并这一页的两个表格。

```
提升的标题 =
        if p = 7 then 
            Table.PromoteHeaders(源{0}[Data], [PromoteAllScalars=true])&Table.PromoteHeaders(源{1}[Data], [PromoteAllScalars=true])
        else 
            Table.PromoteHeaders(源{0}[Data], [PromoteAllScalars=true]),
```

## 第一页与其他页的列名不同

第一页第五列列名【发射地点】，其余页为【发射基地】，修改第一页第五列的列名为【发射基地】

```
更改的类型 = 
        if p = 1 then
            
            Table.RenameColumns(
                Table.TransformColumnTypes(提升的标题,{{"发射序号", Int64.Type}, {"运载火箭", type text}, {"发射日期", type date}, {"卫星", type text}, {"发射地点", type text}}),{{"发射地点", "发射基地"}})
        else 
            Table.TransformColumnTypes(提升的标题,{{"发射序号", Int64.Type}, {"运载火箭", type text}, {"发射日期", type date}, {"卫星", type text}, {"发射基地", type text}})
```

## 多余的换行符

【发射序号】296，295对应的【发射基地】存在换行符。

```
替换的值 = Table.ReplaceValue(结果,"#(cr)#(lf)","",Replacer.ReplaceText,{"发射基地"})
```

