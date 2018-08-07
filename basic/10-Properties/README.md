# 属性

属性可以将值与特定的类，结构体，枚举相关联。

- 存储属性： 将常量或变量值存储为实例的一部分。 适用于类、结构体 
- 计算属性： 通过计算得到一个值。适用于类、结构体、枚举
- 类型属性： 属性与类型本身相关联

## 存储属性

存储属性是存储在类或结构体中的常量或变量。

- 可以在定义存储属性时提供默认值
- 也可以在始化期间设置和修改存储属性的初始值

```
struct FixedLengthRange1 {
    var firstValue: Int = 1
    let length: Int = 2
}

struct FixedLengthRange2 {
    var firstValue: Int
    let length: Int
}
var rangeOfThreeItems = FixedLengthRange1(firstValue: 0, length: 3)
// 该整数范围表示整数值 0、1 和 2
rangeOfThreeItems.firstValue = 6
// 该整数范围现在表示整数值 6、7 和 8
```

`FixedLengthRange` 的实例有一个名为 `firstValue` 的变量存储属性和一个名为 `length` 的常量存储属性。在上面的示例中，`length` 在创建新实例时被初始化，之后无法更改，因为它是常量属性。

### 常量结构体实例的存储属性

如果创建结构体实例并将该实例声明为常量，则无法修改实例的属性，即使它们被声明为变量属性：

```
let rangeOfFourItems = FixedLengthRange(firstValue: 0, length: 4)
// 此整数范围表示整数值 0、1、2 和 3
rangeOfFourItems.firstValue = 6
// 这行代码会报错，即使 firstValue 是一个变量属性
```

这种行为是由于结构体是`值类型` 。当`值类型`的实例声明为常量时，其所有属性也都会被标记为`常量`。

### 延迟存储属性

`延迟存储属性`的初始值直到第一次使用时才进行计算，可以通过`lazy`修饰符来表示一个延迟存储属性。

>  必须将延迟存储属性声明为变量`var`,因为延迟属性的初始值可能在实例初始化完成之后，仍然没有被赋值。而常量属性必须在实例初始化完成 之前 就获得一个值，因此不能声明为延迟。<br>
> 如果被`lazy`修饰符所标记的属性，同时被多个线程访问，并且该属性尚未被初始化，则无法保证该属性仅被初始化一次。

延迟存储属性适用于下面的场景：

-  属性的初始值依赖于外部元素时。

```
class DataImporter {
    /*
    DataImporter 是一个从外部文件导入数据的类。
     假设该类需要花费大量时间来初始化。
    */
    var filename = "data.txt"
    // DataImporter 类将在此处提供数据导入功能
}

class DataManager {
    lazy var importer = DataImporter()
    var data = [String]()
    // DataManager 类将在此处提供数据管理功能
}

let manager = DataManager()
manager.data.append("Some data")
manager.data.append("Some more data")
// 类型为 DataImporter 的 importer 属性实例尚未创建
```

### 存储属性和实例变量

- Objective-C 包含存储属性和实例变量。
- swift 将这些概念统一到一个属性声明中。swift 属性没有实例变量。

## 计算属性

除了存储属性之外，类、结构体和枚举还可以定义 计算属性 ，它们实际上并不存储值。相反，它们会提供了一个 getter 方法和一个可选的 setter 方法来间接读取和设置其他属性和值。

```
struct Point {
    var x = 0.0, y = 0.0
}
struct Size {
    var width = 0.0, height = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    // center为计算属性
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set(newCenter) {
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
}
var square = Rect(origin: Point(x: 0.0, y: 0.0),
                  size: Size(width: 10.0, height: 10.0))
let initialSquareCenter = square.center
square.center = Point(x: 15.0, y: 15.0)
print("square.origin is now at (\(square.origin.x), \(square.origin.y))")
// 打印 "square.origin is now at (10.0, 10.0)"
```

### setter 声明的速记符号

如果没有为 setter 方法设置新值定义名称，则默认为`newValue`

```
struct AlternativeRect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set {
            origin.x = newValue.x - (size.width / 2)
            origin.y = newValue.y - (size.height / 2)
        }
    }
}
```

### 只读计算属性

只有 `getter` 方法但没有 `setter`方法的计算属性称为 只读计算属性 。只读计算属性始终返回一个值，可以通过点语法访问，但不能给它赋值

```
struct AlternativeRect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
    }
}
```

> 必须使用`var` 关键字来声明计算属性（包括只读计算属性），这是因为它们的值是不固定。`let` 关键字仅用于常量属性，这种属性一旦被初始化以后，就不能再更改它们的值。

可以删除 `get` 关键字以及大括号简化只读计算属性的声明：

```
struct AlternativeRect {
    var origin = Point()
    var size = Size()
    var center: Point {
        let centerX = origin.x + (size.width / 2)
        let centerY = origin.y + (size.height / 2)
        return Point(x: centerX, y: centerY)
    }
}
```

## 属性观察器

属性观察器会观察并对属性值的变化做出反应。每次设置属性值时都会调用属性观察器，即使新值与属性当前的值相同。

 可以将属性观察器添加到任何存储属性上，但是延迟属性除外。你还可以通过在子类中重写属性来为任何继承的属性（无论是存储还是计算）添加属性观察器。你并不需要为非重写的计算属性定义属性观察器，因为你可以在计算属性的 setter 方法中观察并响应其值的更改。 -> 还不理解

如何定义观察器：

- 在存储值之前调用`willSet`
- 存储新值后立即调用`didSet`

如果实现 `willSet` 观察器，它会将新属性值作为常量参数传递。你可以在 `willSet` 实现中指定此参数的名称。如果不在实现中指定参数名称，则使用默认参数名称 `newValue` 。

类似地，如果你实现一个 `didSet` 观察器，它会传递一个包含旧属性值的常量参数。你可以指定参数名称或使用默认参数名称 `oldValue`。如果你在自己的 `didSet` 属性观察器里给自己赋值，那么你赋值的新值将会替代刚刚设置的值。

> 在调用父类初始化方法之后，在子类中给父类属性赋值时，将会调用父类属性的 willSet 和 didSet 观察器。如果在调用父类初始化方法之前，在子类中给父类属性赋值，则不会调用父类的观察器。

```
class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print("将要设置 totalSteps 为 \(newTotalSteps)")
        }
        didSet {
            if totalSteps > oldValue  {
                print("增加了 \(totalSteps - oldValue) 步")
            }
        }
    }
}
let stepCounter = StepCounter()
stepCounter.totalSteps = 200
```

## 全局和局部变量

全局变量：在任何函数，方法，闭包，或类型上下文之外定义的变量。
局部变量：在函数，方法，或闭包上下文中定义的变量。

> 全局常量和变量总是被延迟计算，与 `延迟存储属性` 类似。与延迟存储属性不同的是，全局常量和变量不需要使用 lazy 修饰符进行标记。<br>
> 局部常量和变量永远不会被延迟计算。

## 类型属性

```
struct SomeStructure {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 1
    }
}
enum SomeEnumeration {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 6
    }
}
class SomeClass {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 27
    }
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
}
```
