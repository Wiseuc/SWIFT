//
//  ArchiverArray.swift
//  归档-支持自定义对象2
//
//  Created by umi on 2017/10/16.
//  Copyright © 2017年 wiseuc. All rights reserved.
//

import UIKit

class ArchiverArray: NSObject , NSCoding {
    var values: [UInt64] = []
    
    init(values : [UInt64]) {
        self.values = values
    }
    
    
    // MARK: - NSCoding
    required init(coder decoder: NSCoder) {
        super.init()
        var count = 0
        // decodeBytesForKey() returns an UnsafePointer<UInt8>?, pointing to immutable data.
        if let ptr = decoder.decodeBytes(forKey: "values", returnedLength: &count) {
            // If we convert it to a buffer pointer of the appropriate type and count ...
            let numValues = count / MemoryLayout<UInt64>.stride
            ptr.withMemoryRebound(to: UInt64.self, capacity: numValues) {
                let buf = UnsafeBufferPointer<UInt64>(start: UnsafePointer($0), count: numValues)
                // ... then the Array creation becomes easy.
                values = Array(buf)
            }
        }
    }
    
    public func encode(with coder: NSCoder) {
        // This encodes both the number of bytes and the data itself.
        let numBytes = values.count * MemoryLayout<UInt64>.stride
        values.withUnsafeBufferPointer {
            $0.baseAddress!.withMemoryRebound(to: UInt8.self, capacity: numBytes) {
                coder.encodeBytes($0, length: numBytes, forKey: "values")
            }
        }
    }
}
