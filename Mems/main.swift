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

/// 整型
func showInt() {
    var int8: Int8 = 10
    show(val: &int8)
    
    var int16: Int16 = 10
    show(val: &int16)
    
    var int32: Int32 = 10
    show(val: &int32)
    
    var int64: Int64 = 10
    print(Mems.memStr(ofVal: &int64, alignment: .one))
    print(Mems.memStr(ofVal: &int64, alignment: .two))
    print(Mems.memStr(ofVal: &int64, alignment: .four))
    print(Mems.memStr(ofVal: &int64, alignment: .eight))
    
    show(val: &int64)
}

/// 枚举
func showEnum() {
    enum TestEnum {
        case test1(Int, Int, Int)
        case test2(Int, Int)
        case test3(Int)
        case test4(Bool)
        case test5
    }
    var e = TestEnum.test1(1, 2, 3)
    show(val: &e)
    e = .test2(4, 5)
    show(val: &e)
    e = .test3(6)
    show(val: &e)
    e = .test4(true)
    show(val: &e)
    e = .test5
    show(val: &e)
}

/// 结构体
func showStruct() {
    struct Date {
        var year = 10
        var test = true
        var month = 20
        var day = 30
    }
    var s = Date()
    show(val: &s)
}

// 类
func showClass() {
    class Point  {
        var x = 11
        var test = true
        var y = 22
    }
    var p = Point()
    show(val: &p)
    show(ref: p)
}

/// 数组
func showArray() {
    var arr = [1, 2, 3, 4]
    show(val: &arr)
    show(ref: arr)
}

func showByteFormat() {
    var int64: Int64 = 10
    print("1个字节为1组 :", Mems.memStr(ofVal: &int64, alignment: .one))
    print("2个字节为1组 :", Mems.memStr(ofVal: &int64, alignment: .two))
    print("4个字节为1组 :", Mems.memStr(ofVal: &int64, alignment: .four))
    print("8个字节为1组 :", Mems.memStr(ofVal: &int64, alignment: .eight))
}

showInt()
showEnum()
showStruct()
showClass()
showArray()
showByteFormat()
