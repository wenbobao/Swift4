# 错误处理

Swift 中的错误处理与在 Cocoa 和 Objective-C 中使用的 NSError 的错误处理模式互操作。

## 表示和抛出错误

在 Swift 中，错误是遵循 `Error` 协议的值。`Error` 是一个空协议，表明遵循该协议的类型可以用于错误处理。

Swift 中的枚举特别适合对一组相关的错误条件进行建模，关联值允许传递有关错误的附加信息。

```
enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int) //关联值
    case outOfStock
}
```

- 您可以通过抛出错误表示发生了意外情况，导致正常的执行流程不能继续执行下去。
- 您可以使用 `throw` 语句抛出错误。

```
throw VendingMachineError.insufficientFunds(coinsNeeded: 5)
```

## 处理错误

当抛出错误时，它周围的代码必须负责处理错误。例如，通过尝试替换方案或将错误通知用户来纠正错误。

在 Swift 中有四种处理错误的方式。

- 可以将错误从函数传递给调用该函数的代码
- 可以使用`do-catch`语句错误处理
- 可以通过可选值处理错误->try?
- 通过断言保证错误不会发生->try!

在调用可能引发错误的函数、方法或初始化程序的代码之前，使用 try 关键字，或者使用它的变体 try? 或 try!，在您的代码中定位错误的位置。

> ⚠️ 在 Swift 中使用 try、catch 和 throw 关键字进行错误处理的语法和其他语言的异常处理差不多。不同于 Objective-C 等语言的异常处理，Swift 中的错误处理不会展开调用堆栈，因为这个过程的计算成本很高。因此，throw 语句的性能特性和 return 语句的性能特性相差无几。

### 使用抛出函数传递错误

为了让函数、方法或者初始化程序可以抛出错误，您需要在函数声明的参数后面添写 `throws` 关键字。

标有 `throws` 的函数称为抛出函数。

```
func canThrowErrors() throws -> String

func cannotThrowErrors() -> String
```

> ⚠️ 只有抛出函数才能传递错误。任何在非抛出函数中抛出错误都必须在函数内部进行处理

```
struct Item {
    var price: Int
    var count: Int
}

class VendingMachine {
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11)
    ]
    var coinsDeposited = 0

    func vend(itemNamed name: String) throws {
        guard let item = inventory[name] else {
            throw VendingMachineError.invalidSelection
        }

        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }

        guard item.price <= coinsDeposited else {
            throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }

        coinsDeposited -= item.price

        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem

        print("Dispensing \(name)")
    }
}
```

为 `vend(itemNamed:)` 方法会传播它抛出的任何错误，因此调用此方法的任何代码都必须处理错误 --- 使用 `do- catch` 语句，`try?` 或 `try!` --- 或继续传播它们。

下面的例子是 继续向上层抛出错误

```
let favoriteSnacks = [
    "Alice": "Chips",
    "Bob": "Licorice",
    "Eve": "Pretzels",
]
func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    try vendingMachine.vend(itemNamed: snackName)
}
```

### 使用 Do-Catch 处理错误

do - catch 语句通过运行代码块来处理错误。如果 `do` 子句中的代码抛出错误，它将与 `catch` 子句一一匹配，以确定它们中的哪一个子句可以处理错误。

```
do {
    try expression
    statements
} catch pattern 1 {
    statements
} catch pattern 2 where condition {
    statements
} catch {
    statements
}
```

在 `catch` 之后写一个模式来表明该子句可以处理的错误。如果 `catch` 子句没有模式，则该子句将会匹配所有错误并将错误绑定到名为 `error` 的本地常量。

```
var vendingMachine = VendingMachine()
vendingMachine.coinsDeposited = 8
do {
    try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
    print("Success! Yum.")
} catch VendingMachineError.invalidSelection {
    print("Invalid Selection.")
} catch VendingMachineError.outOfStock {
    print("Out of Stock.")
} catch VendingMachineError.insufficientFunds(let coinsNeeded) {
    print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
} catch {
    print("Unexpected error: \(error).")
}
// 打印 "Insufficient funds. Please insert an additional 2 coins."
```

`catch` 子句不必处理 `do` 子句中抛出的所有可能错误。 如果所有 `catch` 子句都没能处理错误，错误会向周围传播。 但是，传播的错误必须能被附近的 一些 作用域处理。 在非抛出函数中，封闭的 do - catch 子句必须处理错误。 在可抛出函数中，封闭的 do - catch 子句或调用者必须处理错误。 如果错误传播到顶级作用域而未被处理，则会出现运行时错误。

```
func nourish(with item: String) throws {
    do {
        try vendingMachine.vend(itemNamed: item)
    } catch is VendingMachineError {
        print("Invalid selection, out of stock, or not enough money.")
    }
}

do {
    try nourish(with: "Beet-Flavored Chips")
} catch {
    print("Unexpected non-vending-machine-related error: \(error)")
}
// 打印 "Invalid selection, out of stock, or not enough money."
```

### 将错误转换为可选值

你可以使用 `try?` 将错误转换为可选值来处理错误。 如果在执行 `try?` 表达式时抛出错误，表达式的值将为 `nil`

```
func someThrowingFunction() throws -> Int {
    // ...
}

let x = try? someThrowingFunction()

let y: Int?
do {
    y = try someThrowingFunction()
} catch {
    y = nil
}
```

你想以同样的方式处理所有错误时，使用 try? 可以帮助你编写出简洁的错误处理代码。 例如，以下代码使用多种途径来获取数据，如果所有方法都失败则返回 nil 。

```
func fetchData() -> Data? {
    if let data = try? fetchDataFromDisk() { return data }
    if let data = try? fetchDataFromServer() { return data }
    return nil
}
```

### 禁用错误传播

有时你知道可抛出函数或方法实际上不会在运行时抛出错误。 在这种情况下，你可以在表达式之前添加 try! 来禁用错误传播，并把调用过程包装在运行时断言中，从而禁止其抛出错误。 而如果实际运行时抛出了错误，你将收到运行时错误。

```
let photo = try! loadImage(atPath: "./Resources/John Appleseed.jpg")
```

## 指定清理操作

当代码执行到即将离开当前代码块之前，可以使用 defer 语句来执行一组语句。
无论是因为错误而离开 --- 抑或是因为诸如 return 或 break 等语句而离开， defer 语句都可以让你执行一些必要的清理。
例如，你可以使用 defer 语句来关闭文件描述符或释放手动分配的内存。

defer 语句会推迟执行，直到退出当前作用域。

延迟语句可能不包含任何将控制转移出语句的代码，例如 break 或 return 语句，或抛出错误。

延迟操作的执行顺序与它们在源代码中编写的顺序相反。也就是说，第一个 defer 语句中的代码最后一个执行，第二个 defer 语句中的代码倒数第二个执行，依此类推。源代码中的最后一个 defer 语句最先执行。

```
func processFile(filename: String) throws {
    if exists(filename) {
        let file = open(filename)
        defer {
            close(file)
        }
        while let line = try file.readline() {
            // Work with the file.
        }
        // 在此关闭（文件），位于语句的末端。
    }
}
```

上面的例子使用 defer 语句来确保 open(_:) 函数有相应的 close(_:) 函数调用。

> ⚠️ 即使没有涉及错误处理代码，也可以使用 defer 语句。
