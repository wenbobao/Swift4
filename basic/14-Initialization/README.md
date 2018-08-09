# 构造过程

构造过程就是使用类，结构体，和枚举实例的准备过程， 这个过程包含了设置实例每个存储属性的初始值并在实例使用之前执行全部所需的其他设置和初始化。

与 Obejctive-C 的构造器不同的是，Swift 的构造器不用返回值，主要作用是确保在第一次使用之前， 类型的实例都能  正确的初始化。

## 设置存储属性的初始值

类和结构体在其创建实例时 `必须` 为他们所有的存储属性设置适当的初始值。存储属性不能处于未知状态。

你可以在构造器中为存储属性设置初始值，或是作为定义属性时的一部分设置其默认值。

> 当你为存储属性设置默认值时，或是在构造器中设置其初始值，属性值是直接设置的，并不会调用任何属性观察器。

### 构造器

`构造器` 在创建某类实例时调用。其最简单的形式用 `init` 关键字来写，

```
struct Fahrenheit {
    var temperature: Double
    init() {
        temperature = 32.0
    }
}
var f = Fahrenheit()
print("The default temperature is \(f.temperature)° Fahrenheit")
```

### 默认属性值

> 如果一个属性总是相同的初始值，与其在构造器中设置一个值不如提供一个默认值。其效果是相同的，但是默认值与属性构造器的联系更紧密一些。它使构造器更简短，更清晰，并且可以通过默认值推断属性类型。默认值也使你更易使用默认构造器和构造器继承

```
struct Fahrenheit {
    var temperature = 32.0
}
```

## 自定义构造过程

可以通过输入参数和可选类型属性，或在构造过程中给常量属性赋值来自定义构造过程。

### 构造参数

可以提供 `构造参数` 作为构造器定义的一部分，以定义自定义构造过程中值的类型和名字。

```
struct Celsius {
    var temperatureInCelsius: Double
    init(fromFahrenheit fahrenheit: Double) {
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
    }
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
}
let boilingPointOfWater = Celsius(fromFahrenheit: 212.0)
// boilingPointOfWater.temperatureInCelsius is 100.0
let freezingPointOfWater = Celsius(fromKelvin: 273.15)
```

### 内部参数名和外部参数名

```
struct Color {
    let red, green, blue: Double
    init(red: Double, green: Double, blue: Double) {
        self.red   = red
        self.green = green
        self.blue  = blue
    }
    init(white: Double) {
        red   = white
        green = white
        blue  = white
    }
}

let magenta = Color(red: 1.0, green: 0.0, blue: 1.0)
let halfGray = Color(white: 0.5)
```

### 无需外部参数名的构造参数

使用下划线 `_` 来代替显示外部参数名

```
struct Celsius {
    var temperatureInCelsius: Double
    init(_ celsius: Double) {
        temperatureInCelsius = celsius
    }
}
let bodyTemperature = Celsius(37.0)
```

### 可选属性类型

如果你的自定义类型有一个逻辑上允许『 没有值 』存储属性 --- 也许因为构造过程期间不为其赋值，或是因为它在稍后的某个时间点上被设置为『没有值』--- 声明属性为 可选 类型。可选类型的属性会自动被初始化为 nil，表示属性在构造过程期间故意设置为『没有值』。

```
class SurveyQuestion {
    var text: String
    var response: String?
    init(text: String) {
        self.text = text
    }
    func ask() {
        print(text)
    }
}
let cheeseQuestion = SurveyQuestion(text: "Do you like cheese?")
cheeseQuestion.ask()
// 打印 "Do you like cheese?"
cheeseQuestion.response = "Yes, I do like cheese."
```

### 在构造过程期间给常量赋值

构造过程期间你可以在任何时间点给常量属性赋值，只要构造完成时设置了确定值即可。一旦常量属性被赋值，就不能再次修改。

> 对于类的实例来说，常量属性只能在定义常量属性类的构造器中修改。不能在派生类中修改。

```
class SurveyQuestion {
    let text: String
    var response: String?
    init(text: String) {
        self.text = text
    }
    func ask() {
        print(text)
    }
}
let beetsQuestion = SurveyQuestion(text: "How about beets?")
beetsQuestion.ask()
// 打印 "How about beets?"
beetsQuestion.response = "I also like beets. (But not with cheese.)"
```

### 默认构造器

Swift 为属性均有默认值和没有构造器的结构体或类提供了一个 默认构造器 。默认构造器创建了一个所有属性都有默认值的新实例。

```
class ShoppingListItem {
    var name: String?
    var quantity = 1
    var purchased = false
}
var item = ShoppingListItem()
```

### 结构体类型的成员构造器

如果结构体没有任何自定义构造器，那么结构体类型会自动接收一个 `成员构造器`。不同于默认构造器，即使结构体的存储属性没有默认值，它也会接收成员构造器。

