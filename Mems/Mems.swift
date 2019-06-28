//
//  Mems.swift
//  Mems
//
//  Created by MJ Lee on 2019/6/22.
//  Copyright © 2019 MJ Lee. All rights reserved.
//

import Foundation

public enum MemAlign : Int {
    case one = 1, two = 2, four = 4, eight = 8
}

private let _EMPTY_PTR = UnsafeRawPointer(bitPattern: 0x1)!

/// 辅助查看内存的小工具类
public struct Mems<T> {
    private static func _memStr(_ ptr: UnsafeRawPointer,
                                _ size: Int,
                                _ aligment: Int) ->String {
        if ptr == _EMPTY_PTR {
            return ""
        }
        
        var rawPtr = ptr
        var string = ""
        let fmt = "0x%0\(aligment << 1)lx"
        let count = size / aligment
        for i in 0..<count {
            if i > 0 {
                string.append(" ")
                rawPtr = rawPtr.advanced(by: aligment)
            }
            let value: CVarArg
            switch aligment {
            case MemAlign.eight.rawValue:
                value = rawPtr.assumingMemoryBound(to: UInt64.self).pointee
            case MemAlign.four.rawValue:
                value = rawPtr.assumingMemoryBound(to: UInt32.self).pointee
            case MemAlign.two.rawValue:
                value = rawPtr.assumingMemoryBound(to: UInt16.self).pointee
            default:
                value = rawPtr.assumingMemoryBound(to: UInt8.self).pointee
            }
            string.append(String(format: fmt, value))
        }
        return string
    }
    
    private static func _memBytes(_ ptr: UnsafeRawPointer,
                                  _ size: Int) -> [UInt8] {
        var arr: [UInt8] = []
        if ptr == _EMPTY_PTR {
            return arr
        }
        for i in 0..<size {
            arr.append(ptr.advanced(by: i).assumingMemoryBound(to: UInt8.self).pointee)
        }
        return arr
    }
    
    /// 获得变量的内存数据（字节数组格式）
    public static func memBytes(ofVal v: inout T) -> [UInt8] {
        return _memBytes(ptr(ofVal: &v), MemoryLayout.stride(ofValue: v))
    }
    
    /// 获得引用所指向的内存数据（字节数组格式）
    public static func memBytes(ofRef v: T) -> [UInt8] {
        let p = ptr(ofRef: v)
        return _memBytes(p, malloc_size(p))
    }
    
    /// 获得变量的内存数据（字符串格式）
    ///
    /// - Parameter alignment: 决定了多少个字节为一组
    public static func memStr(ofVal v: inout T, alignment: MemAlign? = nil) -> String {
        let p = ptr(ofVal: &v)
        return _memStr(p, MemoryLayout.stride(ofValue: v),
                       alignment != nil ? alignment!.rawValue : MemoryLayout.alignment(ofValue: v))
    }
    
    /// 获得引用所指向的内存数据（字符串格式）
    ///
    /// - Parameter alignment: 决定了多少个字节为一组
    public static func memStr(ofRef v: T, alignment: MemAlign? = nil) -> String {
        let p = ptr(ofRef: v)
        return _memStr(p, malloc_size(p),
                       alignment != nil ? alignment!.rawValue : MemoryLayout.alignment(ofValue: v))
    }
    
    /// 获得变量的内存地址
    public static func ptr(ofVal v: inout T) -> UnsafeRawPointer {
        return MemoryLayout.size(ofValue: v) == 0 ? _EMPTY_PTR : withUnsafePointer(to: &v) {
            UnsafeRawPointer($0)
        }
    }
    
    /// 获得引用所指向内存的地址
    public static func ptr(ofRef v: T) -> UnsafeRawPointer {
        if v is Array<Any> {
            var arr = v
            return UnsafeRawPointer(bitPattern: ptr(ofVal: &arr).assumingMemoryBound(to: UInt.self).pointee)!
        } else if v is String {
            var str = v
            var mstr = str as! String
            if mstr.memType() != StringMemType.heap {
                return _EMPTY_PTR
            }
            return UnsafeRawPointer(bitPattern: ptr(ofVal: &str).advanced(by: 8).assumingMemoryBound(to: UInt.self).pointee)!
        } else if type(of: v) is AnyClass || v is AnyClass {
            return UnsafeRawPointer(Unmanaged.passUnretained(v as AnyObject).toOpaque())
        } else {
            return _EMPTY_PTR
        }
    }
    
    /// 获得变量所占用的内存大小
    public static func size(ofVal v: inout T) -> Int {
        return MemoryLayout.size(ofValue: v) > 0 ? MemoryLayout.stride(ofValue: v) : 0
    }
    
    /// 获得引用所指向内存的大小
    public static func size(ofRef v: T) -> Int {
        return malloc_size(ptr(ofRef: v))
    }
}

public enum StringMemType : UInt8 {
    case text = 0xd0 // 静态数据
    case taggerPtr = 0xe0 // taggerPointer
    case heap = 0xf0 // 堆空间
}

extension String {
    mutating func memType() -> StringMemType {
        let bytes = Mems.memBytes(ofVal: &self)
        if (bytes.last! & 0xf0) == StringMemType.taggerPtr.rawValue {
            return .taggerPtr
        }
        return (bytes[7] & 0xf0) == StringMemType.text.rawValue ? .text : .heap
    }
}
