# Mems
>  Utils for viewing memory in Swift.
>
> 用来窥探Swift内存的小工具



## 用法

```swift
func show<T>(val: inout T) {
    print("-------------- \(type(of: val)) --------------")
    print("变量的地址:", Mems.ptr(ofVal: &val))
    print("变量的内存:", Mems.memStr(ofVal: &val))
    print("变量的大小:", Mems.size(ofVal: &val))
    print("")
}

func show<T>(ref: T) {
    print("-------------- \(type(of: ref)) --------------")
    print("对象的地址:", Mems.ptr(ofRef: ref))
    print("对象的内存:", Mems.memStr(ofRef: ref))
    print("对象的大小:", Mems.size(ofRef: ref))
    print("")
}
```

### 整型

```swift
var int8: Int8 = 10
show(val: &int8)
// -------------- Int8 --------------
// 变量的地址: 0x00007ffeefbff598
// 变量的内存: 0x0a
// 变量的大小: 1

var int16: Int16 = 10
show(val: &int16)
// -------------- Int16 --------------
// 变量的地址: 0x00007ffeefbff590
// 变量的内存: 0x000a
// 变量的大小: 2

var int32: Int32 = 10
show(val: &int32)
// -------------- Int32 --------------
// 变量的地址: 0x00007ffeefbff588
// 变量的内存: 0x0000000a
// 变量的大小: 4

var int64: Int64 = 10
show(val: &int64)
// -------------- Int64 --------------
// 变量的地址: 0x00007ffeefbff580
// 变量的内存: 0x000000000000000a
// 变量的大小: 8
```

### 枚举

```swift
enum TestEnum {
  case test1(Int, Int, Int)
  case test2(Int, Int)
  case test3(Int)
  case test4(Bool)
  case test5
}

var e = TestEnum.test1(1, 2, 3)
show(val: &e)
// -------------- TestEnum --------------
// 变量的地址: 0x00007ffeefbff580
// 变量的内存: 0x0000000000000001 0x0000000000000002 0x0000000000000003 0x0000000000000000
// 变量的大小: 32

e = .test2(4, 5)
show(val: &e)
// -------------- TestEnum --------------
// 变量的地址: 0x00007ffeefbff580
// 变量的内存: 0x0000000000000004 0x0000000000000005 0x0000000000000000 0x0000000000000001
// 变量的大小: 32

e = .test3(6)
show(val: &e)
// -------------- TestEnum --------------
// 变量的地址: 0x00007ffeefbff580
// 变量的内存: 0x0000000000000006 0x0000000000000000 0x0000000000000000 0x0000000000000002
// 变量的大小: 32

e = .test4(true)
show(val: &e)
// -------------- TestEnum --------------
// 变量的地址: 0x00007ffeefbff580
// 变量的内存: 0x0000000000000001 0x0000000000000000 0x0000000000000000 0x0000000000000003
// 变量的大小: 32

e = .test5
show(val: &e)
// -------------- TestEnum --------------
// 变量的地址: 0x00007ffeefbff580
// 变量的内存: 0x0000000000000000 0x0000000000000000 0x0000000000000000 0x0000000000000004
// 变量的大小: 32
```

### 结构体

```swift
struct Date {
  var year = 10
  var test = true
  var month = 20
  var day = 30
}

var s = Date()
show(val: &s)
// -------------- Date --------------
// 变量的地址: 0x00007ffeefbff580
// 变量的内存: 0x000000000000000a 0x0000000000000001 0x0000000000000014 0x000000000000001e
// 变量的大小: 32
```

### 类

```swift
class Point  {
  var x = 11
  var test = true
  var y = 22
}

var p = Point()
show(val: &p)
// -------------- Point --------------
// 变量的地址: 0x00007ffeefbff590
// 变量的内存: 0x0000000101023680
// 变量的大小: 8

show(ref: p)
// -------------- Point --------------
// 对象的地址: 0x0000000101023680
// 对象的内存: 0x00000001000072d8 0x0000000200000002 0x000000000000000b 0x3030303030303001 0x0000000000000016 0x0000000000000000
// 对象的大小: 48
```

### 数组

```swift
var arr = [1, 2, 3, 4]
show(val: &arr)
// -------------- Array<Int> --------------
// 变量的地址: 0x00007ffeefbff598
// 变量的内存: 0x0000000101023800
// 变量的大小: 8

show(ref: arr)
// -------------- Array<Int> --------------
// 对象的地址: 0x0000000101023800
// 对象的内存: 0x00007fff9c30f848 0x0000000200000002 0x0000000000000004 0x0000000000000008 0x0000000000000001 0x0000000000000002 0x0000000000000003 0x0000000000000004
// 对象的大小: 64
```

### 设置字节显示格式

```swift
var int64: Int64 = 10

print("1个字节为1组 :", Mems.memStr(ofVal: &int64, alignment: .one))
// 1个字节为1组 : 0x0a 0x00 0x00 0x00 0x00 0x00 0x00 0x00

print("2个字节为1组 :", Mems.memStr(ofVal: &int64, alignment: .two))
// 2个字节为1组 : 0x000a 0x0000 0x0000 0x0000

print("4个字节为1组 :", Mems.memStr(ofVal: &int64, alignment: .four))
// 4个字节为1组 : 0x0000000a 0x00000000

print("8个字节为1组 :", Mems.memStr(ofVal: &int64, alignment: .eight))
// 8个字节为1组 : 0x000000000000000a
```
