# 枚举

swift 中枚举的值可以是字符串、字符类型，整形，浮点数

## 枚举语法

每个枚举都定义了一个全新的类型，名字以大写字母开头，以单数形式命名，而不是以复数形式。

```
enum SomeEnumeration {
  // 枚举的定义放在这里
}

enum CompassPoint {
    case north
    case south
    case east
    case west
}
```

枚举中定义的值是枚举的成员。

不像`C`和`Objective-C`, `Swift`的枚举成员在创建时不会被赋予一个默认的整型值。这些不同的枚举成员本身就是完备的值，类型为`CompassPoint`类型。

多个成员可以同时出现在同一行，用逗号隔开：

```
enum Planet {
    case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
}
```

## 使用 Switch 语句来匹配枚举值

```
var directionToHead = CompassPoint.west
switch directionToHead {
case .north:
    print("Lots of planets have a north")
case .south:
    print("Watch out for penguins")
case .east:
    print("Where the sun rises")
case .west:
    print("Where the skies are blue")
}
```

当不需要给每一个枚举中的情况都写一个`case`时，可以使用`default`

```
let somePlanet = Planet.earth
switch somePlanet {
case .earth:
    print("Mostly harmless")
default:
    print("Not a safe place for humans")
}
```

## 遍历枚举中的情况

枚举遵循`CaseIterable`协议,然后使用`allCases`这个属性，可以获取这个枚举中所有`case`的集合。

```
enum Beverage: CaseIterable {
    case coffee, tea, juice
}
let numberOfChoices = Beverage.allCases.count
print("\(numberOfChoices) beverages available")

for beverage in Beverage.allCases {
    print(beverage)
}
```

## 关联值

```
enum Barcode{
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}

var productBarcode = Barcode.upc(8, 85909, 51226, 3)
productBarcode = .qrCode("ABCDEFGHIJKLMNOP")

switch productBarcode {
case .upc(let numberSystem, let manufacturer, let product, let check):
    print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case .qrCode(let productCode):
    print("QR code: \(productCode).")
}
// 打印 "QR code: ABCDEFGHIJKLMNOP."

switch productBarcode {
case let .upc(numberSystem, manufacturer, product, check):
    print("UPC : \(numberSystem), \(manufacturer), \(product), \(check).")
case let .qrCode(productCode):
    print("QR code: \(productCode).")
}
// 打印 "QR code: ABCDEFGHIJKLMNOP."
```

## 原始值

原始值可以是字符串，字符，或者任意整型值或浮点型值。每个原始值在枚举声明中必须是唯一的。

```
enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}
```

## 原始值的隐形赋值

在使用原始值为整型值或者字符串类型的枚举时，不需要显式的给每一个枚举成员设置原始值，Swift 会自动赋值。

例如，如果使用整型值作为原始值，隐式赋值的值会依次递增 1.如果第一个枚举成员没有设置原始值，那么它的原始值就是 0。

```
enum Planet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}
```

当使用字符串作为原始值时，每个枚举成员的隐式初值是该成员的名称。

```
enum CompassPoint: String {
    case north, south, east, west
}
```

通过`rawValue`属性访问枚举的原始值

```
let earthsOrder = Planet.earth.rawValue
// earthsOrder 的值为 3

let sunsetDirection = CompassPoint.west.rawValue
// sunsetDirection 的值为 "west"
```

## 使用原始值初始化

如果使用原始值类型定义枚举，该枚举会自动获得一个初始化方法，该初始化方法接受原始值类型的值（作为名为 rawValue 的参数）并返回枚举成员或 nil 。你可以使用此初始化方法尝试创建枚举的新实例。

```
let possiblePlanet = Planet(rawValue: 7)
// possiblePlanet 是 Planet? 类型，并且等于 Planet.uranus
```

> ⚠️ 初始化返回的是可选类型，因为并非每个原始值都能返回对应的枚举成员。

```
let positionToFind = 11
if let somePlanet = Planet(rawValue: positionToFind) {
    switch somePlanet {
    case .earth:
        print("Mostly harmless")
    default:
        print("Not a safe place for humans")
    }
} else {
    print("There isn't a planet at position \(positionToFind)")
}
```

## 递归枚举

`递归枚举` 是枚举的一种，它允许将该枚举的其他实例，作为自己一个或多个枚举成员的关联值。 你可以通过在枚举成员之前加上 indirect 来表示枚举成员是递归的，它将告诉编译器插入必要的间接层。

```
enum ArithmeticExpression {
    case number(Int)
    indirect case addition(ArithmeticExpression, ArithmeticExpression)
    indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}
```

也可以在枚举的开头加入 `indirect`, 将所有具有关联值的枚举成员标示为可递归的。

```
indirect enum ArithmeticExpression {
    case number(Int)
    case addition(ArithmeticExpression, ArithmeticExpression)
    case multiplication(ArithmeticExpression, ArithmeticExpression)
}
```

此枚举可以存储三种算术表达式：普通数字、两个表达式的相加以及两个表达式的相乘。

`addition` 和 `multiplication` 枚举成员的相关值同时也是算术表达式 --- 这使得嵌套表达式成为可能。例如，表达式 (5 + 4) _ 2 在乘法的右侧有一个数字，在乘法的左侧有另一个表达式。 因为数据是嵌套的，用于存储数据的枚举也需要支持嵌套 --- 这意味着枚举需要是可递归的。 下面的代码展示了为 (5 + 4) _ 2 创建的 ArithmeticExpression 递归枚举：

```
let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))
```

递归函数是一种处理递归结构数据的简单方法。 例如，这是一个计算算术表达式的函数：

```
func evaluate(_ expression: ArithmeticExpression) -> Int {
    switch expression {
    case let .number(value):
        return value
    case let .addition(left, right):
        return evaluate(left) + evaluate(right)
    case let .multiplication(left, right):
        return evaluate(left) * evaluate(right)
    }
}

print(evaluate(product))
// 打印 "18"
```

当此函数遇到纯数字，直接返回相关值即可。 当此函数遇到加法或乘法，则分别计算符号左侧和右侧的表达式，然后将它们相加或相乘。
