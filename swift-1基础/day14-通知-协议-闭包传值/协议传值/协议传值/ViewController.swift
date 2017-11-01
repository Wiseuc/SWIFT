//
//  ViewController.swift
//  协议传值
//
//  Created by umi on 2017/10/17.
//  Copyright © 2017年 wiseuc. All rights reserved.
//

import UIKit

class ViewController: UIViewController,JHViewController2Delegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let vc = ViewController2()
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func jhProtocolAction(name: String, age: Int) {
        print("name:\(name)   age:\(age)")
    }
    
}

