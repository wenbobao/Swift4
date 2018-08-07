# 继承

类可以继承。

子类可以调用和访问父类的方法，属性，和下标。还可以重写这些方法，属性，和下标来优化或修改它们的行为。

子类还可以给继承的属性添加属性观察器，以便在属性值发生变化时得到通知。属性观察器可以被添加到任何属性，不管它原始定义是存储属性还是计算属性。

## 定义一个基类

不继承任何类的类被称为基类

> ⚠️ Swift 中的类并不继承自一个统一的类。定义类时如果不指定父类那么该类自动成为基类。

```
class Vehicle {
    var currentSpeed = 0.0 //存储属性
    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    } //只读计算属性
    func makeNoise() {
        // 空方法，不是所有车辆都发出噪音
    }
}
```

## 子类化

```
lass Bicycle: Vehicle {
    var hasBasket = false
}
```

## 重写

一个子类可以对实例方法，类方法，实例属性，类属性，或下标进行自定义实现。

重写从父类继承的特性，需要添加`override`前缀。

## 访问父类的方法，属性，和下标

使用`super`前缀访问父亲的方法，属性和下标。

### 重写方法

```
class Train: Vehicle {
    override func makeNoise() {
        print("Choo Choo")
    }
}
```

## 重写属性的 Getters 和 Setters

无论继承的属性原来是存储属性还是计算属性，都可以提供自定义的 `getter`（如果 setter 适用，也包括 setter）来重写任何继承属性。子类不知道继承的属性是存储属性还是计算属性，子类只知道继承的属性具有特定的名称和类型。你必须始终声明要重写的属性的名称和类型，以使编译器能够检查你重写的属性是否与具有相同名称和类型的父类属性匹配。

通过在子类属性中重写 `getter` 和 `setter`，可以将继承的只读属性重写为读写属性，但是，你不能将继承的读写属性重写为只读属性。

> 如果你重写属性的 `setter` 就必须同时重写属性的 `getter`。如果你不想在重写 `getter` 中修改继承属性的值，你可以简单地在 `getter` 中返回 `super.someProperty`，其中 `someProperty` 是你想要重写的属性名称。

```
class Car: Vehicle {
    var gear = 1
    override var description: String {
        return super.description + " in gear \(gear)"
    }
}
```

## 重写属性观察者

> 你不能给常量存储属性或只读属性增加属性观察者。 因为这些属性值不能被修改，所以它是不能提供 `willSet` 或 `didSet` 的重写实现。<br>
> 当然，你不能为同一个属性同时提供 `setter` 重写和 `didSet` 观察者。 如果你想观察这个属性值的改变，并且你已经为这个属性提供了一个重写的 setter 方法，那么你能在这个自定义 setter 方法里观察到它任何值的改变。

```
class AutomaticCar: Car {
    override var currentSpeed: Double {
        didSet {
            gear = Int(currentSpeed / 10.0) + 1
        }
    }
}
```

## 防止重写

你可以通过标记方法、属性或下标为 `final` 来防止它被重写。

最佳实践: `添加到类扩展中的方法、属性或下标页可以在扩展中标记为 final。`

可以在类的定义 `class` 关键词 前添加 `final` 修饰符将整个类标记为 final, 任何对标记为 `final` 的类进行继承的子类都会在编译时报错。
