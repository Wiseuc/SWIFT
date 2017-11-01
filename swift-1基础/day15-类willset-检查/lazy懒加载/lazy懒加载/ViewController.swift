//
//  ViewController.swift
//  lazy懒加载
//
//  Created by umi on 2017/10/17.
//  Copyright © 2017年 wiseuc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    lazy var datasource = Array<Any>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        print(String.init(format: "%p", self.datasource))
        print(String.init(format: "%p", self.datasource))
        print(String.init(format: "%p", self.datasource))
    }
}

