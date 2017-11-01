//
//  ViewController.swift
//  归档-数字数组
//
//  Created by umi on 2017/10/16.
//  Copyright © 2017年 wiseuc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        xxxxxx()
    }

    
    func xxxxxx()  {
        
        //模型
        let obj = People.init(values: [1,2,3,4])
        let path = NSHomeDirectory().appending("/book.data")
        
        //压成二进制
        //归档
        let data = NSKeyedArchiver.archivedData(withRootObject: obj)
        let bool = NSKeyedArchiver.archiveRootObject(data, toFile: path)
        print(bool)
        
        //获取二进制
        //获取模型
        let data2 = NSKeyedUnarchiver.unarchiveObject(withFile: path) as! Data
        let obj2:People = NSKeyedUnarchiver.unarchiveObject(with: data2) as! People
        print(obj2.values)
        
        
    }
}

