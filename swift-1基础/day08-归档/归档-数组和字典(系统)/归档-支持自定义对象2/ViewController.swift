//
//  ViewController.swift
//  归档-支持自定义对象2
//
//  Created by umi on 2017/10/14.
//  Copyright © 2017年 wiseuc. All rights reserved.
//

import UIKit


//let path ="\(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
//FileManager.SearchPathDomainMask.userDomainMask,true).first!)/userAccount.data"

let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]

let filePath = "\(path)/userAccount.data"




class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        xxxxxx()
    }
    
    
    func xxxxxx()  {
                
        //字典
//        let dict = ["1":"aa" ,"2":"bb" ,"3":"cc"]
//        
//        let data = NSKeyedArchiver.archivedData(withRootObject: dict)
//        let bool = NSKeyedArchiver.archiveRootObject(data, toFile: NSHomeDirectory().appending("/book.data"))
//        print(bool)
//        
//        let data2:Data = NSKeyedUnarchiver.unarchiveObject(withFile: NSHomeDirectory().appending("/book.data")) as! Data
//        let dict2:[String : String] = NSKeyedUnarchiver.unarchiveObject(with: data2) as! [String : String]
//        print(dict2)
        
        
        
        
//        //模型
//        let arr:[UInt64] = [1,2,3,4]
//        let obj = ArchiverArray.init(values: arr)
//        let path = NSHomeDirectory().appending("/book.data")
//        
//        //压成二进制
//        //归档
//        let data = NSKeyedArchiver.archivedData(withRootObject: obj)
//        let bool = NSKeyedArchiver.archiveRootObject(data, toFile: path)
//        print(bool)
//        
//        //获取二进制
//        //获取模型
//        let data2 = NSKeyedUnarchiver.unarchiveObject(withFile: path) as! Data
//        let obj2:ArchiverArray = NSKeyedUnarchiver.unarchiveObject(with: data2) as! ArchiverArray
//        print(obj2.values)
    }

}

