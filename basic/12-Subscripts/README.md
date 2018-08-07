# 下标 （感觉可以不用学，了解）

类，结构体，枚举可以定义下标，它提供了一种快捷方法访问集合，列表，和序列的成员元素。可以直接使用下标对值进行读写。

## 下标语法

使用下标, 让你可以通过在实例名称后面的方括号中写入一个或多个值来查询类的实例。

使用 `subscript` 关键词定义下标

```
subscript(index: Int) -> Int {
    get {
        // 在这里返回一个对应下标的值
    }
    set(newValue) {
        // 在这里执行对应的赋值操作
    }
}
```

## 例子

```
struct TimesTable {
    let multiplier: Int
    subscript(index: Int) -> Int {
        return multiplier * index
    }
}
let threeTimesTable = TimesTable(multiplier: 3)
print("six times three is \(threeTimesTable[6])")
// 输出 "six times three is 18"
```
