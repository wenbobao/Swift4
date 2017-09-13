## 变量

关键字 `var` 来声明变量

 ```
 var currentLoginAttempt = 0
 ```
##常量

关键字 `let` 来声明常量

```
let maximumNumberOfLoginAttempts = 10 
```

## 类型标注

在声明一个变量或常量的时候提供类型标注，来明确变量或常量能够储存值的类型。添加类型标注的方法是在变量或常量的名字后边加一个冒号，再跟一个空格，最后加上要使用的类型名称。

```
var welcomeMessage: String
welcomeMessage = "Hello"
```

## 输出常量和变量

使用 print() 函数来打印当前常量和变量中的值。

```
var welcomeMessage = "Hello"
print(welcomeMessage)
```

## 字符串插值

Swift 使用字符串插值 的方式来把常量名或者变量名当做占位符加入到更长的字符串中, 将常量或变量名放入圆括号中并在括号前使用反斜杠将其转义：

```
print("The current value of friendlyWelcome is \(friendlyWelcome)")
```

## 注释

单行注释 

```
// 这是一个注释
```

多行注释

```
/* this is also a comment,
but written over multiple lines */
```

## 分号

和许多其他的语言不同，Swift 并不要求你在每一句代码结尾写分号（ ; ），当然如果你想写的话也没问题。总之，如果你想在一行里写多句代码，分号还是需要的。

```
let hello = 'hello'; print(hello)
```

## 整数

整数就是没有小数部分的数字，比如 42 和 -23 。整数可以是有符号（正，零或者负）`Int`，或者无符号（正数或零）`UInt`。

`Int`  可以存 -2,147,483,648 到 2,147,483,647 之间的任意值。

## 浮点数

浮点数是有小数的数字，比如 3.14159 , 0.1 , 和 -273.15 。Swift 提供了两种有符号的浮点数类型。
1. Double代表 64 位的浮点数，至少15位精度
2. Float 代表 32 位的浮点数，精度6位
3. 具体使用哪种浮点类型取决于你代码需要处理的值范围。在两种类型都可以的情况下，推荐使用 Double 类型。

## 类型安全和类型推断

Swift 是一门类型安全的语言。类型安全的语言可以让你清楚地知道代码可以处理的值的类型。如果你的一部分代码期望获得 `String` ，你就不能错误的传给它一个 `Int` 。

因为 Swift 是类型安全的，他在编译代码的时候会进行类型检查，任何不匹配的类型都会被标记为错误。这会帮助你在开发阶段更早的发现并修复错误。

举个例子，如果你给一个新的常量设定一个 42 的字面量，而且没有说它的类型是什么，Swift 会推断这个常量的类型是 Int ，因为你给这个常量初始化为一个看起来像是一个整数的数字。

```
let a = 42 // let a: Int = 42
```

## 数值型字面量

整数型字面量可以写作：

* 一个十进制数，没有前缀
* 一个二进制数，前缀是 0b
* 一个八进制数，前缀是 0o
* 一个十六进制数，前缀是 0x

下面的这些所有整数字面量的十进制值都是 17 :

```
let decimalInteger = 17
let binaryInteger = 0b10001 // 17 in binary notation
let octalInteger = 0o21 // 17 in octal notation
let hexadecimalInteger = 0x11 // 17 in hexadecimal notation
```

## 类型别名

类型别名可以为已经存在的类型定义了一个新的可选名字。用 typealias 关键字定义类型别名。
当你根据上下文的语境想要给类型一个更有意义的名字的时候，类型别名会非常高效，例如处理外部资源中特定长度的数据时：

```
typealias AudioSample = UInt16
```

## 布尔值

布尔量类型 `Bool` ， Swift为布尔量提供了两个常量值， true 和 false 。

## 元组

元组把多个值合并成单一的复合型的值。元组内的值可以是任何类型，而且可以不必是同一类型。
在下面的示例中， (404, "Not Found") 是一个描述了 HTTP 状态代码 的元组。 一个类型为 (Int, String)的元组。

```
let http404Error = (404, "Not Found")
```

## 可选项

可以利用可选项来处理值可能缺失的情况。可选项意味着：

*  这里有一个值，他等于x
*  这里根本没有值

> 在 C 和 Objective-C 中，没有可选项的概念。在 Objective-C 中有一个近似的特性，一个方法可以返回一个对象或者返回 nil 。 nil 的意思是“缺少一个可用对象”。然而，他只能用在对象上，却不能作用在结构体，基础的 C 类型和枚举值上。对于这些类型，Objective-C 会返回一个特殊的值（例如 NSNotFound ）来表示值的缺失。这种方法是建立在假设调用者知道这个特殊的值并记得去检查他。然而，Swift 中的可选项就可以让你知道任何类型的值的缺失，他并不需要一个特殊的值。

## nil

你可以通过给可选变量赋值一个 nil 来将之设置为没有值：

```
var serverResponseCode: Int? = 404
// serverResponseCode contains an actual Int value of 404
serverResponseCode = nil
// serverResponseCode now contains no value
```

如果你定义的可选变量没有提供一个默认值，变量会被自动设置成 nil 。

```
var surveyAnswer: String?
// surveyAnswer is automatically set to nil
```

> 注意
> 
> Swift 中的 nil 和Objective-C 中的 nil 不同，在 Objective-C 中 nil 是一个指向不存在对象的指针。在 Swift中， nil 不是指针，他是值缺失的一种特殊类型，任何类型的可选项都可以设置成 nil 而不仅仅是对象类型。


##  可选项绑定

可以使用可选项绑定来判断可选项是否包含值，如果包含就把值赋给一个临时的常量或者变量。可选绑定可以与 if 和 while 的语句使用来检查可选项内部的值，并赋值给一个变量或常量。

```
if let constantName = someOptional { 
    statements 
} 
```

## 隐式展开可选项

有时在一些程序结构中可选项一旦被设定值之后，就会一直拥有值。在这种情况下，就可以去掉检查的需求，也不必每次访问的时候都进行展开，因为它可以安全的确认每次访问的时候都有一个值。

这种类型的可选项被定义为隐式展开可选项。通过在声明的类型后边添加一个叹号（ String! ）而非问号（  String? ） 来书写隐式展开可选项。

```
let possibleString: String? = "An optional string."
let forcedString: String = possibleString! // requires an exclamation mark
```



