//
//  ViewController.swift
//  复制层
//
//  Created by umi on 2017/10/19.
//  Copyright © 2017年 wiseuc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    var view01 = UIView.init(frame: CGRect.init(x: 0, y: 100, width: 370, height: 500))
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view01.backgroundColor = UIColor.lightGray
        self.view.addSubview(view01)
        
        
        //添加复制层
        let replyLayer = CAReplicatorLayer.init()
        replyLayer.frame = self.view01.bounds
        replyLayer.instanceCount = 8
        replyLayer.instanceDelay = 1
        replyLayer.instanceTransform = CATransform3DMakeTranslation(40, 0, 0)
        self.view01.layer.addSublayer(replyLayer)
        
        
        
        let layer = CALayer.init()
        layer.backgroundColor = UIColor.green.cgColor
        layer.bounds = CGRect.init(x: 0, y: 0, width: 20, height: 100)
        layer.anchorPoint = CGPoint.init(x: 0, y: 1)
        layer.position = CGPoint.init(x: 0, y: self.view01.bounds.size.height)
        replyLayer.addSublayer(layer)
        
        
        //动画
        let anim = CABasicAnimation.init()
        anim.keyPath = "transform.scale.y"
        anim.toValue = 0
        anim.repeatCount = MAXFLOAT
        anim.duration = 1
        anim.autoreverses = true
        layer.add(anim, forKey: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

