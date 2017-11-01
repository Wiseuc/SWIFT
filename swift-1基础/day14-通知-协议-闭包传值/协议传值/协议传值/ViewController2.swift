//
//  ViewController2.swift
//  协议传值
//
//  Created by umi on 2017/10/17.
//  Copyright © 2017年 wiseuc. All rights reserved.
//

import UIKit


protocol JHViewController2Delegate {
    //static func jhProtocolAction2() ->String //类方法
    func jhProtocolAction(name:String ,age:Int) -> Void        //对象方法
}

class ViewController2: UIViewController {
    
    var delegate : JHViewController2Delegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if( delegate != nil)
        {
            delegate!.jhProtocolAction(name: "jianghai", age: 25)
            self.dismiss(animated: true, completion: nil)
        }
    }
    

}
