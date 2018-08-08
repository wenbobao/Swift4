# 闭包

闭包是独立的代码块。

函数中的全局和嵌套函数实际上也是特殊的闭包。

闭包形式如下：

- 全局函数是一个有名字但不会捕获任何值的闭包
- 嵌套函数  是一个有名字并且可以捕获其封闭函数  域内值的闭包。
- 闭包表达式是一个用轻量语法写的可以捕获其上下文中变量或常量值的匿名闭包。

Swift 的闭包表达式具有干净、清晰的风格，并鼓励在常见场景中进行语法优化使其简明、不杂乱。这些优化主要包括:

- 利用上下文推断参数和返回值类型
- 单语句表达式的闭包可以隐式返回结果
- 参数名称缩写
- 尾随闭包语法

## 闭包表达式

### 方法排序

Swift 的基础库提供了一个名字叫做 `sorted(by:)` API，它通过你编写的一个闭包来进行对数组进行排序。

方法一：书写正确类型的函数，并且作为参数传入 sorted(by:) 方法中

```
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}
var reversedNames = names.sorted(by: backward)
```

但是这种方式相当冗长，最好写法是使用闭包表达式内联的方式编写一个排序闭包。

### 闭包表达式语法

```
{ (parameters) -> return type in
    statements
}
```

 方法二：

```
let names2 = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
var reversedNames2 = names2.sorted(by: { (s1: String, s2: String) -> Bool in
    return s1 > s2
})
```

因为上面闭包表达式的主体部分比较短，甚至可以写成一行。

```
let names3 = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
names3.sorted(by: {(s1: String, s2: String) -> Bool in return s1 > s2 })
```

### 通过上下文推测类型

因为这个排序闭包是作为一个方法的参数，Swift 能够推断出这个闭包的参数和返回值。因为推断出了所有入参和返回值，返回的符号 (`->`) 和入参周围的括号也可以被省略。 简写如下：

```
let names4 = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
names4.sorted(by: {s1, s2 in return s1 > s2 })
```

### 单一闭包表达式隐式返回

单一闭包表达式可以省略声明 `return` 关键字来返回单一表达式的结果

```
let names5 = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
names5.sorted(by: {s1, s2 in s1 > s2 })
```

### 缩写参数名

Swift 自动为内联闭包提供了参数名缩写写法，这里可以使用`$0`, `$1`, `$2` 等来代替闭包的参数。

如果你在闭包表达式中使用了缩写写法，你就可以省略闭包中的参数声明部分，并且这个缩写参数的值和类型也会通过函数预期类型推断出来。

`in` 关键字也可以被省略，因为这个闭包表达式已经通过主体完全构建出来了。缩写后如下：

```
let names6 = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
names6.sorted(by: { $0 > $1 })
```

### 运算符方法

实际上还有一种 更简短 的方式来编写上面例子中的闭包表达式。Swift 的 `String` 类型将其大于运算符（`>`）的字符串特定实现为具有两个 `String` 类型参数的方法，并返回一个 `Bool` 类型的值。而这正好与 `sorted(by: )` 方法的参数需要的函数类型相符合。因此，你可以简单地传递一个大于运算符，Swift 可以自动推断出你想使用其特定于字符串的实现：

```
let names7 = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
names7.sorted(by: >)
```

### 尾随闭包

如果你需要将闭包表达式作为函数的最后一个参数传入函数，并且这个闭包非常长，这样的情况下使用 “尾随闭包” 这种写法会很有效。尾随闭包通常在函数调用的括号之后，即使他仍是一个参数。当你使用尾随闭包语法，你可以不用填写函数入参为闭包那部分的参数。

```
func someFunctionThatTakesAClosure(closure: () -> Void) {
    // 函数主体部分
}

// 这里被调用函数没用后置闭包的写法:

someFunctionThatTakesAClosure(closure: {
    // 闭包主体部分
})

// 这里被调用函数使用后置闭包的写法:

someFunctionThatTakesAClosure() {
    // 尾随闭包主体部分
}
```

