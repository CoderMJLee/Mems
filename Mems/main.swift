//
//  main.swift
//  Mems
//
//  Created by MJ Lee on 2019/6/22.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import Foundation

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
