# 扩展

`Extensions`：为已存在的类、结构体、枚举或者协议类型增添新的功能。与 OC `Categories`类似,但是`Extensions`并没有一个具体的命名。

`Extensions`可以做到：

- 添加计算实例属性和计算类型属性
- 定义实例方法和类方法
- 提供新的初始化方法
- 定义下标脚本
- 定义和使用新的嵌套类型
- 使现有类型符合协议

> ⚠️ Extensions 可以为类增添一个新的功能，但却不能重写之前已经存在的功能。

## Extension 语法

```
extension SomeType {
    //编写 SomeType 的新功能
}
```

## 扩展协议

一个 Extension 可以实现扩展现有类型去遵循一个或多个协议。为了保持协议的一致性，请你以在声明这个类或者结构体时的方式去声明这个协议名。

```
extension SomeType: SomeProtocol, AnotherProtocol {
    // 实现协议内容
}
```

> 如果你想为一个已经存在的类型的进行扩展并添加一个新的功能，那么这个功能将会被该类所有的实例使用，

## 扩展计算属性

`Extensions` 可以将计算实例属性与计算类型属性添加到现有类中去。

```
extension Double {
    var km: Double { return self * 1_000.0 }
    var m: Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}
let oneInch = 25.4.mm
print("One inch is \(oneInch) meters")
// Prints "One inch is 0.0254 meters"
let threeFeet = 3.ft
print("Three feet is \(threeFeet) meters")
// Prints "Three feet is 0.914399970739201 meters"
```

> ⚠️ Extensions 可以添加一个新的属性，但是他们不能存储这些属性，也不能为现有类型添加属性观察者。

## 扩展初始化方法

`Extensions` 可以给现有类型添加一个新的初始化构造器。

```
struct Size {
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
}
```

扩展后

```
extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}
```

```
let centerRect = Rect(center: Point(x: 4.0, y: 4.0),
                      size: Size(width: 3.0, height: 3.0))
```

## 扩展方法

扩展可以向已经存在的类型添加实例方法或类方法。

```
extension Int {
    func repetitions(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
}
```

扩展可变实例方法

```
extension Int {
    mutating func square() {
        self = self * self
    }
}
var someInt = 3
someInt.square()
// someInt 现在已经变成 9 了
```

## 扩展下标

`Extensions` 能够对已经存在的类型添加下标。

```
extension Int {
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}
746381295[0]
// 返回 5
746381295[1]
// 返回 9
746381295[2]
// 返回 2
746381295[8]
// 返回 7
```

## 扩展嵌套类型

`Extensions`可以向任何已经存在的类、结构体或枚举添加新的嵌套类型。

```
extension Int {
    // 嵌套类型
    enum Kind {
        case negative, zero, positive
    }
    // 计算属性
    var kind: Kind {
        switch self {
        case 0:
            return .zero
        case let x where x > 0:
            return .positive
        default:
            return .negative
        }
    }
}
```

```
func printIntegerKinds(_ numbers: [Int]) {
    for number in numbers {
        switch number.kind {
        case .negative:
            print("- ", terminator: "")
        case .zero:
            print("0 ", terminator: "")
        case .positive:
            print("+ ", terminator: "")
        }
    }
    print("")
}
printIntegerKinds([3, 19, -27, 0, -6, 0, 7])
// Prints "+ + - 0 - 0 + "
```

> 因为 number.kind 已经定义在 Int.Kind 扩展中，所以我们可以在 switch 分支语句中直接使用，出于简洁性考虑，对比 Int.Kind.negative 这种写法，.negative 会显得更 Swift。
