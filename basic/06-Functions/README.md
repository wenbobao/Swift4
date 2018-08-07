# 函数

函数 是执行一个具体任务的一段独立代码块，你可以通过为函数命名来标识其任务功能，当需要执行这个任务时，函数名就可以用来「调用」该函数。

## 函数定义和调用

```
// 函数定义
func greet(person: String) -> String {
    let greeting = "Hello, " + person + "!"
    return greeting
}
// 函数调用
print(greet(person: "Anna"))
```

## 函数参数和返回值

### 无参函数

```
func sayHelloWorld() -> String {
    return "hello, world"
}
print(sayHelloWorld())
// Prints "hello, world
```

### 多个参数

```
func greet(person: String, alreadyGreeted: Bool) -> String {
    if alreadyGreeted {
        return greetAgain(person: person)
    } else {
        return greet(person: person)
    }
}
print(greet(person: "Tim", alreadyGreeted: true))
```

### 无返回值函数

```
func greet(person: String) {
    print("Hello, \(person)!")
}
greet(person: "Dave")
```

> 严格意义来说, `greet(person:)`函数 仍然 返回一个值，只是这个返回值没有被定义。函数返回值没有定义时，默认是返回 `Void` 类型。它是一个简单的空元祖，可以被写做 `()` 。

> 返回值可以被忽略， 但函数的返回值还是需要接收。 一个有返回值的函数的返回值不允许直接丢弃不接收，如果你尝试这样做，编译器将给你抛出错误。

### 多返回值函数

1.  返回元祖类型

```
func minMax(array: [Int]) -> (min: Int, max: Int) {
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        } else if value > currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}
```

这个 `minMax(array:)` 函数返回一个包含了两个整型 `Int` 的元祖。

2.  返回可选元祖类型

```
func minMax(array: [Int]) -> (min: Int, max: Int)? {
    if array.isEmpty { return nil }
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        } else if value > currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}
```

### 函数的参数标签和参数名

每一个参数都由一个 参数标签 和一个 参数名 构成。参数标签被用在调这个方法时； 每一个参数标签写在参数的前面。参数名被用在函数的具体实现中。 默认参数的参数标签可以不写，用参数名来作为参数标签。

```
func someFunction(firstParameterName: Int, secondParameterName: Int) {
    // 在函数体内， 变量 firstParameterName 和 变量 secondParameterName 所对应的值分别是第一个和第二个参数传递进来的
}
someFunction(firstParameterName: 1, secondParameterName: 2)
```

### 明确参数标签

```
func greet(person: String, from hometown: String) -> String {
    return "Hello \(person)!  Glad you could visit from \(hometown)."
}
print(greet(person: "Bill", from: "Cupertino"))
```

### 省略参数标签

```
func someFunction(_ firstParameterName: Int, secondParameterName: Int) {
    // 在函数体中，变量 firstParameterName 和 secondParameterName 分别对应第一个和第二个参数的值
}
someFunction(1, secondParameterName: 2)
```

### 参数默认值

你可以给函数的任何参数提供一个默认值，通过写在参数类型后面。 如果提供了默认值，你就可以在调用时省略给这个参数传值。

```
func someFunction(parameterWithoutDefault: Int, parameterWithDefault: Int = 12) {
    // 调用时如果你没有给第二个参数传值，那么变量  parameterWithDefault 的值默认就是 12 。
}
someFunction(parameterWithoutDefault: 3, parameterWithDefault: 6) // 变量 parameterWithDefault 的值是 6
someFunction(parameterWithoutDefault: 4) // 变量 parameterWithDefault 的值是 12
```

把没有默认值的参数放在有默认值的参数前面。 没有默认值的参数对函数更重要 --- 当调用时，把它们写在前面更容易区分具有部分相同参数的函数，无论默认参数是否被忽略。

### 可变参数

可变参数 接受 0 个或多个具体相同类型的值。  
传入函数体内的可变参数可以被当做一个数组类型来使用。

