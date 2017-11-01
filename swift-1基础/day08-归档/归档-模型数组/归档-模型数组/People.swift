//
//  People.swift
//  归档-模型数组
//
//  Created by umi on 2017/10/16.
//  Copyright © 2017年 wiseuc. All rights reserved.
//

import UIKit

class People: NSObject ,NSCoding {

    // 使用runtime属性前面必须加dynamic，并且是不可选类型，意思是允许动态更新属性
    dynamic var name = ""
    dynamic var age = 0
    
    override init() {
        
    }
    
    // 归档
    func encode(with aCoder: NSCoder) {
        var count: UInt32 = 0
        guard let ivars = class_copyIvarList(self.classForCoder, &count) else {
            return
        }
        for i in 0 ..< count {
            let ivar = ivars[Int(i)]
            let name = ivar_getName(ivar)
            
            let key = NSString.init(utf8String: name!)! as String
            
            if let value = self.value(forKey: key) {
                aCoder.encode(value, forKey: key)
            }
        }
        // 释放ivars
        free(ivars)
    }
    
    // 反归档
    required init?(coder aDecoder: NSCoder) {
        super.init()
        var count: UInt32 = 0
        guard let ivars = class_copyIvarList(self.classForCoder, &count) else {
            return
        }
        for i in 0 ..< count {
            let ivar = ivars[Int(i)]
            let name = ivar_getName(ivar)
            let key = NSString.init(utf8String: name!)! as String
            if let value = aDecoder.decodeObject(forKey: key) {
                self.setValue(value, forKey: key)
            }
        }
        // 释放ivars
        free(ivars)
    }
}
