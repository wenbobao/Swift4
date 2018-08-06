# 集合类型

Swift 语言提供`Arrays`、`Sets`和`Dictionaries`三种基本的集合类型用来存储集合数据。

- 数组（Arrays）是有序数据的集。
- 集合（Sets）是无序无重复数据的集。
- 字典（Dictionaries）是无序的键值对的集。

> ⚠️ 集合中存储的数据值类型必须明确。

## 数组

数组使用有序列表存储同一类型的多个值。相同的值可以多次出现在一个数组的不同位置中。

### 创建一个空数组

```
var someInts = [Int]()
```

### 将数组置为空

```
someInts.append(3)
// someInts 现在包含一个 Int 值
someInts = []
// someInts 现在是空数组，但是仍然是 [Int] 类型的。
```

