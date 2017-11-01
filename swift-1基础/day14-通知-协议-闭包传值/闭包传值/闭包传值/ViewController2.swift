//
//  ViewController2.swift
//  闭包传值
//
//  Created by umi on 2017/10/17.
//  Copyright © 2017年 wiseuc. All rights reserved.
//

import UIKit
typealias ViewController2Block = (_ name:String)->()

class ViewController2: UIViewController {
    
    fileprivate var viewControllerBlock : ViewController2Block?
    func viewControllerBlock(_ completed: @escaping ViewController2Block) {
        self.viewControllerBlock = completed
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.gray
        // Do any additional setup after loading the view.
    }

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.viewControllerBlock!("jianghai")
        
        self.dismiss(animated: true, completion: nil)
    }
}
