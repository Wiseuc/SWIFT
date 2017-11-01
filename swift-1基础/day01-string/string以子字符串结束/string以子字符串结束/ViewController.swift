//
//  ViewController.swift
//  string以子字符串结束
//
//  Created by umi on 2017/10/12.
//  Copyright © 2017年 wiseuc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.字符串以子字符串开头()
        self.字符串以子字符串结束()
    }
    
    func 字符串以子字符串结束() {
        let str = "aaaaaabbbbbb"
        
        if str.hasPrefix("aa") {
            print("以xx开头")
        }
    }
    
    
    func 字符串以子字符串开头() {
        let str = "aaaaaabbbbbb"
        if str.hasSuffix("bb") {
            print("以xx结束")
        }
    }
    
}













