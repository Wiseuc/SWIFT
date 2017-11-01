//
//  ViewController.swift
//  获取string长度
//
//  Created by umi on 2017/10/12.
//  Copyright © 2017年 wiseuc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.获取字符串长度()
    }

    
    func 获取字符串长度() {
        let str = "aaaaaabbbbbb"
        
        let count = str.characters.count
        
        print(count)
    }
    
    
}