```
struct Size {
    var width = 0.0, height = 0.0
}
let twoByTwo = Size(width: 2.0, height: 2.0)
```

## 构造器代理

构造器可以调用其他构造器来执行实例的部分构造过程。这个过程称之为 `构造器代理`，以避免多个构造器之间的重复代码。

值类型(结构体和枚举)不支持继承，所以其代理过程相对简单。只能代理给自己提供的其他构造器。
类可以继承其他类，有确保在构造期间将继承来的存储属性合理赋值的额外责任。

### 值类型的构造器代理

对于值类型， 在自定义构造器  中使用`self.init`来引用同一类型的  其他构造器。只能在构造器  中使用`使用self.init`。

如果你为值类型自定义了构造器，将无法访问该类型的默认构造器/成员构造器。这个约束避免了一种缺陷，就是某人使用了某个自动构造器而意外绕开了一个带有额外必要设置且更复杂的构造器。

> 如果你想让你的自定义类型可以使用默认构造器，成员构造器，自定义构造器来进行初始化，就把自定义构造器写在扩展中，而不是作为值类型原始实现的一部分。

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
    init() {}
    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}
```

## 类的继承和构造过程

类的所有存储属性 --- 包括任何从父类继承而来的属性 --- 必须 在构造过程期间赋值。

Swift 给类类型定义了两种构造器以确保所有存储属性都能接收到初始值。

- 指定构造器
- 便利构造器

### 指定构造器

一个指定构造器初始化该类引入的所有属性，并调用合适的父类构造器以继续父类链上的构造过程。

类往往只有很少的指定构造器，通常一个类只有一个指定构造器。

每个类至少要有一个指定构造器。

### 便利构造器

类的辅助构造器。你可以定义便利构造器来调用同一类中的指定构造器并为指定构造器的一些参数设置默认值。你也可以定义便利构造器为特殊用例类或是输入类型类创建实例。

你应当只在你的类需要时而为其提供便利构造器。相比普通的构造模式，创建便利构造器会节省很多时间并将类的构造过程变得更加清晰。

### 指定构造器和便利构造器语法

类的指定构造器和值类型的简单构造器

```
init(parameters) {
    statements
}
```

便利构造器有着相同风格的写法，但是在 `init` 关键字之前需要放置 `convenience` 修饰符，并使用空格来分隔：

```
convenience init(parameters) {
    statements
}
```

### 类的构造代理

为了简化指定构造器和便利构造器之间的关系。Swift 对构造器之间的代理采用了如下三条规则：

```
规则 1

指定构造器必须调用其直系父类的指定构造器。

规则 2

便利构造器必须调用 `同一` 类中的其他构造器。

规则 3
```

便利构造器最后必须调用指定构造器。

> 指定构造器必须 `向上` 代理。<br>
> 便利构造器必须 `横向` 代理。

下图解析了这些规则:

![](https://ioscaffcdn.phphub.org/uploads/images/201807/19/1/s2kSsZNgeJ.png?imageView2/2/w/896/h/0)

父类有一个指定构造器和两个便利构造器。一个便利构造器调用另一个便利构造器，后者又调用指定构造器。这符合上述规则 2 和规则 3。 父类本身并没有父类，所以规则 1 不适用。

该图中的派生类有两个指定构造器和一个便利构造器。便利构造器必须调用两个指定构造器中的一个，因为它只能调用同一类中的其他构造器。这符合上述规则 2 和规则 3。两个指定构造器必须调用父类中唯一的指定构造器，所以也符合上述规则 1。

> ⚠️ 这些规则并不影响每个类创建实例。上图中的任何构造器都可以用于为其所属类创建完全初始化的实例。这些规则只会影响类的构造器实现。

复杂点的层级结构:

![](https://ioscaffcdn.phphub.org/uploads/images/201807/19/1/yN8lr7YbsW.png?imageView2/2/w/896/h/0)

## 两段式构造器过程

Swift 中类的构造过程是两段式处理。

第一阶段，为类引入的每个存储属性赋一个初始值。

第二阶段开始，在新的实例被认为可以使用前，每个类都有机会进一步定制其存储属性。

两段式构造过程的使用让构造过程更安全，同时对于类层级结构中的每个类仍然给予完全的灵活性。两段式构造过程防止了属性在初始化前访问其值，并防止其他构造器意外给属性赋予不同的值。

> Swift 的两段式构造过程类似于 Objective-C 的构造过程。主要区别就是在第一阶段期间，`Objective-C` 对每个属性赋值为 0 或空（例如 0 或 nil），Swift 的构造过程的流程就更灵活，允许设置自定义初始值，并能应付一些 0 或 nil 不能作为有效默认值的类型。

Swift 的编译器执行了四个有帮助的安全检查以确保两段式构造过程无误完成：

```
安全检查 1