```
func arithmeticMean(_ numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}
arithmeticMean(1, 2, 3, 4, 5)
// returns 3，5 个数的平均值是 3
arithmeticMean(3, 8.25, 18.75)
// returns 10.0，3 个数的平均值是 10.0
```

> ⚠️ 一个函数至多只能有一个可变参数。

### 传入传出参数

函数参数默认是常量，不能直接修改其值。编译器会报错如果你尝试在函数体内修改传入参数的值。 但如果你执意要修改这个参数值， 并希望在函数执行完成后修改的值仍然有效， 那么用 `传入传出参数` 来代替普通参数。

传入传出参数通过在参数类型前加上 `inout` 关键字来定义。

传入传出参数可以有一个初始值， 传入函数后值将被修改，在函数执行完传出后，这个变量的初始值就会被替换完成。

> ⚠️ 传入传出参数不能有默认值，并且可变参数也不能被标记 inout 。

```
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}
```

传入传出参数只支持变量。常量或字面量将不被允许做为参数传递，因为它们都不能被修改。 传值时，在参数名前面加上 & 符号，来表示它能在函数体内被修改。

```
var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")
```

> 在同一个函数中，传入传出参数和返回值不一定要同时存在。上面这个例子中， swapTwoInts 函数没有返回值， 但变量 someInt 和 anotherInt 的初始值仍然被修改了。 传入传出参数为函数影响函数体外部的作用域提供了一种可选的方式。

## 函数类型

每个函数的具体 函数类型 由它的参数类型和返回类型共同决定。

```
// 函数类型为： (Int, Int) -> Int
func addTwoInts(_ a: Int, _ b: Int) -> Int {
    return a + b
}
// 函数类型为：() -> Void
func printHelloWorld() {
    print("hello, world")
}
```

### 使用函数类型

```
// 『 定义了一个函数类型的 mathFunction 变量，「 它接收两个 Int 类型的参数，并返回一个 Int 值。」并把 addTwoInts 函数关联给这个变量。』
var mathFunction: (Int, Int) -> Int = addTwoInts

print("Result: \(mathFunction(2, 3))")
// 打印 "Result: 5"
```

### 函数类型作为参数

你可以把 `(Int, Int) -> Int` 类型的函数作为一个参数传递给另一个函数。 当这个函数被调用时，这使得具体实现逻辑被当做一个函数传递给了这个函数的调用者。

```
func printMathResult(_ mathFunction: (Int, Int) -> Int, _ a: Int, _ b: Int) {
    print("Result: \(mathFunction(a, b))")
}
printMathResult(addTwoInts, 3, 5)
// 打印 "Result: 8"
```

### 返回类型为  函数类型

你可以把一个函数类型作为另一个函数的返回类型。在这个返回箭头后面 (->) 跟上你要返回的具体函数类型。

```
func stepForward(_ input: Int) -> Int {
    return input + 1
}
func stepBackward(_ input: Int) -> Int {
    return input - 1
}

func chooseStepFunction(backward: Bool) -> (Int) -> Int {
    return backward ? stepBackward : stepForward
}

var currentValue = 3
let moveNearerToZero = chooseStepFunction(backward: currentValue > 0)
// 变量 moveNearerToZero 现在引用着 stepBackward() 函数

print("Counting to zero:")
// Counting to zero:
while currentValue != 0 {
    print("\(currentValue)... ")
    currentValue = moveNearerToZero(currentValue)
}
print("zero!")
// 3...
```

## 嵌套函数

可以在函数体内定义一个函数，做为该函数的嵌套函数。

```
func chooseStepFunction(backward: Bool) -> (Int) -> Int {
    func stepForward(input: Int) -> Int { return input + 1 }
    func stepBackward(input: Int) -> Int { return input - 1 }
    return backward ? stepBackward : stepForward
}
var currentValue = -4
let moveNearerToZero = chooseStepFunction(backward: currentValue > 0)
//  `moveNearerToZero` 变量引用着 `stepForward()` 函数
while currentValue != 0 {
    print("\(currentValue)... ")
    currentValue = moveNearerToZero(currentValue)
}
print("zero!")
```
