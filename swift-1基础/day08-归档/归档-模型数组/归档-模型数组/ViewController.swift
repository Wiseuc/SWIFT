//
//  ViewController.swift
//  归档-模型数组
//
//  Created by umi on 2017/10/16.
//  Copyright © 2017年 wiseuc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var arr:[People] = []
        
        
        for _ in 0..<5 {
            let model = People()
            model.name = "FlyChang"
            model.age = 25
            arr.append(model)
        }
        let arr2 = ArchiverArray.init(blogList: arr)
        
        
        //归档
        let data1 = NSKeyedArchiver.archivedData(withRootObject: arr2)
        let boo1 = NSKeyedArchiver.archiveRootObject(data1, toFile: NSHomeDirectory().appending("/book.data"))
        print(boo1)
        
        //解档
        let data2:Data = NSKeyedUnarchiver.unarchiveObject(withFile: NSHomeDirectory().appending("/book.data")) as! Data
        let arr3:ArchiverArray = NSKeyedUnarchiver.unarchiveObject(with: data2) as! ArchiverArray
        
        for item in arr3.blogList {
            print(item.name)
            print(item.age)
        }
    }

}

