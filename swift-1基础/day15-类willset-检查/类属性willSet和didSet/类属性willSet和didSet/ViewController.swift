//
//  ViewController.swift
//  类属性willSet和didSet
//
//  Created by umi on 2017/10/17.
//  Copyright © 2017年 wiseuc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let model = People()
        
        model.name = "jianghai"
        
        model.name = "jianbghai991"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

