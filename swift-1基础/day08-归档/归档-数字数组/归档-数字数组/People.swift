//
//  People.swift
//  归档-数字数组
//
//  Created by umi on 2017/10/16.
//  Copyright © 2017年 wiseuc. All rights reserved.
//

import UIKit


class People: NSObject ,NSCoding {
    var values: [UInt64] = []
    
    init(values : [UInt64]) {
        self.values = values
    }
    
    // MARK: - NSCoding
    required init(coder decoder: NSCoder) {
        super.init()
        var count = 0
        if let ptr = decoder.decodeBytes(forKey: "values", returnedLength: &count) {
            let numValues = count / MemoryLayout<UInt64>.stride
            ptr.withMemoryRebound(to: UInt64.self, capacity: numValues) {
                let buf = UnsafeBufferPointer<UInt64>(start: UnsafePointer($0), count: numValues)
                values = Array(buf)
            }
        }
    }
    public func encode(with coder: NSCoder) {
        let numBytes = values.count * MemoryLayout<UInt64>.stride
        values.withUnsafeBufferPointer {
            $0.baseAddress!.withMemoryRebound(to: UInt8.self, capacity: numBytes) {
                coder.encodeBytes($0, length: numBytes, forKey: "values")
            }
        }
    }
}
