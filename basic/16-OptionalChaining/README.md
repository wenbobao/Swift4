# 可选链

`可选链`是在当前可能为 nil 的可选值上查询和调用属性，方法，和下标的过程。如果可选值有值，则属性、方法或下标调用成功；如果可选值为 nil ，则属性、方法或下标调用返回 nil。

## 可选链作为强制展开的代替品

如果可选项不为 `nil`，可以在可选值后面加上问号（?） ，从而指定可选链。 这非常类似于在可选值之后放置感叹号（!）来强制展开它的值。主要的区别是，可选链在可选项为 `nil` 时只会调用失败，而强制展开在可选项为 `nil` 时会触发运行时错误。

为了反映可选链可以对 nil 值进行调用这一事实，可选链调用的结果总是一个可选值，即使正在查询的属性、方法或下标返回一个不可选值。

你可以使用可选链来调用超过一级深度的属性、方法和下标。 这使你可以深入查看相互关联类型的复杂模型中的子属性，并检查是否可以访问这些子属性上的属性、方法和下标。

```
class Person {
    var residence: Residence?
}

class Residence {
    var numberOfRooms = 1
}

let john = Person()

if let roomCount = john.residence?.numberOfRooms {
    print("John's residence has \(roomCount) room(s).")
} else {
    print("Unable to retrieve the number of rooms.")
}
// 打
```

## 可选链调用方法

你可以使用可选链来调用一个可选值的方法，以及检查调用是否成功。即使那个方法没有返回值你依然可以这样做。

```
class Person {
    var residence: Residence?
}

class Residence {
    var numberOfRooms = 1

    func printNumberOfRooms() {
        print("The number of rooms is \(numberOfRooms)")
    }
    // 这个方法没有指定返回类型。但是，没有返回值的函数和方法会有一个隐式返回类型 Void,这意味着会返回一个 ()，或者说一个空的元组。
    // 如果你用可选链调用一个可选值的方法，这个方法的返回类型会是 Void?，而不是 Void。
}

let john = Person()

if john.residence?.printNumberOfRooms() != nil {
    print("It was possible to print the number of rooms.")
} else {
    print("It was not possible to print the number of rooms.")
}
```

通过可选链尝试给一个属性赋值也是同样。这个例子 通过可选链访问属性 尝试给 john.residence 设置一个 address 值，即便这时 residence 属性是个 nil。任何通过可选链给属性赋值的尝试都会返回一个 Void? 类型的值。这样你可以和 nil 比较来检查赋值是否成功：

```
if (john.residence?.address = someAddress) != nil {
    print("It was possible to set the address.")
} else {
    print("It was not possible to set the address.")
}
// 打印 "It was not possible to set the address."
```

## 可选链访问下标

你可以使用可选链尝试从可选值的下标中检索和设置值，并检查该下标调用是否成功。

> ⚠️ 当你通过可选链访问一个可选值的下标时，在下标中括号 `前面`放置问号，而不是后面。可选链的问号永远是直接跟在可选表达式后面。

```
if let firstRoomName = john.residence?[0].name {
    print("The first room name is \(firstRoomName).")
} else {
    print("Unable to retrieve the first room name.")
}
```

## 访问可选类型的下标

如果下标返回一个可选类型的值，例如 Swift 中 Dictionary 的键下标，在下标的右括号 后面 放置一个问号来链接其可选的返回值：

```
var testScores = ["Dave": [86, 82, 84], "Bev": [79, 94, 81]]
testScores["Dave"]?[0] = 91
testScores["Bev"]?[0] += 1
testScores["Brian"]?[0] = 72
```

## 多级链表关联

- 如果要检索的类型不是可选的，通过可选链，它将成为可选的。
- 如果您要检索的类型已经是可选的，那么它将保持原状。

因此：

- 如果你试图通过可选链检索一个 Int 值，那么不管用了多少链，总是返回一个 Int? 。
- 同样，你试图通过可选链检索一个 Int? 值，无论使用多少链，也总是返回一个 Int? 。

## 在方法的可选返回值上进行可选链式调用

我们可以在一个可选值上通过可选链式调用来调用方法，并且可以根据需要继续在方法的可选返回值上进行可选链式调用。

下面的方法返回 `String?` 类型的值

```
if let buildingIdentifier = john.residence?.address?.buildingIdentifier() {
    print("John's building identifier is \(buildingIdentifier).")
}
// 打印 "John's building identifier is The Larches."
```

如果要在该方法的返回值上进行可选链式调用，在方法的圆括号后面加上问号即可：

```
if let beginsWithThe =
    john.residence?.address?.buildingIdentifier()?.hasPrefix("The") {
    if beginsWithThe {
        print("John's building identifier begins with \"The\".")
    } else {
        print("John's building identifier does not begin with \"The\".")
    }
}
// 打印 "John's building identifier begins with "The"."
```
