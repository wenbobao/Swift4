# 方法

方法是与特定类型相关联的函数。类，结构体，枚举都可以定义方法。

- 实例方法：在类型的实例上被调用的方法
- 类型方法：在类型本身上定义方法

## 实例方法

实例方法是属于特定类，结构体，枚举实例的函数。可以在其所属类型的开始和结束括号内编写实例方法。

```
class Counter {
    var count = 0
    func increment() {
        count += 1
    }
    func increment(by amount: Int) {
        count += amount
    }
    func reset() {
        count = 0
    }
}
```

### self 属性

 类型的每个实例默认有一个`self`的隐式属性，可以不写。

```
func increment() {
    self.count += 1
}
```

但是当实例方法的参数名称与该实例的属性名称相同时，就会发生命名冲突。在这种情况下，必须写`self`以区分参数名称和属性名称。

```
struct Point {
    var x = 0.0, y = 0.0
    func isToTheRightOf(x: Double) -> Bool {
        return self.x > x
    }
}
let somePoint = Point(x: 4.0, y: 5.0)
if somePoint.isToTheRightOf(x: 1.0) {
    print("This point is to the right of the line where x == 1.0")
}
// 打印 "This point is to the right of the line where x == 1.0"
```

### 在实例方法中修改值类型

结构体和枚举是值类型。默认情况下无法在其实例方法中修改值类型的属性。

如果需要修改，就需要将方法异变(mutating)。然后该方法就可以异变其属性，当方法结束时，它所做的任何更改都将写回原始的结构体中。

```
struct Point {
    var x = 0.0, y = 0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        x += deltaX
        y += deltaY
    }
}
var somePoint = Point(x: 1.0, y: 1.0)
somePoint.moveBy(x: 2.0, y: 3.0)
print("The point is now at (\(somePoint.x), \(somePoint.y))")
// 打印 "The point is now at (3.0, 4.0)"
```

### 在可变方法中给 self 赋值

`mutating`方法还可以为隐式的`self`属性分配一个全新的实例，并且该实例方法将在方法结束时替换现有实例。

```
struct Point {
    var x = 0.0, y = 0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        self = Point(x: x + deltaX, y: y + deltaY)
    }
}
```

枚举的可变方法可以将隐性的`self`参数设置成同一枚举类型中的不同成员。

```
enum TriStateSwitch {
    case off, low, high
    mutating func next() {
        switch self {
        case .off:
            self = .low
        case .low:
            self = .high
        case .high:
            self = .off
        }
    }
}
var ovenLight = TriStateSwitch.low
ovenLight.next()
// ovenLight 现在等于 .high
ovenLight.next()
// ovenLight 现在等于 .off
```

## 类型方法

- 在方法前面加上 `static`关键词。
- 在类中，也可以用 `class` 关键词 来声明一个类型方法。

区别：用 `class` 关键词声明的类型方法允许它的子类重写其父类对类型方法的实现。

```
class SomeClass {
    class func someTypeMethod() {
            // 这里是类型方法的实现细节
    }
}
SomeClass.someTypeMethod()
```

```
struct LevelTracker {
    static var highestUnlockedLevel = 1 //类型属性
    var currentLevel = 1 // 实例属性

    static func unlock(_ level: Int) {
        if level > highestUnlockedLevel { highestUnlockedLevel = level }
    } // 类型方法

    static func isUnlocked(_ level: Int) -> Bool {
        return level <= highestUnlockedLevel
    } // 类型方法

    @discardableResult
    mutating func advance(to level: Int) -> Bool {
        if LevelTracker.isUnlocked(level) {
            currentLevel = level
            return true
        } else {
            return false
        }
    } // 类型方法
}
```
