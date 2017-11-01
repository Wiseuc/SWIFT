//
//  People.swift
//  归档-支持自定义对象2
//
//  Created by umi on 2017/10/14.
//  Copyright © 2017年 wiseuc. All rights reserved.
//

import UIKit

class People: NSObject,NSCoding {

    var name : String?
    var source : NSNumber?
    var age : Int64?
    
    
    
    
    required init(coder decoder: NSCoder) {
        super.init()
        name = decoder.decodeObject(forKey: "name") as? String
        source = decoder.decodeObject(forKey: "source") as? NSNumber
        age = decoder.decodeInt64(forKey: "age") as Int64
    }
    public func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(source, forKey: "source")
        coder.encode(age, forKey: "age")
    }
}