指定构造器必须确保其类引入的所有属性在向上代理父类构造器之前完成初始化

安全检查 2

指定构造器必须在继承属性赋值前向上代理父类构造器，否则，便利构造器赋予的新值将被父类构造过程的一部分重写。

安全检查 3

便利构造器必须在 任何 属性（包括同一类中定义的属性）赋值前代理另一个构造器。否则便利构造器赋予的新值将被其所属类的指定构造器重写。

安全检查 4

构造器在第一阶段构造过程完成前，不能调用任何实例方法，不能读取任何实例属性的值，不能引用 self 作为一个值。
```

类实例在第一阶段完成前并不是完全有效的。一旦第一阶段结束，类实例才是有效的，才能访问属性，调用方法。

以下是基于以上四个安全检查的两段式构造过程的流程：

```
阶段 1

在类中调用指定或便利构造器。
对一个新实例分配内存，但内存没还没有初始化。
指定构造器确认其所属类的所有存储属性都有值。现在那些存储属性的内存初始化完成。
指定构造器移交给父类构造器以为其存储属性执行相同的任务。
这个过程沿着类的继承链持续向上，直到到达继承链的顶端。
一旦到达链的顶端，并且链中最后的类确保其所有存储属性都有值，则认为实例的内存已经完全初始化，至此阶段 1 完成。

阶段 2

从链顶端往下，链中每个指定构造器都可以选择进一步定制实例，构造器现在可以访问 self 并修改它的属性，调用实例方法，等等。
最终，在链中的任何便利构造器也都可以选择定制实例以及使用 self 。
```

同一构造过程 阶段 1 ：

![](https://ioscaffcdn.phphub.org/uploads/images/201807/19/1/sBJdelLrhG.png?imageView2/2/w/897/h/0)

同一构造过程 阶段 2 ：

![](https://ioscaffcdn.phphub.org/uploads/images/201807/19/1/zukzKBjtdJ.png?imageView2/2/w/896/h/0)

## 构造器的基础和重写

与 Objective-C 的派生类不同，Swift 的派生类默认不继承其父类构造器。Swift 这种机制防止了更定制化的派生类继承父类的简单构造器，也防止将简单构造器用于创建不完全初始化或是错误初始化的派生类实例。

> 在安全和适合的情况下，父类构造器是可以继承的。

如果你想要自定义派生类有一个或多个与其父类相同的构造器，你可以在子类中提供这些自定义构造器的实现。

当你在写一个与父类 指定 构造器相匹配的派生类构造器时，你是在有效的重写指定构造器。因此，你必须在派生类构造器的定义前写上修饰符 `override` 。就像 `默认构造器`中描述的那样，即使你重写的是一个自动提供的默认构造器，也要写上 `override` 。

> 重写父类指定构造器时总是要写修饰符 `override` 的，即使你实现的是派生类的便利构造器。

相反的，如果你写一个与父类 便利 构造器相匹配的派生类构造器，根据 类的构造器代理 规则，派生类是不能直接调用父类便利构造器的。因此，你的派生类（严格来说）没有重写父类构造器。所以，在提供与父类便利构造器相匹配的实现时，无需编写 修饰符 override。

```
class Vehicle {
    var numberOfWheels = 0
    var description: String {
        return "\(numberOfWheels) wheel(s)"
    }
}
// 有一个默认构造器
let vehicle = Vehicle()
print("Vehicle: \(vehicle.description)")
// Vehicle: 0 wheel(s)

// 派生类 Bicycle
class Bicycle: Vehicle {
   // 自定义构造器init()，这个指定构造器匹配于 Bicycle 父类的指定构造器， 因此需要用修饰符 override 标记。
    override init() {
        super.init()
        numberOfWheels = 2
    }
}
let bicycle = Bicycle()
print("Bicycle: \(bicycle.description)")
// Bicycle: 2 wheel(s)
```

> 派生类可在构造过程期间可修改变量继承属性，但不能修改常量继承属性。

### 自动构造器的继承

### 实践指定构造器和便利构造器

```
class Food {
    var name: String
    // 指定构造器
    init(name: String) {
        self.name = name
    }
    // 便利构造器
    convenience init() {
        self.init(name: "[Unnamed]")
    }
}
```

![](https://ioscaffcdn.phphub.org/uploads/images/201807/19/1/TH7rOUrrSv.png?imageView2/2/w/964/h/0)

```
// 派生类
class RecipeIngredient: Food {
    var quantity: Int
    // 指定构造器
    init(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
    }
    // 便利构造器
    override convenience init(name: String) {
        self.init(name: name, quantity: 1)
    }
}
```

![](https://ioscaffcdn.phphub.org/uploads/images/201807/19/1/xsFpQPWsfB.png?imageView2/2/w/964/h/0)