字符串排序

```
let names8 = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
names8.sorted() { $0 > $1 }
```

如果函数只有一个闭包类型入参，并且使用了尾随闭包的写法，当你调用这个函数的时候可以省略函数名称后面写 () ，写法如下：

```
let names9 = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
names9.sorted { $0 > $1 }
```

如果一个闭包代码很长，以至于不能把它写在同一行上，可以使用后置闭包。

```
let digitNames = [
    0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
    5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
]
let numbers = [16, 58, 510]

let strings = numbers.map { (number) -> String in
    var number = number
    var output = ""
    repeat {
        output = digitNames[number % 10]! + output
        number /= 10
    } while number > 0
    return output
}
```

## 值捕获

闭包可以捕获它所定义的上下文环境中的常量和变量。在闭包体内可以使用和修改这些常量和变量的值，即使这些常量、变量的作用域已经不存在了。

在 Swift 中，闭包捕获值的最简单的形式是嵌套函数--写在另一个函数的函数体内。嵌套函数可以捕获外部函数中的任意参数，也可以捕获定义在函数外部的任意常量、变量。

```
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}

let incrementByTen = makeIncrementer(forIncrement: 10)

incrementByTen()
// 返回值是 10
incrementByTen()
// 返回值是 20
incrementByTen()
// 返回值是 30
```

### 闭包引用类型

上面的例子中，`incrementByTen` 是常量，但是这些常量闭包仍然能够增加它们捕获到的 `runningTotal` 变量。这因为闭包和函数是引用类型。

无论你分配变量还是常量给函数或闭包，实际上你是设置闭包或者函数引用该常量或变量。

### 逃逸闭包

当一个闭包作为参数传递给函数时，闭包被称为 `逃逸` 了函数，但是会在函数返回后才调用。当您声明将闭包作为参数之一的函数时，可以在参数的类型之前写入 `@escaping`，用来表示允许闭包逃逸。

有一种闭包可以逃逸的方式是存储在函数外定义的变量中。比如，许多有异步操作的函数以闭包参数作为 completion handler。函数在启动操作之后就已经返回，但在操作完成之后才调用闭包——这种闭包就需要需要逃逸，以便函数返回后调用。

```
var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}
```

> `someFunctionWithEscapingClosure(_:)` 函数将闭包作为它的参数，并且添加到函数之外的数组中。如果你不将函数中的这个参数标记为 `@escaping`，将为得到一个编译时的错误。

用 `@escaping`标记闭包意味着你会在闭包中显式地使用 `self`。在刚才的例子中，传递给 `someFunctionWithEscapingClosure(_:)` 的是一个逃逸闭包，意味着需要显式地使用 `self`。相对来说，传给 `someFunctionWithNonescapingClosure(_:)` 的是一个非逃逸闭包，就意味着可以隐式地使用 `self`。

```
func someFunctionWithNonescapingClosure(closure: () -> Void) {
    closure()
}

class SomeClass {
    var x = 10
    func doSomething() {
        someFunctionWithEscapingClosure { self.x = 100 }
        someFunctionWithNonescapingClosure { x = 200 }
    }
}

let instance = SomeClass()
instance.doSomething()
print(instance.x)
// 打印 "200"

completionHandlers.first?()
print(instance.x)
// 打印 "100"
```

### 自动闭包

`自动闭包` 自动包装书写的表达式，并将表达式作为一个闭包传入的函数。自动闭包不包含任何参数，当它被调用时会返回一个内部表达式包装的值。这种写法让你使用正常表达式而不是闭包的语法使你可以省略函数旁边的大括号。

```
var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
print(customersInLine.count)
// 打印 "5"

// 自动闭包
let customerProvider = { customersInLine.remove(at: 0) }
print(customersInLine.count)
// 打印 "5"

print("Now serving \(customerProvider())!")
// 打印 "Now serving Chris!"
print(customersInLine.count)
```
