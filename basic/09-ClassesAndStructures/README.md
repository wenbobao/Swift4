# 类和结构体

类和结构体的共同点：

- 定义属性以存储值
- 定义方法以提供功能
- 定义下标以提供下标语法访问其值
- 定义构造器以设置其初始化状态
- 通过扩展以增加其默认实现功能
- 遵循协议以提供某种标准功能

类独有的功能：

- 继承让一个类可以继承另一个类的特征
- 类型转换让你在运行时可以检查和解释一个类实例
- 析构器让一个类的实例可以释放任何被其所分配的资源
- 引用计数允许对一个类实例进行多次引用

> 一般来说，更推荐使用结构体和枚举，因为他们  更加容易进行推断

## 类和结构体的定义

```
// 定义结构体
struct SomeStructure {
  var width = 0
  var height  0
}
// 定义类
class SomeClass {
  var interlaced = false
  var frameRate = 0.0
}
```

> ⚠️ 类名使用 UpperCamelCase 命名法,属性和方法使用 lowerCamelCase 命名法

## 结构体与类实例

```
let someResolution = Resolution()
let someVideoMode = VideoMode()
```

## 访问属性

可以使用点语法来访问一个实例的属性， 也可以使用点语法给变量属性赋值

```
print("The width of someVideoMode is \(someVideoMode.resolution.width)")
someVideoMode.resolution.width = 1280
```

## 结构体类型的成员构造器

结构体有一个默认成员构造器，但是类没有。

```
let vga = Resolution(width: 640, height: 480)
```

## 值类型的结构体和枚举

> 值类型是一种赋值给变量或常量，或传递给函数时，值会被拷贝的类型。

swift 中所有的基本类型，包括 整数，浮点数，布尔，字符串，数组和字典 他们都是值类型，底层都是以结构体实现的。

swift 中所有的结构体和枚举都是值类型。

```
let hd = Resolution(width: 1920, height: 1080)
var cinema = hd //值拷贝
cinema.width = 2048
print("cinema is now \(cinema.width) pixels wide") // 新的值 2048
print("hd is still \(hd.width) pixels wide") // 没变还是1920
```

## 类是引用类型

> 与值类型不同，赋值给变量或常量，或是传递给函数时，引用类型并不会拷贝。引用的不是副本而是已经存在的实例。

```
let tenEighty = VideoMode()
tenEighty.resolution = hd
tenEighty.interlaced = true
tenEighty.name = "1080i"
tenEighty.frameRate = 25.0

let alsoTenEighty = tenEighty
alsoTenEighty.frameRate = 30.0

print("The frameRate property of tenEighty is now \(tenEighty.frameRate)") // 30
```

因为类是引用类型,所以其实 `tenEighty` and `alsoTenEighty`引用了同一个`VideoMode` 实例。 实际上他们只是两个不同名字的  相同实例。如下图：

![](https://ioscaffcdn.phphub.org/uploads/images/201807/18/1/ZPCWi7DUFG.png?imageView2/2/w/1340/h/0)

> 注意 `tenEighty` 和 `alsoTenEighty`声明的是常量而不是变量。但是你仍然可以改变 `tenEighty.frameRate` 和 `alsoTenEighty.frameRate`，因为常量 `tenEighty`和 `alsoTenEighty` 的值自身实际上没有改变。`tenEighty` 和 `alsoTenEighty` 本身并不存储 VideoMode 的实例，他们都只是在底层引用了`VideoMode` 的实例。改变的是 `VideoMode`的属性 `frameRate` ，而不是引用 `VideoMode`的常量的值。

## 恒等运算符

因为类是引用类型， 在底层可能有多个常量和变量引用同一个类的实例。 有时需要找出两个常量或变量是否引用同一个类的实例, 可以使用下面的方法

- 等价于 ===
- 非等于 ===

```
if tenEighty === alsoTenEighty {
    print("tenEighty and alsoTenEighty refer to the same VideoMode instance.")
}
```
