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

// 整型数据
var int8: Int8 = 10
show(val: &int8)

var int16: Int16 = 10
show(val: &int16)

var int32: Int32 = 10
show(val: &int32)

var int64: Int64 = 10
show(val: &int64)

// 枚举类型
enum TestEnum {
    case test1(Int)
    case test2(Bool)
}
var e = TestEnum.test1(10)
show(val: &e)

// 结构体
struct Date {
    var year = 10
    var test = true
    var month = 20
    var day = 30
}
var s = Date()
show(val: &s)

// 对象
class Point  {
    var x = 11
    var test = true
    var y = 22
}
var p = Point()
show(val: &p)
show(ref: p)

// 数组
var arr = [1, 2, 3, 4]
show(val: &arr)
show(ref: arr)
```

- 打印结果如下

```shell
-------------- Int8 --------------
变量的地址: 0x0000000100007598
变量的内存: 0x0a
变量的大小: 1

-------------- Int16 --------------
变量的地址: 0x000000010000759a
变量的内存: 0x000a
变量的大小: 2

-------------- Int32 --------------
变量的地址: 0x000000010000759c
变量的内存: 0x0000000a
变量的大小: 4

-------------- Int64 --------------
变量的地址: 0x00000001000075a0
变量的内存: 0x000000000000000a
变量的大小: 8

-------------- TestEnum --------------
变量的地址: 0x00000001000075a8
变量的内存: 0x000000000000000a 0x0000000000000000
变量的大小: 16

-------------- Date --------------
变量的地址: 0x00000001000075b8
变量的内存: 0x000000000000000a 0x0000000000000001 0x0000000000000014 0x000000000000001e
变量的大小: 32

-------------- Point --------------
变量的地址: 0x00000001000075d8
变量的内存: 0x000000010055a6f0
变量的大小: 8

-------------- Point --------------
对象的地址: 0x000000010055a6f0
对象的内存: 0x00000001000072d8 0x0000000200000002 0x000000000000000b 0x0000000000000001 0x0000000000000016 0x0000000000000000
对象的大小: 48

-------------- Array<Int> --------------
变量的地址: 0x00000001000075e0
变量的内存: 0x000000010055aa80
变量的大小: 8

-------------- Array<Int> --------------
对象的地址: 0x000000010055aa80
对象的内存: 0x00007fff95321848 0x0000000200000002 0x0000000000000004 0x0000000000000008 0x0000000000000001 0x0000000000000002 0x0000000000000003 0x0000000000000004
对象的大小: 64
```
