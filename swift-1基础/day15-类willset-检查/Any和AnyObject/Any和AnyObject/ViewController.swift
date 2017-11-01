//
//  ViewController.swift
//  Any和AnyObject
//
//  Created by umi on 2017/10/17.
//  Copyright © 2017年 wiseuc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        var arrs = [Any]()

        arrs.append(3)
        arrs.append(3.224)
        arrs.append("hello")
        arrs.append((3.2,4.6))
        
        
        for item in arrs {
            
            switch item {
            case let someInt as Int:
                print("INT= \(someInt)")
                
            case let someDouble as Double:
                print("Double= \(someDouble)")
                
            case let someString as String:
                print("String= \(someString)")
                
            case let (x,y) as (Double,Double):
                print("(x,y): <\(x),\(y)>")
                
            default:
                print("其他类型")
            }
        }
        
        
        
        for item in arrs {
            
            if let inter = item as? Int {
                print(inter)
            }
            
            if let inter = item as? Double {
                print(inter)
            }
            
            if let inter = item as? String {
                print(inter)
            }
            
            if let inter = item as? (Double,Double) {
                print(inter)
            }
        }
        
        
    }

    
    

}

