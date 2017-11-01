//
//  ViewController.swift
//  复制层-倒影
//
//  Created by umi on 2017/10/19.
//  Copyright © 2017年 wiseuc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let imageview = UIImageView.init(frame: CGRect.init(x: 20, y: 100, width: 200, height: 200))
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageview.image = UIImage.init(named: "4")
        
        
        let repL:CAReplicatorLayer = CAReplicatorLayer.init(layer: self.view.layer)
        repL.instanceCount = 2
        repL.instanceTransform = CATransform3DMakeRotation(CGFloat.init(Double.pi), 0, 0, 0)
        
        
        repL.instanceRedOffset -= 0.3
        repL.instanceGreenOffset -= 0.3
        repL.instanceBlueOffset -= 0.3
        repL.instanceAlphaOffset -= 0.3
        
        
        let layer = CALayer.init()
        layer.contents = UIImage.init(named: "4")?.cgImage
        repL.addSublayer(layer)
        
        
    }

}

