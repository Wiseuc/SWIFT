//
//  ViewController.swift
//  string开始位置和长度
//
//  Created by umi on 2017/10/12.
//  Copyright © 2017年 wiseuc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.xxxxx()
    }

    
    func xxxxx() {
        let str = "aaaaaabbbbbb"
        let range:Range = str.range(of: "ab")!
        let str2 = str.substring(with: range)
        
        print(str2)
    }

}

