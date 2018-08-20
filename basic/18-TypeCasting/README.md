# 类型转换

`类型转换` 是一种检查实例类型的方法，同时也能够将该实例转为其类继承关系中其他的父类或子类。

Swift 中的类型转换是通过 `is` 和 `as` 运算符实现的。

- 检查值的类型 -> is
- 转换为其他类型 -> as
- 检查类型是否符合协议

# 定义一个类结构作为类型转换示例

```
class MediaItem {
    var name: String
    init(name: String) {
        self.name = name
    }
}

class Movie: MediaItem {
    var director: String
    init(name: String, director: String) {
        self.director = director
        super.init(name: name)
    }
}

class Song: MediaItem {
    var artist: String
    init(name: String, artist: String) {
        self.artist = artist
        super.init(name: name)
    }
}

let library = [
    Movie(name: "Casablanca", director: "Michael Curtiz"),
    Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
    Movie(name: "Citizen Kane", director: "Orson Welles"),
    Song(name: "The One And Only", artist: "Chesney Hawkes"),
    Song(name: "Never Gonna Give You Up", artist: "Rick Astley")
]
// 「library」的类型被推断为 [MediaItem]
```

虽然实际存储在 `library` 中的项目仍然是 `Movie` 和 `Song` 的实例。 但是当你迭代此数组时，你将得到 `MediaItem` 类型的实例，而不是`Movie` 或 `Song` 。 为了把它们作为原类型使用，你需要 `检查` 它们的类型，或者将他们 `强转` 为其他类型。

## 类型检查

使用 类型检查运算符（ `is` ）来检查实例是否属于某个特定子类型。 如果实例属于该子类型，则类型检查运算符将返回 true ，否则，将返回 false 。

```
var movieCount = 0
var songCount = 0

for item in library {
    if item is Movie {
        movieCount += 1
    } else if item is Song {
        songCount += 1
    }
}
```

## 强制转型

实际上某个类型的常量或变量可能本来就是某个子类的实例。当确认是这种情况情况时，你可以尝试使用 类型强制转换运算符 （ as? 或 as! ）将该常量或变量 `强制转换` 成子类型。

由于强制转换可能会失败，因该类型转换运算符有两种不同的形式。条件形式 as? 会返回你尝试强制转换的类型的可选值。强制形式 as! 则会尝试强制转换，并同时将结果强制解包。

```
for item in library {
    if let movie = item as? Movie {
        print("Movie: \(movie.name), dir. \(movie.director)")
    } else if let song = item as? Song {
        print("Song: \(song.name), by \(song.artist)")
    }
}
```

> ⚠️ 转换实际上不会变更实例或修改其值。原本的实例保持不变；我们仅仅把它看作是它类型的实例，对其进行简单地处理和访问。

## 对 Any 和 AnyObject 做类型转换

Swift 提供了两种特殊的类型来处理非特定类型：

- `Any` 可以表示任何类型的实例，包括函数类型。
- `AnyObject` 可以表示任何类类型的实例。

有在明确需要 `Any` 或 `AnyObject` 所提供的行为和功能时才使用他们。 最好在你的代码中明确需要使用的类型。

```
var things = [Any]()

things.append(0)
things.append(0.0)
things.append(42)
things.append(3.14159)
things.append("hello")
things.append((3.0, 5.0))
things.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))
things.append({ (name: String) -> String in "Hello, \(name)" })
```

如果要查看一个常量或变量的具体类型，但只知道它的类型是 `Any` 或 `AnyObject` ，可以在 `switch` 分句中使用 `is` 或 `as` 模式。

```
for thing in things {
    switch thing {
    case 0 as Int:
        print("zero as an Int")
    case 0 as Double:
        print("zero as a Double")
    case let someInt as Int:
        print("an integer value of \(someInt)")
    case let someDouble as Double where someDouble > 0:
        print("a positive double value of \(someDouble)")
    case is Double:
        print("some other double value that I don't want to print")
    case let someString as String:
        print("a string value of \"\(someString)\"")
    case let (x, y) as (Double, Double):
        print("an (x, y) point at \(x), \(y)")
    case let movie as Movie:
        print("a movie called \(movie.name), dir. \(movie.director)")
    case let stringConverter as (String) -> String:
        print(stringConverter("Michael"))
    default:
        print("something else")
    }
}
```

`Any` 类型表示任何类型的值，包括可选类型。 如果程序需要一个类型为 `Any` 的值，而你却使用了可选类型，Swift 会向你发出警告。 如果你确实需要将可选值作为 `Any` 使用，可以使用 `as` 操作符将可选类型显式地转换为 `Any` 类型，如下所示。

```
let optionalNumber: Int? = 3
things.append(optionalNumber)        // 警告
things.append(optionalNumber as Any) // 没有警告
```
