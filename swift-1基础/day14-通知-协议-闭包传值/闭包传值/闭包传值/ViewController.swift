//
//  ViewController.swift
//  闭包传值
//
//  Created by umi on 2017/10/17.
//  Copyright © 2017年 wiseuc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }


    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let vc = ViewController2()
        
        self.present(vc, animated: true, completion: nil)
        
        vc.viewControllerBlock { (name) in
            
            print("name:\(name)")
        }
    }

}

