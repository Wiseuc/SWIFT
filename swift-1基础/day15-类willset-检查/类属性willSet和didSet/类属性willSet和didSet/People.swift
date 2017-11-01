//
//  People.swift
//  类属性willSet和didSet
//
//  Created by umi on 2017/10/17.
//  Copyright © 2017年 wiseuc. All rights reserved.
//

import UIKit

class People{

    var name = "" {
        willSet
        {
            print("新值 \(newValue) ")
            
        }
        didSet
        {
            print("旧值：\(oldValue)")
        }
    }
    
}
