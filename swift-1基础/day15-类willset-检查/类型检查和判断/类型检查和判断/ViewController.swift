//
//  ViewController.swift
//  类型检查和判断
//
//  Created by umi on 2017/10/17.
//  Copyright © 2017年 wiseuc. All rights reserved.
//

import UIKit

class People {
    
    var name = ""
    var age = 0
    
    init(name:String ,age:Int) {
        self.name = name
        self.age = age
    }
}


class Man: People {
    var aa = ""
    
    init(name:String ,age:Int ,aa:String) {
        self.aa = aa
        super.init(name: name, age: age)
    }
}


class Woman: People {
    var bb = ""
    init(name:String ,age:Int ,bb:String) {
        self.bb = bb
        super.init(name: name, age: age)
    }
    
}



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let man = Man.init(name: "ccc", age: 44, aa: "444")
        let woman = Woman.init(name: "bbbb", age: 443, bb: "2222")

        let arr:[AnyObject] = [man,woman]
        
        
        for item in arr {
            
            if item is People {
                print("women")
            }
            
            if item is People {
                print("man")
            }
        }
        
        
        
        for item in arr {
            
            if item is Woman {
                print("women")
            }
            
            if item is Man {
                print("man")
            }
        }
        
        
        for item in arr {
            
            if let man = item as? Man {
                print(man.aa)
            }
            
            if let woman = item as? Woman {
                print(woman.bb)
            }
        }
        
    }

}

